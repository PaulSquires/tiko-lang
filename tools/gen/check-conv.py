#!/usr/bin/env python3
"""Compare tiko-lang's conversion-intrinsic result types with fbc's.

    python tools/gen/check-conv.py

Reads tests/types/expected/fbc-conv.txt -- produced by conv-truth.py from fbc itself --
and replays every (intrinsic, argument type) through tiko-lang, printing the expression so
'--check' names the type it computed.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

TRUTH = ROOT / "tests/types/expected/fbc-conv.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.conv"
TKO = ROOT / "bin/tiko.exe"

DECLS = [
    "dim shared as byte a_byte", "dim shared as ubyte a_ubyte",
    "dim shared as short a_short", "dim shared as ushort a_ushort",
    "dim shared as long a_long", "dim shared as ulong a_ulong",
    "dim shared as integer a_integer", "dim shared as uinteger a_uinteger",
    "dim shared as longint a_longint", "dim shared as ulongint a_ulongint",
    "dim shared as single a_single", "dim shared as double a_double",
    "dim shared as boolean a_boolean", "dim shared as string a_string",
    "dim shared as zstring * 8 a_zstring", "dim shared as wstring * 8 a_wstring",
    "dim shared as any ptr a_anyptr", "dim shared as long ptr a_longptr",
]


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-conv: {LABEL} no truth file; run tools/gen/conv-truth.py", file=sys.stderr)
        return 3
    tiko = TKO if TKO.exists() else ROOT / "bin/tiko"
    if not tiko.exists():
        print(f"check-conv: {LABEL} tiko not built", file=sys.stderr)
        return 3

    rows = [l.split("\t") for l in TRUTH.read_text(encoding="utf-8").splitlines() if l.strip()]
    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = list(DECLS), {}
    for i, (fn, an, _want) in enumerate(rows):
        m = re.fullmatch(r"(cast|cptr)\((.+)\)", fn)
        if m:
            src.append(f"print {m.group(1)}( {m.group(2)}, a_{an} )")
        else:
            src.append(f"print {fn}( a_{an} )")
        line_of[len(src)] = i

    probe = WORK / "conv-tiko.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(tiko), "--check"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) (.+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2).strip()

    ok = 0
    bad = []
    for i, (fn, an, want) in enumerate(rows):
        mine = got.get(i, "?")
        # fbc spells them upper-case and tiko-lang lower; a refusal is '?' either way.
        norm = "reject" if mine == "?" else mine.upper()
        w = want if want == "reject" else want.upper()
        # 'ZSTRING * 8' vs 'ZSTRING * 8' -- fbc pads differently, so squeeze spaces.
        if re.sub(r"\s+", " ", norm) == re.sub(r"\s+", " ", w):
            ok += 1
        else:
            bad.append(f"{fn}( {an} ): fbc={want} tiko={mine}")

    print(f"check-conv: {LABEL} {ok}/{len(rows)} match")
    if bad:
        print(f"check-conv: {LABEL} {len(bad)} disagreements, first 20:")
        for b in bad[:20]:
            print("   ", b)
    return 0 if not bad else 1


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
