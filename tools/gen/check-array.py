#!/usr/bin/env python3
"""Check fbx's array SLOT SIZES against the sizes fbc reserves.

    python tools/gen/check-array.py

An array slot that is too small does not fail: it writes over whatever the frame put
next to it, which is why this is gated rather than eyeballed. Local arrays were typed as
their ELEMENT before this gate existed -- four bytes where forty were needed.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

TRUTH = ROOT / "tests/types/expected/fbc-array.txt"
TGT = []
LABEL = "win64"
FBX = ROOT / "bin/fbx.exe"
SRC = ROOT / "build/.ar/arr.bas"


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-array: {LABEL} no truth file; run tools/gen/array-truth.py", file=sys.stderr)
        return 3
    if not SRC.exists():
        print(f"check-array: {LABEL} no probe source; run tools/gen/array-truth.py", file=sys.stderr)
        return 3

    want = {}
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        name, size = line.split("\t")
        want[name] = int(size)

    proc = subprocess.run([str(FBX), "--dump-ir"] + TGT + [str(SRC)],
                          capture_output=True, text=True, cwd=str(ROOT))
    got = {}
    for m in re.finditer(r"^\s*local agg (\w+) size (\d+)", proc.stdout, re.M):
        got[m.group(1).lower()] = int(m.group(2))

    bad = 0
    for name, size in sorted(want.items()):
        have = got.get(name)
        if have != size:
            bad += 1
            print(f"    {name}: fbc={size} fbx={have if have is not None else 'ABSENT'}")
    if bad:
        print(f"check-array: {LABEL} {bad}/{len(want)} array sizes DISAGREE with fbc")
        return 1
    print(f"check-array: {LABEL} {len(want)}/{len(want)} array sizes match fbc")
    return 0


def main() -> int:
    """Every target, against its own expectations file."""
    global TRUTH, TGT, LABEL
    rc = 0
    for LABEL, TRUTH, TGT in fbxtargets.check_targets(TRUTH):
        if one_target() != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
