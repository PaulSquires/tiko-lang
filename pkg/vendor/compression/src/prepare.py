#!/usr/bin/env python3
"""prepare.py -- vendor/compression: the public headers of the six libraries as 'tiko c2t' reads
them. Three cannot be taken as shipped and are rewritten into c2t-ready copies; the rest are copied
unchanged (FLAT, below), so all of them sit in one directory. Everything else in each header --
comments, constants, declarations, order -- is the header's own, line for line.

    python -I prepare.py <SRC> <OUT>

SRC holds the six source archives of ../fetch.toml unpacked side by side (zlib-1.4/, zstd-1.6.0/,
...); OUT receives the headers translate.sh hands 'tiko c2t'. The library itself is built from the
untouched headers (build.sh); these are c2t's alone. Measured in RFC-0006 P0 (claude-docs
docs/tiko-vendor/probes/cp0/P0-RESULTS.md section 3).

  lzma.h              FLATTENED: its 14 '#include "lzma/x.h"' lines replaced by those files'
                      text, and the attribute macros after each declaration dropped (lzma()
                      below). The sub-headers are fragments (each #errors without LZMA_H_INTERNAL
                      and uses lzma.h's types), so none translates on its own.
  bzlib.h             'BZ_EXTERN type BZ_API(name)' -> 'extern type name': the function-like
                      macro hides every function from c2t. The _WIN32 block (windows.h, WINAPI,
                      the dynamic-import function pointers) dropped: WINAPI is nothing on x64
                      and arm64, and the library is called directly, never through pointers.
  minizip/iowin32.h   gains '#include "ioapi.h"' (it uses ioapi's types without including it)
                      and an '#ifdef _WIN32' around its body (it includes windows.h): Windows-only.

The output is deterministic: the same input gives the same bytes.
"""
import os
import re
import sys


def die(msg):
    sys.exit("prepare.py: " + msg)


def read(p):
    with open(p, encoding="utf-8", newline="") as f:
        return f.read().replace("\r\n", "\n")


def write(p, s):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8", newline="\n") as f:
        f.write(s)


def lzma(src, out):
    api = os.path.join(src, "xz-5.8.4/src/liblzma/api")
    s = read(os.path.join(api, "lzma.h"))
    inc = re.compile(r'^#include "lzma/(\w+)\.h"[ \t]*$', re.M)
    n = len(inc.findall(s))
    if n != 14:
        die("lzma.h: expected 14 sub-header includes, found %d" % n)
    s = inc.sub(lambda m: "/* ---- lzma/%s.h ---- */\n%s/* ---- end lzma/%s.h ---- */"
                % (m.group(1), read(os.path.join(api, "lzma", m.group(1) + ".h")), m.group(1)), s)
    # The attribute macros after each declaration -- lzma_nothrow, lzma_attr_pure/const/
    # warn_unused_result -- dropped outside their own #define lines: GCC attributes in the Linux
    # pass and nothing in the Windows one, they made the passes disagree on where every
    # function ends (c2t: guard-unstatable, the function lost); defined away (c2t-all.sh -D)
    # they leave a TODO of trailing text per function. Nothing to a caller either way.
    attr = re.compile(r"[ \t]*\b(?:lzma_nothrow|lzma_attr_pure|lzma_attr_const|lzma_attr_warn_unused_result)\b")
    s = "\n".join(l if l.lstrip().startswith("#") else attr.sub("", l) for l in s.split("\n"))
    s = re.sub(r"\)\n[ \t]*;", ");", s)
    write(os.path.join(out, "lzma.h"), s)


def brotli(src, out):
    # All five as shipped. decode.h's BROTLI_DECODER_ERROR_CODES_LIST (an X-macro with comments in
    # its continuation lines) was expanded here by hand until c2t kept such a comment inside the
    # directive (tiko-lang 2cc419b30): now the list is one TODO and the enum it builds keeps
    # clang's values.
    inc = os.path.join(src, "brotli-1.2.1/c/include/brotli")
    for h in ("port", "types", "shared_dictionary", "encode", "decode"):
        write(os.path.join(out, "brotli", h + ".h"), read(os.path.join(inc, h + ".h")))


def bzlib(src, out):
    s = read(os.path.join(src, "bzip2-1.0.8/bzlib.h"))
    a = s.find("#ifdef _WIN32\n#   include <windows.h>")
    b = s.find("#else\n#   define BZ_API(func) func\n#   define BZ_EXTERN extern\n#endif\n", a)
    if a < 0 or b < 0:
        die("bzlib.h: the _WIN32 BZ_API block not found")
    s = s[:a] + s[b + len("#else\n#   define BZ_API(func) func\n#   define BZ_EXTERN extern\n#endif\n"):]
    n = len(re.findall(r"BZ_API\(\w+\)", s))
    s = re.sub(r"BZ_API\((\w+)\)", r"\1", s)
    s = s.replace("BZ_EXTERN ", "extern ")
    if n != 24 or "BZ_API" in s or "BZ_EXTERN" in s:
        die("bzlib.h: expected 24 BZ_API functions, found %d" % n)
    write(os.path.join(out, "bzlib.h"), s)


def iowin32(src, out):
    s = read(os.path.join(src, "zlib-1.4/contrib/minizip/iowin32.h"))
    s = "#ifdef _WIN32\n#include \"ioapi.h\"\n" + s + "\n#endif /* _WIN32 */\n"
    write(os.path.join(out, "iowin32.h"), s)


# Copied as they are (ioapi.h too: its empty _LARGEFILE64_SOURCE broke c2t's translation of
# zconf.h's '-_LARGEFILE64_SOURCE - -1 == 1' until tiko-lang 2cc419b30), so every header c2t reads
# sits in ONE directory, as the .ti files will in
# the package: c2t writes a local '#include "x.h"' as the path from the including header to x's
# .ti, so headers translated where upstream keeps them (zlib.h at the top, ioapi.h two levels
# down) would include "../../zlib.ti".
FLAT = ["zlib-1.4/zlib.h", "zlib-1.4/zconf.h",
        "zlib-1.4/contrib/minizip/ints.h", "zlib-1.4/contrib/minizip/ioapi.h",
        "zlib-1.4/contrib/minizip/zip.h", "zlib-1.4/contrib/minizip/unzip.h",
        "zstd-1.6.0/lib/zstd.h", "zstd-1.6.0/lib/zstd_errors.h", "zstd-1.6.0/lib/zdict.h",
        "lz4-1.11.1/lib/lz4.h", "lz4-1.11.1/lib/lz4hc.h", "lz4-1.11.1/lib/lz4frame.h"]


def main(src, out):
    for h in FLAT:
        write(os.path.join(out, os.path.basename(h)), read(os.path.join(src, h)))
    lzma(src, out)
    brotli(src, out)
    bzlib(src, out)
    iowin32(src, out)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        die("usage: prepare.py <SRC> <OUT>")
    main(sys.argv[1], sys.argv[2])
