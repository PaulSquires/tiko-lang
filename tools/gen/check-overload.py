#!/usr/bin/env python3
"""Compare tiko-lang's overload choice with fbc's, over every measured combination.

    python tools/gen/check-overload.py

Reads tests/types/expected/fbc-overload.txt -- produced by overload-truth.py from fbc
itself -- rebuilds the same candidate pairs as tiko-lang source, and compares. The two
candidates have distinct RETURN types, so the type tiko-lang computes for the call says
which one it picked: BYTE for the first, SHORT for the second.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

TRUTH = ROOT / "tests/types/expected/fbc-overload.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.ov"
TKO = ROOT / "bin/tiko.exe"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean", "string"]


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-overload: {LABEL} no truth file; run tools/gen/overload-truth.py",
              file=sys.stderr)
        return 3
    tiko = TKO if TKO.exists() else ROOT / "bin/tiko"
    if not tiko.exists():
        print(f"check-overload: {LABEL} tiko not built", file=sys.stderr)
        return 3

    rows = [line.split("\t")
            for line in TRUTH.read_text(encoding="utf-8").splitlines() if line.strip()]

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = [], {}
    for i, t in enumerate(TYPES):
        src.append(f"dim as {t} v{i}")
    idx = 0
    pair_id = 0
    for ai in range(len(TYPES)):
        for bi in range(ai + 1, len(TYPES)):
            fn = f"f{pair_id}"
            pair_id += 1
            src.append(f"declare function {fn} overload ( byval x as {TYPES[ai]} ) as byte")
            src.append(f"declare function {fn} overload ( byval x as {TYPES[bi]} ) as short")
            for gi in range(len(TYPES)):
                src.append(f"print {fn}( v{gi} )")
                line_of[len(src)] = idx
                idx += 1

    probe = WORK / "ovl-tiko.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(tiko), "--check"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) (.+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2).strip()

    pick_ok = pick_bad = rej_ok = rej_bad = missing = 0
    bad = []
    for i, (a, b, g, want) in enumerate(rows):
        if i not in got:
            missing += 1
            continue
        mine = got[i]
        if want == "reject":
            if mine == "?":
                rej_ok += 1
            else:
                rej_bad += 1
                bad.append(f"{a} vs {b}, arg {g}: fbc REJECTS, tiko-lang picked "
                           f"{'first' if mine == 'byte' else 'second'}")
            continue
        # byte marks the first candidate, short the second
        chose = a if mine == "byte" else (b if mine == "short" else "?")
        if chose == want:
            pick_ok += 1
        else:
            pick_bad += 1
            bad.append(f"{a} vs {b}, arg {g}: fbc={want} tiko={chose}")

    total_pick = sum(1 for r in rows if r[3] != "reject")
    total_rej = len(rows) - total_pick
    print(f"check-overload: {LABEL} choice   {pick_ok}/{total_pick} match")
    print(f"check-overload: {LABEL} rejects  {rej_ok}/{total_rej} match")
    if missing:
        print(f"check-overload: {LABEL} {missing} rows produced no output")
    if bad:
        print(f"check-overload: {LABEL} {len(bad)} disagreements, first 20:")
        for b in bad[:20]:
            print("   ", b)
    return 0 if (not bad and not missing) else 1


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
