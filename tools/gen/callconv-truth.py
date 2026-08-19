#!/usr/bin/env python3
"""Ask FBC ITSELF which DECLARE/definition calling-convention pairings it accepts.

    python tools/gen/callconv-truth.py

Writes tests/types/expected/fbc-callconv.txt and fbc-callconv-win32.txt: one row per (declaration convention,
definition convention) giving accept or reject.

The rule is ASYMMETRIC and none of it follows from the names: absence on the DEFINITION
inherits whatever the declaration said, while absence on the DECLARATION means STDCALL,
so a cdecl definition of a plain declaration is refused. fbc reports the same error on
win64, where the convention has no effect on any emitted name at all, which is what says
this is a syntactic rule rather than a target one.
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

FBC = fbxtargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-callconv.txt"
WORK = ROOT / "build/.cc"

CONVS = ["none", "cdecl", "stdcall", "pascal"]


def spell(c):
    return "" if c == "none" else c + " "


def one_target() -> int:
    if not FBC.exists():
        print(f"callconv-truth: {LABEL}: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    rows = []
    for d in CONVS:
        for f in CONVS:
            src = (f"declare sub B {spell(d)}( byval x as long )\n"
                   f"sub B {spell(f)}( byval x as long ) : end sub\n")
            p = WORK / "one.bas"
            p.write_text(src, encoding="utf-8", newline="\n")
            proc = subprocess.run([str(FBC), "-c", str(p), "-o", str(WORK / "one.o")],
                                  capture_output=True, text=True)
            out = (proc.stdout or "") + (proc.stderr or "")
            rows.append(f"{d}\t{f}\t" + ("reject" if "error 41" in out else "accept"))

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    nrej = sum(1 for r in rows if r.endswith("reject"))
    print(f"callconv-truth: {LABEL}: {len(rows)} rows, {nrej} rejected -> "
          f"{OUT.name}")
    return 0


def main() -> int:
    """Every target, into its own expectations file."""
    global FBC, OUT, WORK, LABEL
    rc = 0
    for LABEL, FBC, OUT, WORK in fbxtargets.truth_targets(OUT, WORK):
        if one_target() != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
