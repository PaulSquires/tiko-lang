#!/usr/bin/env python3
"""Ask FBC ITSELF what type every binary operation produces.

    python tools/gen/promo-truth.py

Writes tests/types/expected/fbc-promotion.txt and fbc-promotion-win32.txt: one row per (lhs, op, rhs) giving the
result type fbc computes, and whether fbc accepts the combination at all. Those are
two different questions -- fbc reports a type mismatch and STILL prints a fallback
type -- and the checker needs both: one drives promotion, the other drives the
conversion-legality diagnostics.

The mechanism is '#print typeof( expr )', which fbc evaluates at compile time. It is
the only way to see the frontend's own answer rather than to infer one from the
generated code. Every probe is preceded by a marker print so results stay aligned
even when fbc interleaves errors with output.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

FBC = tkotargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-promotion.txt"
WORK = ROOT / "build/.ck"

TYPES = ["byte", "ubyte", "short", "ushort", "long", "ulong", "integer",
         "uinteger", "longint", "ulongint", "single", "double", "boolean", "string"]

# The word-shaped operators are spelled as fbc spells them; '^' is exponentiation.
OPS = ["+", "-", "*", "/", "\\", "mod", "^", "shl", "shr", "&",
       "and", "or", "xor", "eqv", "imp", "andalso", "orelse",
       "=", "<>", "<", ">", "<=", ">="]


def one_target() -> int:
    if not FBC.exists():
        print(f"promo-truth: {LABEL}: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    probes, lines = [], []
    for i, t in enumerate(TYPES):
        lines.append(f"dim as {t} v{i}")
    for li, lt in enumerate(TYPES):
        for op in OPS:
            for ri, rt in enumerate(TYPES):
                idx = len(probes)
                probes.append((lt, op, rt))
                lines.append(f"#print MARK{idx}")
                lines.append(f"#print typeof( v{li} {op} v{ri} )")

    src = WORK / "promo.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")

    proc = subprocess.run(
        [str(FBC), "-c", str(src), "-o", str(WORK / "promo.o"),
         "-maxerr", str(len(probes) * 2 + 100)],
        capture_output=True, text=True)
    out = (proc.stdout or "") + (proc.stderr or "")

    # Which probe lines fbc rejected. Its line numbers are 1-based into the file.
    bad = set()
    for m in re.finditer(r"\((\d+)\)\s+error", out):
        n = int(m.group(1))
        idx = (n - len(TYPES) - 2) // 2      # the typeof line of probe idx
        if 0 <= idx < len(probes):
            bad.add(idx)

    # Results, kept aligned by the marker prints rather than by position alone.
    results, cur = {}, None
    for raw in out.splitlines():
        line = raw.strip()
        m = re.fullmatch(r"MARK(\d+)", line)
        if m:
            cur = int(m.group(1))
            continue
        # A result is a bare TYPE NAME. Matching "not an error" is not enough:
        # fbc also emits warnings, and warning 38 (mixed boolean operands) fires on
        # exactly the rows this table is measuring, so it landed in the results.
        if cur is not None and re.fullmatch(r"[A-Z][A-Z0-9_ ]*", line):
            results[cur] = line
            cur = None

    OUT.parent.mkdir(parents=True, exist_ok=True)
    rows = []
    for i, (lt, op, rt) in enumerate(probes):
        res = results.get(i, "?")
        ok = "reject" if i in bad else "ok"
        rows.append(f"{lt}\t{op}\t{rt}\t{ok}\t{res}")
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"promo-truth: {LABEL}: {len(rows)} rows, {len(bad)} rejected -> "
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
