#!/usr/bin/env python3
"""Compare fbx's expression typing with fbc's, over every combination fbc was asked.

    python tools/gen/check-promo.py

Reads tests/types/expected/fbc-promotion.txt -- produced by promo-truth.py from fbc
itself -- generates the SAME 3,920 combinations as fbx source, and compares row by
row. Two things are checked, because they are two different claims:

    result   for a pair fbc accepts, fbx must compute the same type
    legality for a pair fbc rejects, fbx must refuse to type it

A checker that types everything scores perfectly on the first and fails the second.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

TRUTH = ROOT / "tests/types/expected/fbc-promotion.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.ck"
FBX = ROOT / "bin/fbx.exe"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean", "string"]


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-promo: {LABEL} no truth file; run tools/gen/promo-truth.py", file=sys.stderr)
        return 3
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print(f"check-promo: {LABEL} fbx not built", file=sys.stderr)
        return 3

    rows = []
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        lt, op, rt, ok, res = line.split("\t")
        rows.append((lt, op, rt, ok, res))

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = [], {}
    for i, t in enumerate(TYPES):
        src.append(f"dim as {t} v{i}")
    for idx, (lt, op, rt, _ok, _res) in enumerate(rows):
        src.append(f"print v{TYPES.index(lt)} {op} v{TYPES.index(rt)}")
        line_of[len(src)] = idx          # 1-based source line -> row index

    probe = WORK / "promo-fbx.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(fbx), "--check"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) (.+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2).strip()

    res_ok = res_bad = leg_ok = leg_bad = missing = 0
    bad = []
    for idx, (lt, op, rt, ok, res) in enumerate(rows):
        if idx not in got:
            missing += 1
            continue
        mine = got[idx]
        if ok == "ok":
            if mine.lower() == res.lower():
                res_ok += 1
            else:
                res_bad += 1
                bad.append(f"{lt} {op} {rt}: fbc={res.lower()} fbx={mine}")
        else:
            if mine == "?":
                leg_ok += 1
            else:
                leg_bad += 1
                bad.append(f"{lt} {op} {rt}: fbc REJECTS, fbx={mine}")

    total_ok = sum(1 for r in rows if r[3] == "ok")
    total_rj = len(rows) - total_ok
    print(f"check-promo: {LABEL} result   {res_ok}/{total_ok} match")
    print(f"check-promo: {LABEL} legality {leg_ok}/{total_rj} match")
    if missing:
        print(f"check-promo: {LABEL} {missing} rows produced no output")
    if bad:
        print(f"check-promo: {LABEL} {len(bad)} disagreements, first 25:")
        for b in bad[:25]:
            print("   ", b)
    return 0 if (not bad and not missing) else 1


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
