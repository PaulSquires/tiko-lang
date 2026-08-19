#!/usr/bin/env python3
"""Ask FBC ITSELF what a POINTER argument may be passed to, and which overload wins.

    python tools/gen/ptr-truth.py

Writes tests/types/expected/fbc-ptr.txt in two sections:

    accept <arg-expr> <param-type> yes|no
    pick   <cand-a> <cand-b> <arg-expr> <winner>|reject

fbx's ConversionCost answers CONV_NONE for every type that is not TK_BUILTIN, so a
'zstring ptr' parameter makes its whole procedure unviable and the call resolves to
nothing. That is the single largest cause of declined statements in the corpus --
fbcunit's CU_ASSERT_ takes three zstring ptr parameters -- so the cost table needs a
pointer tier, and this measures what that tier has to say rather than guessing it.

Same oracle as overload-truth.py: the two candidates differ only in RETURN type, which
takes no part in resolution, so '#print typeof( f( arg ) )' names the winner at compile
time. Acceptance is measured the same way with a single candidate: a type printed means
fbc took the call, an error on that line means it refused.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FBC = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe")
OUT = ROOT / "tests/types/expected/fbc-ptr.txt"
WORK = ROOT / "build/.ptr"

# (name, declaration) -- the argument expressions, spelled as a variable of that type
# so the probe reads 'f( v_longptr )'. The literals have no declaration.
ARGS = [
    ("0",            None),
    ("1",            None),
    ("-1",           None),
    ('"lit"',        None),
    ("v_string",     "dim shared as string v_string"),
    ("v_zfixed",     "dim shared as zstring * 8 v_zfixed"),
    ("v_wfixed",     "dim shared as wstring * 8 v_wfixed"),
    ("v_long",       "dim shared as long v_long"),
    ("v_integer",    "dim shared as integer v_integer"),
    ("v_uinteger",   "dim shared as uinteger v_uinteger"),
    ("v_longint",    "dim shared as longint v_longint"),
    ("v_ulongint",   "dim shared as ulongint v_ulongint"),
    ("v_ulong",      "dim shared as ulong v_ulong"),
    ("v_double",     "dim shared as double v_double"),
    ("v_boolean",    "dim shared as boolean v_boolean"),
    ("v_anyptr",     "dim shared as any ptr v_anyptr"),
    ("v_byteptr",    "dim shared as byte ptr v_byteptr"),
    ("v_ubyteptr",   "dim shared as ubyte ptr v_ubyteptr"),
    ("v_shortptr",   "dim shared as short ptr v_shortptr"),
    ("v_longptr",    "dim shared as long ptr v_longptr"),
    ("v_longptrptr", "dim shared as long ptr ptr v_longptrptr"),
    ("v_zptr",       "dim shared as zstring ptr v_zptr"),
    ("v_wptr",       "dim shared as wstring ptr v_wptr"),
    ("@v_long",      None),
    ("strptr(v_string)", None),
]

PARAMS = [
    "any ptr", "byte ptr", "ubyte ptr", "short ptr", "long ptr", "long ptr ptr",
    "zstring ptr", "wstring ptr", "string", "long", "ulong", "integer",
    "uinteger", "longint", "ulongint", "double", "boolean",
]


def main() -> int:
    if not FBC.exists():
        print(f"ptr-truth: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    lines = []
    # line_of maps the 1-based line number of a probe's typeof to its probe index, so
    # an error is attributed by the number fbc reports rather than by re-deriving the
    # layout afterwards.
    line_of = {}
    probes = []

    def emit(text):
        lines.append(text)
        return len(lines)

    for _name, decl in ARGS:
        if decl:
            emit(decl)

    fid = 0
    for pt in PARAMS:
        fn = f"a{fid}"
        fid += 1
        emit(f"declare function {fn} ( byval x as {pt} ) as byte")
        for arg, _d in ARGS:
            idx = len(probes)
            probes.append(("accept", arg, pt, None))
            emit(f"#print MARK{idx}")
            line_of[emit(f"#print typeof( {fn}( {arg} ) )")] = idx

    for ai in range(len(PARAMS)):
        for bi in range(ai + 1, len(PARAMS)):
            fn = f"p{fid}"
            fid += 1
            emit(f"declare function {fn} overload ( byval x as {PARAMS[ai]} ) as byte")
            emit(f"declare function {fn} overload ( byval x as {PARAMS[bi]} ) as short")
            for arg, _d in ARGS:
                idx = len(probes)
                probes.append(("pick", arg, PARAMS[ai], PARAMS[bi]))
                emit(f"#print MARK{idx}")
                line_of[emit(f"#print typeof( {fn}( {arg} ) )")] = idx

    src = WORK / "ptr.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run(
        [str(FBC), "-c", str(src), "-o", str(WORK / "ptr.o"),
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

    rejected, warned = set(), set()
    for m in re.finditer(r"\((\d+)\)\s+error", out):
        n = int(m.group(1))
        if n in line_of:
            rejected.add(line_of[n])
    # 'warning 3: Passing different pointer types' is the discriminator between the two
    # questions this file answers. A conversion fbc merely warns about is accepted for
    # a lone candidate and is NOT VIABLE once the procedure is overloaded -- measured,
    # not inferred: {byte ptr, double} refuses a SHORT PTR argument outright, although
    # byte ptr alone takes it.
    # Warning 3 only. Warning 1, 'Passing scalar as pointer', is the INTEGER-to-pointer
    # conversion and stays viable when overloaded; the two are not interchangeable.
    for m in re.finditer(r"\((\d+)\)\s+warning (\d+)", out):
        n = int(m.group(1))
        if (n in line_of) and (m.group(2) == "3"):
            warned.add(line_of[n])

    rows, nacc, nrej = [], 0, 0
    for i, (kind, arg, a, b) in enumerate(probes):
        res = results.get(i, "?")
        if kind == "accept":
            if i in rejected:
                ok = "no"
            elif i in warned:
                ok = "warn"
            else:
                ok = "yes" if res != "?" else "?"
            if ok == "no":
                nrej += 1
            else:
                nacc += 1
            rows.append(f"accept\t{arg}\t{a}\t{ok}")
        else:
            if i in rejected:
                pick = "reject"
            elif res == "BYTE":
                pick = a
            elif res == "SHORT":
                pick = b
            else:
                pick = "?"
            rows.append(f"pick\t{a}\t{b}\t{arg}\t{pick}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"ptr-truth: {len(rows)} rows ({nacc} accepted, {nrej} refused) -> "
          f"tests/types/expected/fbc-ptr.txt")
    return 0


if __name__ == "__main__":
    sys.exit(main())
