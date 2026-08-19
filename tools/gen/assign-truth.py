#!/usr/bin/env python3
"""Ask FBC ITSELF which assignments it accepts.

    python tools/gen/assign-truth.py

Writes tests/types/expected/fbc-assign.txt and fbc-assign-win32.txt: one row per (target, source) pair saying
whether 'target = source' compiles, and whether fbc warns.

Assignment legality is a DIFFERENT question from binary promotion, and the answers do
not follow from each other: 'long + string' is rejected and so is 'long = string', but
plenty of pairs fbc refuses to promote it will happily assign. It is measured for the
same reason everything else here is -- so the compatibility rule has a fact behind it
rather than an inference.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

FBC = fbxtargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-assign.txt"
WORK = ROOT / "build/.as"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean",
         "string", "any ptr", "long ptr", "zstring ptr", "wstring ptr"]


def slug(t):
    return t.replace(" ", "_")


def one_target() -> int:
    if not FBC.exists():
        print(f"assign-truth: {LABEL}: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    lines, probes, line_of = [], [], {}
    for i, t in enumerate(TYPES):
        lines.append(f"dim as {t} v{i}")
    for di, dt in enumerate(TYPES):
        for si, st in enumerate(TYPES):
            lines.append(f"v{di} = v{si}")
            line_of[len(lines)] = len(probes)
            probes.append((dt, st))

    src = WORK / "assign.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")

    proc = subprocess.run(
        [str(FBC), "-c", "-w", "all", str(src), "-o", str(WORK / "assign.o"),
         "-maxerr", str(len(probes) + 100)],
        capture_output=True, text=True)
    out = (proc.stdout or "") + (proc.stderr or "")

    bad, warned = set(), set()
    for m in re.finditer(r"\((\d+)\)\s+(error|warning)", out):
        n, kind = int(m.group(1)), m.group(2)
        if n in line_of:
            (bad if kind == "error" else warned).add(line_of[n])

    rows = []
    for i, (dt, st) in enumerate(probes):
        if i in bad:
            verdict = "reject"
        elif i in warned:
            verdict = "warn"
        else:
            verdict = "ok"
        rows.append(f"{dt}\t{st}\t{verdict}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"assign-truth: {LABEL}: {len(rows)} rows, {len(bad)} rejected, {len(warned)} warned "
          f"-> {OUT.name}")
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
