#!/usr/bin/env python3
"""Compare fbx's runtime inventory with the signatures FBC emits, on BOTH targets.

    python tools/gen/check-rtl.py

Reads tests/expected/fbc-rtl.txt and fbc-rtl-win32.txt -- produced by rtl-truth.py from
the C intermediate fbc leaves behind, and cross-checked against libfb.a -- and compares
each with 'fbx --dump-rtl' for that target.

Passing three arguments to a two-argument runtime function is a link error at best and
a silent stack mismatch at worst, so the arity and every parameter type are compared,
not just the names. On win32 the NAME is compared too, decoration included: the runtime
is stdcall there and its symbols carry '_fb_StrAssign@20' rather than 'fb_StrAssign'.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FBX = ROOT / "bin/fbx.exe"

TARGETS = [
    ("win64", ROOT / "tests/expected/fbc-rtl.txt", []),
    ("win32", ROOT / "tests/expected/fbc-rtl-win32.txt", ["-target", "win32"]),
]

# fbc's C spelling -> the MIR type fbx names it by.
#
# SIGNED AND UNSIGNED COLLAPSE, deliberately. MIR has no unsigned types: signedness lives
# in the OPCODE (icmp.ult against icmp.slt, udiv against sdiv), not in the operand type,
# so uint8 and int8 are both i8 here. A mismatch this map hides would be a wrong opcode,
# which is not what this gate is checking -- it checks that argument WIDTHS agree.
CMAP = {
    "void": "void", "int32": "i32", "int64": "i64", "uint32": "i32",
    "uint64": "i64", "int8": "i8", "int16": "i16", "float": "f32",
    "double": "f64", "uint8": "i8", "uint16": "i16", "boolean": "i8",
}


def c_to_mir(t: str) -> str:
    t = " ".join(t.split())
    if t.endswith("*"):
        return "ptr"
    if t.startswith("struct "):
        return "ptr"
    if t == "...":
        return "..."
    return CMAP.get(t, "?" + t)


def one_target(fbx, label, truth, tgtargs):
    if not truth.exists():
        print(f"check-rtl: {label}: no truth file; run tools/gen/rtl-truth.py",
              file=sys.stderr)
        return 3

    # The win32 file carries a fifth column: the DECORATED symbol, which is the name
    # fbx has to emit. On win64 it is the plain name and the column agrees with it.
    want = {}
    for line in truth.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        cols = line.split("\t")
        fn, ret, args, present = cols[0], cols[1], cols[2], cols[3]
        sym = cols[4] if len(cols) > 4 else fn
        arglist = [a.strip() for a in args.split(",")] if args and args != "void" else []
        want[sym] = (fn, c_to_mir(ret), [c_to_mir(a) for a in arglist], present)

    probe = ROOT / "build/.rt/e.bas"
    probe.parent.mkdir(parents=True, exist_ok=True)
    probe.write_text("sub F( )\nend sub\n", encoding="utf-8", newline="\n")
    proc = subprocess.run([str(fbx), "--dump-rtl"] + tgtargs + [str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(\S+) (\w+) \((.*)\)", line.strip())
        if m:
            args = [a.strip() for a in m.group(3).split(",")] if m.group(3) else []
            got[m.group(1)] = (m.group(2), args)

    ok, diffs = 0, []
    for sym, (gret, gargs) in sorted(got.items()):
        if sym not in want:
            diffs.append(f"{sym}: in fbx's table, not in anything fbc emitted")
            continue
        fn, wret, wargs, present = want[sym]
        # LIBC, not libfb. pow and atan2 come from the C runtime -- fbc calls them
        # directly and links libc alongside libfb -- so their absence from the archive
        # is expected and says nothing. malloc and free are in libfb only because
        # mingw's libfb happens to re-export them; that is not something to rely on.
        if present != "lib" and fn not in ("pow", "atan2"):
            diffs.append(f"{fn}: not an exported symbol of libfb.a")
            continue
        # A variadic tail is not modelled yet; compare the fixed prefix.
        variadic = "..." in wargs
        cmp_w = [a for a in wargs if a != "..."]
        gargs = [a for a in gargs if a != "..."]
        if gret != wret:
            diffs.append(f"{fn}: return fbc={wret} fbx={gret}")
            continue
        if gargs != cmp_w:
            kind = "fixed args" if variadic else "args"
            diffs.append(f"{fn}: {kind} fbc={cmp_w} fbx={gargs}")
            continue
        ok += 1

    print(f"check-rtl: {label} {ok}/{len(got)} entries match the signatures fbc emits")
    unused = sorted(set(want) - set(got))
    if unused:
        print(f"check-rtl: {label} {len(unused)} measured but not yet in fbx's table: "
              + ", ".join(unused))
    if diffs:
        print(f"check-rtl: {label} {len(diffs)} disagreements:")
        for d in diffs[:20]:
            print("   ", d)
    return 0 if not diffs else 1


def main() -> int:
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print("check-rtl: fbx not built", file=sys.stderr)
        return 3
    rc = 0
    for label, truth, tgtargs in TARGETS:
        if one_target(fbx, label, truth, tgtargs) != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
