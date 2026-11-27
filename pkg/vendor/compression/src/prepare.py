#!/usr/bin/env python3
"""prepare.py -- vendor/compression: the public headers of the six libraries as 'tiko c2t' reads
them. Five cannot be taken as shipped and are rewritten into c2t-ready copies; the rest are copied
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
  brotli/decode.h     BROTLI_DECODER_ERROR_CODES_LIST, an X-macro list with comments inside
                      its continuation lines (which c2t emits as uncompilable tiko -- a c2t bug),
                      expanded in place into the BrotliDecoderErrorCode enum it builds; the list
                      macro and its template comment dropped. The other brotli headers copied.
  bzlib.h             'BZ_EXTERN type BZ_API(name)' -> 'extern type name': the function-like
                      macro hides every function from c2t. The _WIN32 block (windows.h, WINAPI,
                      the dynamic-import function pointers) dropped: WINAPI is nothing on x64
                      and arm64, and the library is called directly, never through pointers.
  minizip/ioapi.h     its large-file defines dropped (see ioapi() below).
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
    inc = os.path.join(src, "brotli-1.2.1/c/include/brotli")
    for h in ("port", "types", "shared_dictionary", "encode"):
        write(os.path.join(out, "brotli", h + ".h"), read(os.path.join(inc, h + ".h")))
    s = read(os.path.join(inc, "decode.h"))
    start = s.find("#define BROTLI_DECODER_ERROR_CODES_LIST(")
    if start < 0:
        die("decode.h: no BROTLI_DECODER_ERROR_CODES_LIST")
    end = s.find("\n\n", start)
    body = s[start:end]
    items = re.findall(r"BROTLI_ERROR_CODE\((\w+), (\w+), (-?\d+)\)|/\*(.*?)\*/", body)
    if len([i for i in items if i[1]]) != 31:
        die("decode.h: expected 31 error codes, found %d" % len([i for i in items if i[1]]))
    # the template comment above the list ("Template that evaluates items of ...") goes too
    cstart = s.rfind("/**", 0, start)
    s = s[:cstart] + "/* BROTLI_DECODER_ERROR_CODES_LIST: expanded below (prepare.py). */" + s[end:]
    enum_use = re.compile(r"^[ \t]*BROTLI_DECODER_ERROR_CODES_LIST\(BROTLI_ERROR_CODE_ENUM_ITEM_, BROTLI_COMMA_\)[ \t]*$", re.M)
    if len(enum_use.findall(s)) != 1:
        die("decode.h: the enum's list invocation not found once")
    codes = [i for i in items if i[1]]
    lines = []
    for i in items:
        if i[1]:
            last = i is codes[-1]
            lines.append("  BROTLI_DECODER%s%s = %s%s" % (i[0], i[1], i[2], "" if last else ","))
        elif i[3].strip():
            lines.append("  /* %s */" % i[3].strip())
    s = enum_use.sub("\n".join(lines), s)
    for m in ("BROTLI_ERROR_CODE_ENUM_ITEM_", "BROTLI_COMMA_"):
        s = re.sub(r"^#define %s(?:.*\\\n)*.*\n" % m, "", s, flags=re.M)
        s = re.sub(r"^#undef %s.*\n" % m, "", s, flags=re.M)
    write(os.path.join(out, "brotli", "decode.h"), s)


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


def ioapi(src, out):
    # The large-file defines at its top (__USE_FILE_OFFSET64, __USE_LARGEFILE64,
    # _LARGEFILE64_SOURCE, _FILE_OFFSET_BIT) dropped: they steer the C library's own stdio
    # when minizip is COMPILED; a caller never needs them, and an empty _LARGEFILE64_SOURCE
    # breaks c2t's translation of zconf.h's '-_LARGEFILE64_SOURCE - -1 == 1' (a c2t bug).
    s = read(os.path.join(src, "zlib-1.4/contrib/minizip/ioapi.h"))
    a = s.find("        #ifndef __USE_FILE_OFFSET64\n")
    b = s.find("                #define _FILE_OFFSET_BIT 64\n        #endif\n", a)
    if a < 0 or b < 0:
        die("ioapi.h: the large-file define block not found")
    b += len("                #define _FILE_OFFSET_BIT 64\n        #endif\n")
    s = s[:a] + "        /* (large-file defines: dropped by prepare.py) */\n" + s[b:]
    write(os.path.join(out, "ioapi.h"), s)


def iowin32(src, out):
    s = read(os.path.join(src, "zlib-1.4/contrib/minizip/iowin32.h"))
    s = "#ifdef _WIN32\n#include \"ioapi.h\"\n" + s + "\n#endif /* _WIN32 */\n"
    write(os.path.join(out, "iowin32.h"), s)


# Copied as they are, so every header c2t reads sits in ONE directory, as the .ti files will in
# the package: c2t writes a local '#include "x.h"' as the path from the including header to x's
# .ti, so headers translated where upstream keeps them (zlib.h at the top, ioapi.h two levels
# down) would include "../../zlib.ti".
FLAT = ["zlib-1.4/zlib.h", "zlib-1.4/zconf.h",
        "zlib-1.4/contrib/minizip/ints.h",
        "zlib-1.4/contrib/minizip/zip.h", "zlib-1.4/contrib/minizip/unzip.h",
        "zstd-1.6.0/lib/zstd.h", "zstd-1.6.0/lib/zstd_errors.h", "zstd-1.6.0/lib/zdict.h",
        "lz4-1.11.1/lib/lz4.h", "lz4-1.11.1/lib/lz4hc.h", "lz4-1.11.1/lib/lz4frame.h"]


def main(src, out):
    for h in FLAT:
        write(os.path.join(out, os.path.basename(h)), read(os.path.join(src, h)))
    ioapi(src, out)
    lzma(src, out)
    brotli(src, out)
    bzlib(src, out)
    iowin32(src, out)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        die("usage: prepare.py <SRC> <OUT>")
    main(sys.argv[1], sys.argv[2])
