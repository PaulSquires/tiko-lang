#!/usr/bin/env python3
"""List the symbols of a COFF/PE object file -- a standalone 'nm -g'.

The toolchain ships no nm or objdump, and the D3 mangling gate has to be checked
against what the LINKER sees rather than against fbc's C intermediate, whose names
carry the C emitter's own decoration.

    python tools/gen/coffsyms.py <file.o> [--all] [--functions]

Prints one symbol per line: the external (linker-visible) ones by default.
--functions keeps only symbols that live in a CODE section, which is what a
procedure-name comparison wants: an object file's externals also include public
variables and the linker's own .refptr.* indirection stubs for imported data.
"""
import struct
import sys
from pathlib import Path

IMAGE_SYM_CLASS_EXTERNAL = 2
IMAGE_SCN_CNT_CODE = 0x00000020


def code_sections(data: bytes) -> set:
    """1-based indices of the sections holding executable code."""
    _, nsections, _, _, _, optsize, _ = struct.unpack_from("<HHIIIHH", data, 0)
    base = 20 + optsize
    out = set()
    for i in range(nsections):
        chars = struct.unpack_from("<I", data, base + i * 40 + 36)[0]
        if chars & IMAGE_SCN_CNT_CODE:
            out.add(i + 1)
    return out


def symbols(path: Path):
    data = path.read_bytes()
    # COFF header: machine, nsections, timestamp, symtab offset, nsymbols, ...
    _, _, _, symptr, nsyms, _, _ = struct.unpack_from("<HHIIIHH", data, 0)
    if symptr == 0 or nsyms == 0:
        return
    strtab = symptr + nsyms * 18
    out = []
    i = 0
    while i < nsyms:
        off = symptr + i * 18
        raw = data[off:off + 8]
        value, secnum, _, sclass, naux = struct.unpack_from("<IhHBB", data, off + 8)
        if raw[:4] == b"\0\0\0\0":
            # long name: offset into the string table
            soff = strtab + struct.unpack_from("<I", raw, 4)[0]
            end = data.index(b"\0", soff)
            name = data[soff:end].decode("utf-8", "replace")
        else:
            name = raw.rstrip(b"\0").decode("utf-8", "replace")
        out.append((name, sclass, secnum, value))
        i += 1 + naux
    return out


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    show_all = "--all" in sys.argv
    path = Path(sys.argv[1])
    code = code_sections(path.read_bytes()) if "--functions" in sys.argv else None
    for name, sclass, secnum, _ in symbols(path) or []:
        if show_all:
            print(name)
            continue
        if sclass != IMAGE_SYM_CLASS_EXTERNAL or secnum <= 0:
            continue
        if code is not None and secnum not in code:
            continue
        print(name)
    return 0


if __name__ == "__main__":
    sys.exit(main())
