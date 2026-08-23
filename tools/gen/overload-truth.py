#!/usr/bin/env python3
"""Ask FBC ITSELF which overload it picks.

    python tools/gen/overload-truth.py

Writes tests/types/expected/fbc-overload.txt and fbc-overload-win32.txt: for every pair of candidate parameter
types and every argument type, which candidate fbc selects -- or that it refuses.

The trick that makes this observable at COMPILE time is giving the two candidates
distinct RETURN types and asking '#print typeof( f( arg ) )'. The return type takes no
part in overload resolution, so it is a free marker: BYTE means the first candidate
won, SHORT means the second. Nothing has to be run, and the answer is the frontend's
own rather than something inferred from generated code.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

FBC = tkotargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-overload.txt"
WORK = ROOT / "build/.ov"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean", "string"]


def one_target() -> int:
    if not FBC.exists():
        print(f"overload-truth: {LABEL}: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    lines, probes = [], []
    for i, t in enumerate(TYPES):
        lines.append(f"dim as {t} v{i}")

    pair_id = 0
    for ai in range(len(TYPES)):
        for bi in range(ai + 1, len(TYPES)):
            fn = f"f{pair_id}"
            pair_id += 1
            lines.append(f"declare function {fn} overload ( byval x as {TYPES[ai]} ) as byte")
            lines.append(f"declare function {fn} overload ( byval x as {TYPES[bi]} ) as short")
            for gi in range(len(TYPES)):
                idx = len(probes)
                probes.append((TYPES[ai], TYPES[bi], TYPES[gi]))
                lines.append(f"#print MARK{idx}")
                lines.append(f"#print typeof( {fn}( v{gi} ) )")

    src = WORK / "ovl.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")

    proc = subprocess.run(
        [str(FBC), "-c", str(src), "-o", str(WORK / "ovl.o"),
         "-maxerr", str(len(probes) * 2 + 100)],
        capture_output=True, text=True)
    out = (proc.stdout or "") + (proc.stderr or "")

    results, cur = {}, None
    for raw in out.splitlines():
        line = raw.strip()
        m = re.fullmatch(r"MARK(\d+)", line)
        if m:
            cur = int(m.group(1))
            continue
        if cur is not None and re.fullmatch(r"[A-Z][A-Z0-9_ ]*", line):
            results[cur] = line
            cur = None

    bad = set()
    for m in re.finditer(r"\((\d+)\)\s+error", out):
        n = int(m.group(1))
        # probe blocks start after the dim lines; each probe is two lines, but the
        # declare pairs are interleaved, so map by counting rather than arithmetic.
        bad.add(n)

    # Line -> probe index, rebuilt the same way the file was written.
    line_of = {}
    ln = len(TYPES)
    pid = 0
    pidx = 0
    for ai in range(len(TYPES)):
        for bi in range(ai + 1, len(TYPES)):
            ln += 2
            for _gi in range(len(TYPES)):
                ln += 1            # the MARK line
                ln += 1            # the typeof line
                line_of[ln] = pidx
                pidx += 1
            pid += 1

    rejected = {line_of[n] for n in bad if n in line_of}

    rows = []
    for i, (a, b, g) in enumerate(probes):
        res = results.get(i, "?")
        if i in rejected:
            pick = "reject"
        elif res == "BYTE":
            pick = a
        elif res == "SHORT":
            pick = b
        else:
            pick = "?"
        rows.append(f"{a}\t{b}\t{g}\t{pick}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"overload-truth: {LABEL}: {len(rows)} rows, {len(rejected)} rejected -> "
          f"{OUT.name}")
    return 0


def main() -> int:
    """Every target, into its own expectations file."""
    global FBC, OUT, WORK, LABEL
    rc = 0
    for LABEL, FBC, OUT, WORK in tkotargets.truth_targets(OUT, WORK):
        if one_target() != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
