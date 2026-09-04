#!/usr/bin/env python3
"""Ask FBC ITSELF what each EXPRESSION intrinsic returns.

    python tools/gen/intrin-truth.py

Writes tests/types/expected/fbc-intrin.txt: one row per
(intrinsic, argument spelling) giving the result type, or 'reject'.

These are the 48 IFORM_EXPR keywords -- LEN, ASC, LBOUND, STR, ABS and the rest. They are
keywords in expression position, so nothing is bound and overload resolution has nothing
to say: '#print typeof( len( s ) )' is the whole measurement.

Most could be guessed. Several could not, and those are the reason this is measured:
ASC is ULONG rather than a character type, CHR is a ZSTRING * 2 rather than a string, SGN
is LONG whatever it is given, and ABS and IIF return their ARGUMENT's type rather than a
fixed one.
"""
import re
import subprocess
import sys
from pathlib import Path

import tkotargets

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "tests/types/expected/fbc-intrin.txt"
WORK = ROOT / "build/.in"
LABEL = "win64"
FBC = tkotargets.FBC64

# (spelling, declaration). The declaration is emitted once; the spelling goes in the
# probe. '@' forms and array arguments need their own declarations.
ARGS = [
    ("v_byte", "dim shared as byte v_byte"),
    ("v_long", "dim shared as long v_long"),
    ("v_integer", "dim shared as integer v_integer"),
    ("v_longint", "dim shared as longint v_longint"),
    ("v_single", "dim shared as single v_single"),
    ("v_double", "dim shared as double v_double"),
    ("v_string", "dim shared as string v_string"),
    ("v_zfixed", "dim shared as zstring * 8 v_zfixed"),
    ("v_wfixed", "dim shared as wstring * 8 v_wfixed"),
    ("v_ptr", "dim shared as any ptr v_ptr"),
    ("v_arr", "dim shared as long v_arr(0 to 3)"),
    ("1", None),
    ('"lit"', None),
]

# The intrinsics, with how many arguments the probe should pass.
ONE_ARG = ["asc", "chr", "len", "sizeof", "str", "wstr", "wchr", "sgn", "abs",
           "lbound", "ubound", "trim", "ltrim", "rtrim", "ucase", "lcase",
           "sin", "cos", "tan", "atn", "exp", "log", "sqr", "asin", "acos",
           "varptr", "strptr", "sadd", "cvi", "cvl", "cvs", "cvd", "cvshort",
           "cvlongint", "mki", "mkl", "mks", "mkd", "mkshort", "mklongint",
           "int", "fix", "peek"]
TWO_ARG = ["instr", "instrrev", "mid"]


def main() -> int:
    rc = 0
    for label, fbc, out, work in tkotargets.truth_targets(OUT, WORK):
        if one_target(label, fbc, out, work) != 0:
            rc = 1
    return rc


def one_target(label, fbc, out, work) -> int:
    if not fbc.exists():
        print(f"intrin-truth: {label}: no fbc at {fbc}", file=sys.stderr)
        return 3
    work.mkdir(parents=True, exist_ok=True)

    lines, probes, line_of = [], [], {}

    def emit(text):
        lines.append(text)
        return len(lines)

    for _n, decl in ARGS:
        if decl:
            emit(decl)

    for fn in ONE_ARG:
        for arg, _d in ARGS:
            idx = len(probes)
            probes.append((fn, arg))
            emit(f"#print MARK{idx}")
            line_of[emit(f"#print typeof( {fn}( {arg} ) )")] = idx
    for fn in TWO_ARG:
        for arg, _d in ARGS:
            idx = len(probes)
            probes.append((fn, arg))
            emit(f"#print MARK{idx}")
            line_of[emit(f"#print typeof( {fn}( {arg}, {arg} ) )")] = idx

    src = work / "intrin.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    proc = subprocess.run(
        [str(fbc), "-c", str(src), "-o", str(work / "intrin.o"),
         "-maxerr", str(len(probes) * 2 + 100)],
        capture_output=True, text=True)
    diag = (proc.stdout or "") + (proc.stderr or "")

    results, cur = {}, None
    for raw in diag.splitlines():
        line = raw.strip()
        m = re.fullmatch(r"MARK(\d+)", line)
        if m:
            cur = int(m.group(1))
            continue
        if cur is not None and re.fullmatch(r"[A-Z][A-Z0-9_* ]*", line):
            results[cur] = line
            cur = None

    rejected = set()
    for m in re.finditer(r"\((\d+)\)\s+error", diag):
        n = int(m.group(1))
        if n in line_of:
            rejected.add(line_of[n])

    rows = []
    for i, (fn, arg) in enumerate(probes):
        got = "reject" if i in rejected else results.get(i, "?")
        rows.append(f"{fn}\t{arg}\t{got}")
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"intrin-truth: {label}: {len(rows)} rows, {len(rejected)} rejected "
          f"-> {out.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
