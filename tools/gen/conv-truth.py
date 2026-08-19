#!/usr/bin/env python3
"""Ask FBC ITSELF what each conversion intrinsic returns, for every argument type.

    python tools/gen/conv-truth.py

Writes tests/types/expected/fbc-conv.txt and fbc-conv-win32.txt: one row per (intrinsic, argument type) giving
the result type fbc computes, or 'reject'.

These are keywords in expression position, not procedures, so overload resolution has
nothing to say about them and '#print typeof( cbyte( v ) )' is the whole measurement.
Most are named after their result and could be guessed; CSIGN and CUNSG cannot -- their
result depends on the ARGUMENT -- and guessing is how a table like this goes wrong.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import fbxtargets

FBC = fbxtargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-conv.txt"
WORK = ROOT / "build/.conv"

ARGS = [
    ("byte",       "dim shared as byte a_byte"),
    ("ubyte",      "dim shared as ubyte a_ubyte"),
    ("short",      "dim shared as short a_short"),
    ("ushort",     "dim shared as ushort a_ushort"),
    ("long",       "dim shared as long a_long"),
    ("ulong",      "dim shared as ulong a_ulong"),
    ("integer",    "dim shared as integer a_integer"),
    ("uinteger",   "dim shared as uinteger a_uinteger"),
    ("longint",    "dim shared as longint a_longint"),
    ("ulongint",   "dim shared as ulongint a_ulongint"),
    ("single",     "dim shared as single a_single"),
    ("double",     "dim shared as double a_double"),
    ("boolean",    "dim shared as boolean a_boolean"),
    ("string",     "dim shared as string a_string"),
    ("zstring",    "dim shared as zstring * 8 a_zstring"),
    ("wstring",    "dim shared as wstring * 8 a_wstring"),
    ("anyptr",     "dim shared as any ptr a_anyptr"),
    ("longptr",    "dim shared as long ptr a_longptr"),
]

# One argument, result named after the keyword or after the argument.
UNARY = ["cbyte", "cubyte", "cshort", "cushort", "clng", "culng", "cint", "cuint",
         "clngint", "culngint", "csng", "cdbl", "cbool", "csign", "cunsg"]

# Two arguments, the first a TYPE. Spelled here as (name, type-argument).
TYPED = [("cptr", "any ptr"), ("cptr", "long ptr"), ("cast", "long"),
         ("cast", "double"), ("cast", "string"), ("cast", "any ptr")]


def one_target() -> int:
    if not FBC.exists():
        print(f"conv-truth: {LABEL}: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    lines, probes, line_of = [], [], {}

    def emit(text):
        lines.append(text)
        return len(lines)

    for _n, decl in ARGS:
        emit(decl)

    for fn in UNARY:
        for an, _d in ARGS:
            idx = len(probes)
            probes.append((fn, an))
            emit(f"#print MARK{idx}")
            line_of[emit(f"#print typeof( {fn}( a_{an} ) )")] = idx

    for fn, ta in TYPED:
        for an, _d in ARGS:
            idx = len(probes)
            probes.append((f"{fn}({ta})", an))
            emit(f"#print MARK{idx}")
            line_of[emit(f"#print typeof( {fn}( {ta}, a_{an} ) )")] = idx

    src = WORK / "conv.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run(
        [str(FBC), "-c", str(src), "-o", str(WORK / "conv.o"),
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
        if cur is not None and re.fullmatch(r"[A-Z][A-Z0-9_* ]*", line):
            results[cur] = line
            cur = None

    rejected = set()
    for m in re.finditer(r"\((\d+)\)\s+error", out):
        n = int(m.group(1))
        if n in line_of:
            rejected.add(line_of[n])

    rows = []
    for i, (fn, an) in enumerate(probes):
        got = "reject" if i in rejected else results.get(i, "?")
        rows.append(f"{fn}\t{an}\t{got}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"conv-truth: {LABEL}: {len(rows)} rows, {len(rejected)} rejected -> "
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
