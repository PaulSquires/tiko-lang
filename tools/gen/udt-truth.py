#!/usr/bin/env python3
"""Extract FBC's UDT layout: the size, alignment and field offsets it computes.

    python tools/gen/udt-truth.py

Writes tests/types/expected/fbc-udt.txt. A struct's layout is ABI, so it is
compatibility surface in the strictest sense: a field at the wrong offset does not
fail, it reads the neighbouring field's bytes.

Unlike the promotion and constant tables, this one is measured by COMPILING AND
RUNNING a program. 'sizeof' and 'offsetof' are compile-time constants in fbc but
'#print' does not fold, so the value has to be printed at run time to be seen.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FBC = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe")
OUT = ROOT / "tests/types/expected/fbc-udt.txt"
WORK = ROOT / "build/.ud"

# Each case is (name, declaration text, field names to probe). The shapes chosen are
# the ones where a layout algorithm goes wrong quietly: mixed widths needing padding,
# a trailing small field needing tail padding, nesting, unions, arrays, and FIELD=n.
CASES = [
    ("Ordered",   "type Ordered\n as byte b\n as long l\n as short s\nend type", ["b", "l", "s"]),
    ("Reordered", "type Reordered\n as long l\n as short s\n as byte b\nend type", ["l", "s", "b"]),
    ("AllByte",   "type AllByte\n as byte a\n as byte b\n as byte c\nend type", ["a", "b", "c"]),
    ("Wide",      "type Wide\n as byte b\n as double d\nend type", ["b", "d"]),
    ("LongIntMix","type LongIntMix\n as long l\n as longint q\n as long l2\nend type", ["l", "q", "l2"]),
    ("PtrMix",    "type PtrMix\n as short s\n as any ptr p\n as byte b\nend type", ["s", "p", "b"]),
    ("WithStr",   "type WithStr\n as byte b\n as string s\n as byte c\nend type", ["b", "s", "c"]),
    ("Nested",    "type Inner1\n as long a\n as byte b\nend type\ntype Nested\n as byte x\n as Inner1 i\n as byte y\nend type", ["x", "i", "y"]),
    ("WithUnion", "type WithUnion\n as byte b\n union\n  as long l\n  as double d\n end union\n as byte c\nend type", ["b", "l", "d", "c"]),   # the union MEMBERS must be probed: without
        # them the shape passes with the members laid out sequentially, because
        # only b and c are checked and those two offsets coincide.
    ("ArrField",  "type ArrField\n as byte b\n as long a(0 to 3)\n as byte c\nend type", ["b", "a(0)", "c"]),
    ("Field1",    "type Field1 field = 1\n as byte b\n as long l\n as short s\nend type", ["b", "l", "s"]),
    ("Field2",    "type Field2 field = 2\n as byte b\n as long l\n as short s\nend type", ["b", "l", "s"]),
    ("Field4",    "type Field4 field = 4\n as byte b\n as double d\nend type", ["b", "d"]),
    ("Single1",   "type Single1\n as byte b\nend type", ["b"]),
    ("Empty1",    "type Empty1\n as long dummy\nend type", ["dummy"]),
    ("FloatMix",  "type FloatMix\n as single f\n as double d\n as single g\nend type", ["f", "d", "g"]),
    ("Bools",     "type Bools\n as boolean p\n as long l\n as boolean q\nend type", ["p", "l", "q"]),
    ("Arr2D", "type Arr2D\n as byte b\n as long a(0 to 1, 0 to 2)\n as byte c\nend type", ["b", "a(0,0)", "c"]),
    ("ArrShort", "type ArrShort\n as short s(1 to 3)\n as byte c\nend type", ["s(1)", "c"]),
    ("ZStrOdd", "type ZStrOdd\n as zstring * 3 z\n as long l\nend type", ["z", "l"]),
    ("WStrField", "type WStrField\n as byte b\n as wstring * 4 w\n as byte c\nend type", ["b", "w", "c"]),
    ("Field8", "type Field8 field = 8\n as byte b\n as double d\nend type", ["b", "d"]),
    ("ArrOfUdt", "type ElemU\n as long a\n as byte b\nend type\ntype ArrOfUdt\n as byte x\n as ElemU e(0 to 1)\n as byte y\nend type", ["x", "e(0)", "y"]),
    ("ZStrField", "type ZStrField\n as byte b\n as zstring * 5 z\n as byte c\nend type", ["b", "z", "c"]),
]


def main() -> int:
    if not FBC.exists():
        print(f"udt-truth: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    lines, order = [], []
    seen_decl = set()
    for name, decl, fields in CASES:
        if decl not in seen_decl:
            lines.append(decl)
            seen_decl.add(decl)
    # fbc has no 'alignof'. The alignment is MEASURED the same way
    # tools/gen/layout-truth.sh measures the builtins': the offset of a field placed
    # after a single byte is exactly the type's alignment.
    for name, decl, fields in CASES:
        lines.append("type Align_" + name)
        lines.append(" as byte pad_")
        lines.append(" as " + name + " v_")
        lines.append("end type")
    for name, decl, fields in CASES:
        lines.append('print "' + name + ' size "; sizeof(' + name +
                     '); " align "; offsetof(Align_' + name + ', v_)')
        for f in fields:
            lines.append(f'print "{name} off {f} "; offsetof({name}, {f})')
        order.append((name, fields))

    src = WORK / "udt.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")

    exe = WORK / "udt.exe"
    proc = subprocess.run([str(FBC), str(src), "-x", str(exe)],
                          capture_output=True, text=True)
    if proc.returncode != 0:
        print("udt-truth: fbc rejected the probe:\n" + (proc.stdout or "") + (proc.stderr or ""),
              file=sys.stderr)
        return 1

    run = subprocess.run([str(exe)], capture_output=True, text=True)
    rows = []
    for line in (run.stdout or "").splitlines():
        line = " ".join(line.split())
        m = re.fullmatch(r"(\w+) size (\d+) align (\d+)", line)
        if m:
            rows.append(f"{m.group(1)}\tsize\t{m.group(2)}\t{m.group(3)}")
            continue
        m = re.fullmatch(r"(\w+) off (\S+) (\d+)", line)
        if m:
            rows.append(f"{m.group(1)}\toff\t{m.group(2)}\t{m.group(3)}")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"udt-truth: {len(rows)} facts over {len(CASES)} shapes "
          f"-> tests/types/expected/fbc-udt.txt")
    return 0


if __name__ == "__main__":
    sys.exit(main())
