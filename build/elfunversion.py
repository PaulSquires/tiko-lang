#!/usr/bin/env python3
# elfunversion.py -- drop an ELF executable's symbol-version requirements on named libraries.
#
#   python3 build/elfunversion.py FILE LIB [LIB...]      e.g. bin/tiko libtinfo.so.6
#
# WHY: tiko's runtime links libtinfo. Linked on Ubuntu/Debian, whose libtinfo versions every
# symbol (NCURSES6_TINFO_5.0.19991023), the executable records a version requirement on it.
# Fedora and Arch build libtinfo WITHOUT symbol versions, and glibc's loader then prints
#     /lib64/libtinfo.so.6: no version information available (required by .../tiko)
# on every start. glibc warns once per Verneed ENTRY, not per symbol, so clearing the symbols'
# versions (patchelf --clear-symbol-version) leaves the warning: the entry has to go.
#
# WHAT: the library's entry is removed from .gnu.version_r (the rest rewritten in place, the
# tail zeroed), DT_VERNEEDNUM and the section's sh_info drop by one, and every .gnu.version
# slot that named one of its versions becomes 1 (global). An unversioned reference binds to the
# library's default version, so the result runs unchanged where libtinfo IS versioned.
#
# ELF64 little-endian only (x86-64, arm64). Idempotent: a file with no such entry is left as
# it is. Needs section headers -- a stripped-of-sections file is refused, not guessed at.

import os
import struct
import sys

SHT_DYNAMIC = 6
SHT_GNU_VERNEED = 0x6FFFFFFE
SHT_GNU_VERSYM = 0x6FFFFFFF
DT_NULL = 0
DT_VERNEEDNUM = 0x6FFFFFFF


def die(msg):
    sys.stderr.write("elfunversion: %s\n" % msg)
    sys.exit(1)


def cstr(buf, off):
    end = buf.index(b"\0", off)
    return buf[off:end].decode("latin-1")


def main(argv):
    if len(argv) < 3:
        die("usage: elfunversion.py FILE LIB [LIB...]")
    path, libs = argv[1], set(argv[2:])
    with open(path, "rb") as f:
        b = bytearray(f.read())

    if b[:4] != b"\x7fELF":
        die("%s: not an ELF file" % path)
    if b[4] != 2 or b[5] != 1:
        die("%s: not ELF64 little-endian" % path)

    shoff, = struct.unpack_from("<Q", b, 0x28)
    shentsize, shnum = struct.unpack_from("<HH", b, 0x3A)
    if shoff == 0 or shnum == 0:
        die("%s: no section headers" % path)

    secs = []
    for i in range(shnum):
        o = shoff + i * shentsize
        (name, typ, flags, addr, off, size, link, info, align, entsize) = \
            struct.unpack_from("<IIQQQQIIQQ", b, o)
        secs.append(dict(hdr=o, type=typ, off=off, size=size, link=link, info=info))

    vn = [s for s in secs if s["type"] == SHT_GNU_VERNEED]
    vs = [s for s in secs if s["type"] == SHT_GNU_VERSYM]
    dy = [s for s in secs if s["type"] == SHT_DYNAMIC]
    if not vn:
        print("elfunversion: %s: no version requirements -- nothing to do" % path)
        return 0
    if not vs or not dy:
        die("%s: .gnu.version_r without .gnu.version or .dynamic" % path)
    vn, vs, dy = vn[0], vs[0], dy[0]
    strtab = secs[vn["link"]]["off"]

    # Read the Verneed chain.
    entries = []
    o = vn["off"]
    for _ in range(vn["info"]):
        ver, cnt, file_, aux, nxt = struct.unpack_from("<HHIII", b, o)
        auxs = []
        a = o + aux
        for _ in range(cnt):
            h, fl, other, nm, anext = struct.unpack_from("<IHHII", b, a)
            auxs.append((h, fl, other, nm))
            a += anext
        entries.append((ver, file_, auxs))
        if nxt == 0:
            break
        o += nxt
    if len(entries) != vn["info"]:
        die("%s: .gnu.version_r holds %d entries, sh_info says %d" % (path, len(entries), vn["info"]))

    keep = [e for e in entries if cstr(b, strtab + e[1]) not in libs]
    drop = [e for e in entries if cstr(b, strtab + e[1]) in libs]
    if not drop:
        print("elfunversion: %s: no version requirement on %s -- nothing to do" % (path, " ".join(sorted(libs))))
        return 0
    gone = set(aux[2] for e in drop for aux in e[2])

    # Rewrite the kept entries in place, each followed by its aux records, the tail zeroed.
    out = bytearray()
    for k, (ver, file_, auxs) in enumerate(keep):
        last = k == len(keep) - 1
        out += struct.pack("<HHIII", ver, len(auxs), file_, 16 if auxs else 0,
                           0 if last else 16 + 16 * len(auxs))
        for j, (h, fl, other, nm) in enumerate(auxs):
            out += struct.pack("<IHHII", h, fl, other, nm, 0 if j == len(auxs) - 1 else 16)
    if len(out) > vn["size"]:
        die("%s: rewritten .gnu.version_r outgrew the section" % path)
    out += b"\0" * (vn["size"] - len(out))
    b[vn["off"]:vn["off"] + vn["size"]] = out
    struct.pack_into("<I", b, vn["hdr"] + 0x2C, len(keep))          # sh_info

    # DT_VERNEEDNUM in .dynamic.
    found = False
    for o in range(dy["off"], dy["off"] + dy["size"], 16):
        tag, val = struct.unpack_from("<qQ", b, o)
        if tag == DT_NULL:
            break
        if tag == DT_VERNEEDNUM:
            struct.pack_into("<qQ", b, o, tag, len(keep))
            found = True
    if not found:
        die("%s: no DT_VERNEEDNUM in .dynamic" % path)

    # Every symbol that named a dropped version becomes global (1); the hidden bit is kept.
    cleared = 0
    for o in range(vs["off"], vs["off"] + vs["size"], 2):
        v, = struct.unpack_from("<H", b, o)
        if (v & 0x7FFF) in gone:
            struct.pack_into("<H", b, o, (v & 0x8000) | 1)
            cleared += 1

    tmp = path + ".elfunversion"
    with open(tmp, "wb") as f:
        f.write(b)
    os.chmod(tmp, os.stat(path).st_mode)
    os.replace(tmp, path)
    names = [cstr(b, strtab + e[1]) for e in drop]
    print("elfunversion: %s: dropped the version requirement on %s (%d symbols now unversioned)"
          % (path, " ".join(names), cleared))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
