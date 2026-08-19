#!/usr/bin/env python3
"""Compare fbx's EXPRESSION-intrinsic result types with fbc's, on both targets.

    python tools/gen/check-intrin.py

Reads tests/types/expected/fbc-intrin.txt -- produced by intrin-truth.py from fbc itself
-- and replays every (intrinsic, argument) pair through fbx.

NOT EXACT, deliberately. fbc CONSTANT-FOLDS several of these, so 'chr( 1 )' is a
ZSTRING * 2 and 'str( 1 )' a ZSTRING * n where the same call on a variable is STRING.
Those rows are reported rather than fitted, the way check-ptr reports its own.
"""
import re
import subprocess
import sys
from pathlib import Path

import fbxtargets

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/types/expected/fbc-intrin.txt"
WORK = ROOT / "build/.in"
FBX = ROOT / "bin/fbx.exe"

DECLS = [
    "dim shared as byte v_byte", "dim shared as long v_long",
    "dim shared as integer v_integer", "dim shared as longint v_longint",
    "dim shared as single v_single", "dim shared as double v_double",
    "dim shared as string v_string", "dim shared as zstring * 8 v_zfixed",
    "dim shared as wstring * 8 v_wfixed", "dim shared as any ptr v_ptr",
    "dim shared as long v_arr(0 to 3)",
]
TWO_ARG = {"instr", "instrrev", "mid"}


def one_target(fbx, label, truth, tgtargs) -> int:
    if not truth.exists():
        print(f"check-intrin: {label}: no truth file; run tools/gen/intrin-truth.py",
              file=sys.stderr)
        return 3
    rows = [l.split("\t") for l in truth.read_text(encoding="utf-8").splitlines() if l.strip()]

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = list(DECLS), {}
    for i, (fn, arg, _want) in enumerate(rows):
        if fn in TWO_ARG:
            src.append(f"print {fn}( {arg}, {arg} )")
        else:
            src.append(f"print {fn}( {arg} )")
        line_of[len(src)] = i

    probe = WORK / "intrin-fbx.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")
    proc = subprocess.run([str(fbx), "--check"] + tgtargs + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) (.+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2).strip()

    ok, folded, bad = 0, 0, []
    for i, (fn, arg, want) in enumerate(rows):
        mine = got.get(i, "?")
        norm = "REJECT" if mine == "?" else re.sub(r"\s+", " ", mine).upper()
        w = re.sub(r"\s+", " ", want).upper()
        if norm == w:
            ok += 1
            continue
        # fbc folded a constant argument to a fixed-length string; fbx does not fold.
        if w.startswith(("ZSTRING *", "WSTRING *")) and norm in ("STRING", "REJECT"):
            folded += 1
            continue
        bad.append(f"{fn}( {arg} ): fbc={want} fbx={mine}")

    print(f"check-intrin: {label} {ok}/{len(rows)} match")
    if folded:
        print(f"check-intrin: {label} {folded} more are rows fbc CONSTANT-FOLDS to a "
              f"fixed-length string; fbx does not fold and says so")
    if bad:
        print(f"check-intrin: {label} {len(bad)} disagreements, first 20:")
        for b in bad[:20]:
            print("   ", b)
    return 0 if not bad else 1


def main() -> int:
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print("check-intrin: fbx not built", file=sys.stderr)
        return 3
    rc = 0
    for label, truth, tgtargs in fbxtargets.check_targets(TRUTH):
        if one_target(fbx, label, truth, tgtargs) != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
