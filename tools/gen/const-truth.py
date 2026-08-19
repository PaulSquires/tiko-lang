#!/usr/bin/env python3
"""Extract the EXACT value FBC folds a constant expression to.

    python tools/gen/const-truth.py

Writes tests/types/expected/fbc-const.txt and fbc-const-win32.txt: one row per expression with the 64-bit
value fbc computes.

'#print' does NOT fold -- it echoes its tokens -- so there is no way to simply ask.
'#assert' does evaluate, which turns it into a one-bit oracle, and 64 of those give
the whole value: for each bit k, '#assert ((expr shr k) and 1) = 1' compiles silently
when the bit is set and reports error 308 when it is not. One compilation yields every
bit of every expression, and the answer is exact rather than rounded through a
decimal rendering.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

# One entry per target. win32 comes from a different fbc -- fbc-modern has no 32-bit
# build -- with the caveat recorded in docs/internals/phase-5-const-width.md.
TC64 = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows")
TC32 = Path(r"C:\dev\tiko_editor\toolchains\FreeBASIC-1.10.1-winlibs-gcc-9.3.0")
TARGETS = [
    ("win64", TC64 / "fbc64.exe", ROOT / "tests/types/expected/fbc-const.txt",
     ROOT / "build/.ce"),
    ("win32", TC32 / "fbc32.exe", ROOT / "tests/types/expected/fbc-const-win32.txt",
     ROOT / "build/.ce32"),
]

# The expressions where a constant evaluator is most likely to be quietly wrong:
# sign rules for truncating division, shift widths and counts, overflow, and the
# precedence of unary minus against '^'.
EXPRS = [
    "2 + 3", "2 + 3 * 4", "(2 + 3) * 4",
    r"7 \ 2", r"-7 \ 2", r"7 \ -2", r"-7 \ -2",
    "7 mod 2", "-7 mod 2", "7 mod -2", "-7 mod -2",
    r"10 \ 3 * 3", "10 mod 3 * 3",
    "1 shl 0", "1 shl 31", "1 shl 32", "1 shl 40", "1 shl 62",
    "-1 shr 1", "-1 shl 1", "256 shr 4", "-256 shr 4",
    "not 0", "not 1", "not -1",
    "&hFFFFFFFF", "&hFFFFFFFFFFFFFFFF", "&h7FFFFFFF", "&o777", "&b1011",
    "2147483647 + 1", "-2147483647 - 1",
    "&hFFFFFFFF and -1", "&hF0 or &h0F", "&hFF xor &h0F",
    "5 = 5", "5 <> 5", "5 < 6", "5 > 6",
    "1 andalso 0", "1 orelse 0",
    "-2 ^ 2", "2 ^ 3",
    "abs(-5)", "sgn(-9)", "sgn(0)",
    "len(\"hello\")", "asc(\"A\")",
    "iif(1, 10, 20)", "iif(0, 10, 20)",
    "cint(2.5)", "cint(3.5)", "cint(-2.5)",
    "clng(1e10)", "int(-2.5)", "fix(-2.5)",
]

BITS = 64


def one_target(label, fbc, out, work) -> int:
    if not fbc.exists():
        print(f"const-truth: {label}: no fbc at {fbc}", file=sys.stderr)
        return 3
    work.mkdir(parents=True, exist_ok=True)

    lines, line_of = [], {}
    for ei, e in enumerate(EXPRS):
        for k in range(BITS):
            # CLNGINT first, so the bit probe's own shifts happen at 64 bits. Without
            # it a 32-bit expression on win32 would be shifted past its own width, and
            # the top half of every value would read back as noise -- the measurement
            # broken by exactly the thing it is measuring.
            lines.append(f"#assert (( clngint({e}) shr {k} ) and 1) = 1")
            line_of[len(lines)] = (ei, k)

    src = work / "const.bas"
    src.write_text("\n".join(lines) + "\n", encoding="utf-8")

    proc = subprocess.run(
        [str(fbc), "-c", str(src), "-o", str(work / "const.o"),
         "-maxerr", str(len(lines) + 100)],
        capture_output=True, text=True)
    diag = (proc.stdout or "") + (proc.stderr or "")

    zero = set()
    unusable = set()
    for m in re.finditer(r"\((\d+)\)\s+error\s+(\d+)", diag):
        n, code = int(m.group(1)), int(m.group(2))
        if n not in line_of:
            continue
        if code == 308:
            zero.add(line_of[n])          # assertion failed -> that bit is 0
        else:
            unusable.add(line_of[n][0])   # the expression itself did not compile

    rows = []
    for ei, e in enumerate(EXPRS):
        if ei in unusable:
            rows.append(f"{e}\treject")
            continue
        v = 0
        for k in range(BITS):
            if (ei, k) not in zero:
                v |= 1 << k
        if v >= 1 << 63:                  # render as signed 64-bit
            v -= 1 << 64
        rows.append(f"{e}\t{v}")
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"const-truth: {label}: {len(rows)} expressions, {len(unusable)} not "
          f"foldable -> {out.name}")
    return 0


def main() -> int:
    rc = 0
    for label, fbc, out, work in TARGETS:
        if one_target(label, fbc, out, work) != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
