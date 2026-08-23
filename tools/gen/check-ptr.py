#!/usr/bin/env python3
"""Compare tiko-lang's pointer conversions with fbc's, over every measured combination.

    python tools/gen/check-ptr.py

Reads tests/types/expected/fbc-ptr.txt -- produced by ptr-truth.py from fbc itself --
and replays both of its sections through tiko-lang.

  accept rows: one candidate, so the call either types or it does not. tiko-lang printing a
               type means it took the call; '?' means it refused.
  pick rows:   two candidates differing only in RETURN type, which takes no part in
               resolution. BYTE names the first, SHORT the second, '?' a refusal --
               and fbc's refusals here are AMBIGUITIES, not missing conversions.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

TRUTH = ROOT / "tests/types/expected/fbc-ptr.txt"
TGT = []
LABEL = "win64"
WORK = ROOT / "build/.ptr"
TKO = ROOT / "bin/tiko.exe"

# Kept in step with ptr-truth.py: same declarations, same order.
DECLS = [
    "dim shared as string v_string",
    "dim shared as zstring * 8 v_zfixed",
    "dim shared as wstring * 8 v_wfixed",
    "dim shared as long v_long",
    "dim shared as integer v_integer",
    "dim shared as uinteger v_uinteger",
    "dim shared as longint v_longint",
    "dim shared as ulongint v_ulongint",
    "dim shared as ulong v_ulong",
    "dim shared as double v_double",
    "dim shared as boolean v_boolean",
    "dim shared as any ptr v_anyptr",
    "dim shared as byte ptr v_byteptr",
    "dim shared as ubyte ptr v_ubyteptr",
    "dim shared as short ptr v_shortptr",
    "dim shared as long ptr v_longptr",
    "dim shared as long ptr ptr v_longptrptr",
    "dim shared as zstring ptr v_zptr",
    "dim shared as wstring ptr v_wptr",
]


def one_target() -> int:
    if not TRUTH.exists():
        print(f"check-ptr: {LABEL} no truth file; run tools/gen/ptr-truth.py", file=sys.stderr)
        return 3
    tiko = TKO if TKO.exists() else ROOT / "bin/tiko"
    if not tiko.exists():
        print(f"check-ptr: {LABEL} tiko not built", file=sys.stderr)
        return 3

    rows = [line.split("\t")
            for line in TRUTH.read_text(encoding="utf-8").splitlines() if line.strip()]

    WORK.mkdir(parents=True, exist_ok=True)
    src, line_of = list(DECLS), {}
    fid = 0
    for i, r in enumerate(rows):
        if r[0] == "accept":
            _, arg, pt, _want = r
            fn = f"c{fid}"
            fid += 1
            src.append(f"declare function {fn} ( byval x as {pt} ) as byte")
            src.append(f"print {fn}( {arg} )")
        else:
            _, a, b, arg, _want = r
            fn = f"c{fid}"
            fid += 1
            src.append(f"declare function {fn} overload ( byval x as {a} ) as byte")
            src.append(f"declare function {fn} overload ( byval x as {b} ) as short")
            src.append(f"print {fn}( {arg} )")
        line_of[len(src)] = i

    probe = WORK / "ptr-tiko.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    proc = subprocess.run([str(tiko), "--check"] + TGT + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\d+) (.+)", line.strip())
        if m and int(m.group(1)) in line_of:
            got[line_of[int(m.group(1))]] = m.group(2).strip()

    ok = missing = warn_rows = 0
    bad = []
    for i, r in enumerate(rows):
        if i not in got:
            missing += 1
            continue
        mine = got[i]
        if r[0] == "accept":
            _, arg, pt, want = r
            mine_ok = "no" if mine == "?" else "yes"
            # 'warn' is fbc ACCEPTING with warning 3. tiko-lang does not issue that warning
            # yet, so the comparison here is acceptance only, and the shortfall is
            # reported rather than folded away.
            if want == "warn":
                warn_rows += 1
                want = "yes"
            if mine_ok == want:
                ok += 1
            else:
                bad.append(f"accept {arg} -> {pt}: fbc={want} tiko={mine_ok}")
        else:
            _, a, b, arg, want = r
            chose = a if mine == "byte" else (b if mine == "short" else "reject")
            if chose == want:
                ok += 1
            else:
                bad.append(f"pick {a} vs {b}, arg {arg}: fbc={want} tiko={chose}")

    print(f"check-ptr: {LABEL} {ok}/{len(rows)} match")
    if warn_rows:
        print(f"check-ptr: {LABEL} {warn_rows} of those are conversions fbc WARNS about "
              f"(warning 3); tiko-lang accepts them silently -- the warning is not "
              f"implemented")
    if missing:
        print(f"check-ptr: {LABEL} {missing} rows produced no output")
    if bad:
        print(f"check-ptr: {LABEL} {len(bad)} disagreements, first 20:")
        for b in bad[:20]:
            print("   ", b)
    return 0 if (not bad and not missing) else 1


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
