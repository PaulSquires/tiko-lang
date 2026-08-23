#!/usr/bin/env python3
"""Compare tiko-lang's assignment legality with fbc's, over every measured pair.

    python tools/gen/check-assign.py

Reads tests/types/expected/fbc-assign.txt -- produced by assign-truth.py from fbc
itself -- rebuilds the same assignments as tiko-lang source, and compares the verdicts.
'warn' is kept distinct from 'ok': fbc accepts a pointer/integer assignment but says
something about it, and collapsing the two would hide a real difference in behaviour.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

TRUTH = ROOT / "tests/types/expected/fbc-assign.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.as"
TKO = ROOT / "bin/tiko.exe"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean",
         "string", "any ptr", "long ptr", "zstring ptr", "wstring ptr"]


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-assign: {LABEL} no truth file; run tools/gen/assign-truth.py",
              file=sys.stderr)
        return 3
    tiko = TKO if TKO.exists() else ROOT / "bin/tiko"
    if not tiko.exists():
        print(f"check-assign: {LABEL} tiko not built", file=sys.stderr)
        return 3

    rows = [line.split("\t")
            for line in TRUTH.read_text(encoding="utf-8").splitlines() if line.strip()]

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = [], {}
    for i, t in enumerate(TYPES):
        src.append(f"dim as {t} v{i}")
    idx = 0
    for di in range(len(TYPES)):
        for si in range(len(TYPES)):
            src.append(f"v{di} = v{si}")
            line_of[len(src)] = idx
            idx += 1

    probe = WORK / "assign-tiko.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(tiko), "--check"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) assign:(\w+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2)

    ok = bad = missing = 0
    diffs = []
    for i, (dt, st, want) in enumerate(rows):
        if i not in got:
            missing += 1
            continue
        mine = got[i]
        if mine == want:
            ok += 1
        else:
            bad += 1
            diffs.append(f"{dt} = {st}: fbc={want} tiko={mine}")

    print(f"check-assign: {LABEL} {ok}/{len(rows)} match")
    if missing:
        print(f"check-assign: {LABEL} {missing} rows produced no output")
    if diffs:
        print(f"check-assign: {LABEL} {len(diffs)} disagreements, first 20:")
        for d in diffs[:20]:
            print("   ", d)
    return 0 if (not diffs and not missing) else 1


def main() -> int:
    """Every target, against its own expectations file."""
    global TRUTH, TGT, LABEL
    rc = 0
    for LABEL, TRUTH, TGT in tkotargets.check_targets(TRUTH):
        if one_target() != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
