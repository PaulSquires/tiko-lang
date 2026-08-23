#!/usr/bin/env python3
"""Compare tiko-lang's DECLARE/definition calling-convention rule with fbc's.

    python tools/gen/check-callconv.py

Reads tests/types/expected/fbc-callconv.txt -- produced by callconv-truth.py from fbc
itself -- and replays each pairing through tiko-lang. A refusal is TKO0603.
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

TRUTH = ROOT / "tests/types/expected/fbc-callconv.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.cc"
TKO = ROOT / "bin/tiko.exe"


def spell(c):
    return "" if c == "none" else c + " "


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-callconv: {LABEL} no truth file; run tools/gen/callconv-truth.py",
              file=sys.stderr)
        return 3
    tiko = TKO if TKO.exists() else ROOT / "bin/tiko"
    if not tiko.exists():
        print(f"check-callconv: {LABEL} tiko not built", file=sys.stderr)
        return 3

    rows = [l.split("\t") for l in TRUTH.read_text(encoding="utf-8").splitlines() if l.strip()]
    WORK.mkdir(parents=True, exist_ok=True)

    ok, bad = 0, []
    for d, f, want in rows:
        src = (f"declare sub B {spell(d)}( byval x as long )\n"
               f"sub B {spell(f)}( byval x as long ) : end sub\n")
        p = WORK / "chk.bas"
        p.write_text(src, encoding="utf-8", newline="\n")
        proc = subprocess.run([str(tiko), "--check"] + TGT + [str(p)],
                              capture_output=True, text=True)
        out = (proc.stdout or "") + (proc.stderr or "")
        got = "reject" if "TKO0603" in out else "accept"
        if got == want:
            ok += 1
        else:
            bad.append(f"declare {d} / definition {f}: fbc={want} tiko={got}")

    print(f"check-callconv: {LABEL} {ok}/{len(rows)} match")
    if bad:
        print(f"check-callconv: {LABEL} {len(bad)} disagreements:")
        for b in bad:
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
