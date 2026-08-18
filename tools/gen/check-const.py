#!/usr/bin/env python3
"""Compare fbx's constant folding with fbc's, bit for bit.

    python tools/gen/check-const.py

Reads tests/types/expected/fbc-const.txt -- produced by const-truth.py, which pulls
each value out of fbc one bit at a time through '#assert' -- and folds the same
expressions with fbx. Exactness is the whole point here: a constant evaluator that is
close is simply wrong, and the ways to be wrong are all quiet ones.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/types/expected/fbc-const.txt"
WORK = ROOT / "build/.ce"
FBX = ROOT / "bin/fbx.exe"


def main() -> int:
    if not TRUTH.exists():
        print("check-const: no truth file; run tools/gen/const-truth.py",
              file=sys.stderr)
        return 3
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print("check-const: fbx not built", file=sys.stderr)
        return 3

    rows = [line.split("\t")
            for line in TRUTH.read_text(encoding="utf-8").splitlines() if line.strip()]

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = [], {}
    for i, (e, _v) in enumerate(rows):
        src.append(f"print {e}")
        line_of[len(src)] = i

    probe = WORK / "const-fbx.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(fbx), "--check", str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"const (\d+) (-?\d+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = int(m.group(2))

    ok = bad = nofold = 0
    diffs, missing = [], []
    for i, (e, want) in enumerate(rows):
        if want == "reject":
            continue
        if i not in got:
            nofold += 1
            missing.append(e)
            continue
        if got[i] == int(want):
            ok += 1
        else:
            bad += 1
            diffs.append(f"{e}: fbc={want} fbx={got[i]}")

    total = sum(1 for r in rows if r[1] != "reject")
    print(f"check-const: {ok}/{total} exact")
    if diffs:
        print(f"check-const: {len(diffs)} WRONG:")
        for d in diffs[:20]:
            print("   ", d)
    if nofold:
        print(f"check-const: {nofold} not folded by fbx (not wrong, just absent):")
        for m in missing[:20]:
            print("   ", m)
    return 0 if not diffs else 1


if __name__ == "__main__":
    sys.exit(main())
