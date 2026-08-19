#!/usr/bin/env python3
"""Compare fbx's DECLARE/definition calling-convention rule with fbc's.

    python tools/gen/check-callconv.py

Reads tests/types/expected/fbc-callconv.txt -- produced by callconv-truth.py from fbc
itself -- and replays each pairing through fbx. A refusal is FBX0603.
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/types/expected/fbc-callconv.txt"
WORK = ROOT / "build/.cc"
FBX = ROOT / "bin/fbx.exe"


def spell(c):
    return "" if c == "none" else c + " "


def main() -> int:
    if not TRUTH.exists():
        print("check-callconv: no truth file; run tools/gen/callconv-truth.py",
              file=sys.stderr)
        return 3
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print("check-callconv: fbx not built", file=sys.stderr)
        return 3

    rows = [l.split("\t") for l in TRUTH.read_text(encoding="utf-8").splitlines() if l.strip()]
    WORK.mkdir(parents=True, exist_ok=True)

    ok, bad = 0, []
    for d, f, want in rows:
        src = (f"declare sub B {spell(d)}( byval x as long )\n"
               f"sub B {spell(f)}( byval x as long ) : end sub\n")
        p = WORK / "chk.bas"
        p.write_text(src, encoding="utf-8", newline="\n")
        proc = subprocess.run([str(fbx), "--check", str(p)],
                              capture_output=True, text=True)
        out = (proc.stdout or "") + (proc.stderr or "")
        got = "reject" if "FBX0603" in out else "accept"
        if got == want:
            ok += 1
        else:
            bad.append(f"declare {d} / definition {f}: fbc={want} fbx={got}")

    print(f"check-callconv: {ok}/{len(rows)} match")
    if bad:
        print(f"check-callconv: {len(bad)} disagreements:")
        for b in bad:
            print("   ", b)
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
