#!/usr/bin/env python3
"""Compare fbx's runtime inventory with the signatures FBC emits.

    python tools/gen/check-rtl.py

Reads tests/expected/fbc-rtl.txt -- produced by rtl-truth.py from the C intermediate
fbc leaves behind, and cross-checked against libfb.a -- and compares it with
'fbx --dump-rtl'.

Passing three arguments to a two-argument runtime function is a link error at best and
a silent stack mismatch at worst, so the arity and every parameter type are compared,
not just the names.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/expected/fbc-rtl.txt"
FBX = ROOT / "bin/fbx.exe"

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


def main() -> int:
    if not TRUTH.exists():
        print("check-rtl: no truth file; run tools/gen/rtl-truth.py", file=sys.stderr)
        return 3
    fbx = FBX if FBX.exists() else ROOT / "bin/fbx"
    if not fbx.exists():
        print("check-rtl: fbx not built", file=sys.stderr)
        return 3

    want = {}
    for line in TRUTH.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        fn, ret, args, present = line.split("\t")
        arglist = [a.strip() for a in args.split(",")] if args and args != "void" else []
        want[fn] = (c_to_mir(ret), [c_to_mir(a) for a in arglist], present)

    probe = ROOT / "build/.rt/e.bas"
    probe.parent.mkdir(parents=True, exist_ok=True)
    probe.write_text("sub F( )\nend sub\n", encoding="utf-8", newline="\n")
    proc = subprocess.run([str(fbx), "--dump-rtl", str(probe)],
                          capture_output=True, text=True)
    got = {}
    for line in (proc.stdout or "").splitlines():
        m = re.fullmatch(r"(fb_\w+) (\w+) \((.*)\)", line.strip())
        if m:
            args = [a.strip() for a in m.group(3).split(",")] if m.group(3) else []
            got[m.group(1)] = (m.group(2), args)

    ok = bad = 0
    diffs = []
    for fn, (gret, gargs) in sorted(got.items()):
        if fn not in want:
            bad += 1
            diffs.append(f"{fn}: in fbx's table, not in anything fbc emitted")
            continue
        wret, wargs, present = want[fn]
        if present != "lib":
            bad += 1
            diffs.append(f"{fn}: not an exported symbol of libfb.a")
            continue
        # A variadic tail is not modelled yet; compare the fixed prefix.
        variadic = "..." in wargs
        cmp_w = [a for a in wargs if a != "..."]
        gargs = [a for a in gargs if a != "..."]
        if gret != wret:
            bad += 1
            diffs.append(f"{fn}: return fbc={wret} fbx={gret}")
            continue
        if variadic:
            if gargs != cmp_w:
                bad += 1
                diffs.append(f"{fn}: fixed args fbc={cmp_w} fbx={gargs}")
                continue
        elif gargs != cmp_w:
            bad += 1
            diffs.append(f"{fn}: args fbc={cmp_w} fbx={gargs}")
            continue
        ok += 1

    print(f"check-rtl: {ok}/{len(got)} entries match the signatures fbc emits")
    unused = sorted(set(want) - set(got))
    if unused:
        print(f"check-rtl: {len(unused)} measured but not yet in fbx's table: "
              + ", ".join(unused))
    if diffs:
        print(f"check-rtl: {len(diffs)} disagreements:")
        for d in diffs[:20]:
            print("   ", d)
    return 0 if not diffs else 1


if __name__ == "__main__":
    sys.exit(main())
