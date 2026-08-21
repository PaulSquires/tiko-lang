#!/usr/bin/env python3
r"""Regenerate tests/types/expected/fbc-escape.txt -- the BYTES fbc puts in a literal.

    python tools/gen/escape-truth.py

Every row is measured by COMPILING AND RUNNING a FreeBASIC program, not by reading a
table: the program assigns each literal to a STRING and prints its length and the code
of every byte. That is the only way to see what an escape produced, because nothing in
the compiler's own output spells it.

WHAT IS NOT COVERED, and why. '\u' and '\U' promote the whole literal to a WSTRING --
measured, '#print typeof( !"\u0041" )' is 'WSTRING * 3' against 'ZSTRING * 2' for
'!"\n"'. fbx does not model a wide literal at all, so a probe that assigned one to a
STRING would measure fbc's ANSI conversion (unmappable bytes become '?', code 63) and
pin an answer to a question neither compiler is being asked. They are the single
largest escape in the corpus, 2120 occurrences, and they are an OPEN GAP, not a
covered one.
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "tests/types/expected/fbc-escape.txt"
WORK = ROOT / "build/.esc"
FBC = Path("C:/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe")

BS = chr(92)
Q = chr(34)

# Each entry is the literal EXACTLY as it appears in FreeBASIC source.
CASES = [
    # the ten named escapes, and that they are case-SENSITIVE
    '!"' + BS + 'a"', '!"' + BS + 'b"', '!"' + BS + 'f"', '!"' + BS + 'n"',
    '!"' + BS + 'r"', '!"' + BS + 't"', '!"' + BS + 'v"',
    '!"' + BS + BS + '"', '!"' + BS + "'" + '"',
    '!"a' + BS + Q + 'b"',
    '!"' + BS + 'N"', '!"' + BS + 'T"', '!"' + BS + 'A"',
    # not escapes at all -- the character itself, never an error
    '!"' + BS + 'q"', '!"' + BS + 'e"', '!"' + BS + 's"', '!"a' + BS + '?b"',
    # decimal, one to three digits, greedy, clamped
    '!"' + BS + '101"', '!"' + BS + '65"', '!"' + BS + '9x"',
    '!"' + BS + '1234"', '!"' + BS + '256"', '!"' + BS + '300"',
    # hex, at most two digits
    '!"' + BS + 'x41BC"', '!"' + BS + 'x4142"', '!"' + BS + 'x4z"',
    '!"' + BS + 'X41z"',
    # the &-radix forms
    '!"' + BS + '&h41' + BS + '&h42' + BS + '&h43"',
    '!"' + BS + '&h414243"', '!"' + BS + '&H41"',
    '!"' + BS + '&o101' + BS + '&o102"', '!"' + BS + '&o1011"', '!"' + BS + '&o400"',
    '!"' + BS + '&b1000001"', '!"' + BS + '&b100000110"',
    '!"' + BS + '&x41"',
    # mixtures, and the ordinary text around them
    '!"ab' + BS + BS + '"', '!"a' + BS + 'tb' + BS + 'nc"',
    '!"' + BS + 'x41' + BS + '66' + BS + '&h43"',
    # the two non-escaping spellings: a backslash is a byte
    '"a' + BS + 'nb"', '$"a' + BS + 'tb"',
    # doubled quotes, in all three spellings
    '"a""b"', '!"a""b"', '$"a""b"',
    # empty, and no escape at all
    '""', '!""', '!"plain"',
]


def main() -> int:
    if not FBC.exists():
        print(f"escape-truth: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)

    src = ["dim shared as string s"]
    for i, lit in enumerate(CASES):
        src.append(f"s = {lit}")
        src.append(f'print "CASE {i} " & len( s );')
        src.append("for j as integer = 1 to len( s )")
        src.append('    print " " & asc( mid( s, j, 1 ) );')
        src.append("next")
        src.append("print")
    probe = WORK / "escape-truth.bas"
    probe.write_text("\n".join(src) + "\n", encoding="utf-8", newline="\n")

    exe = WORK / "escape-truth.exe"
    r = subprocess.run([str(FBC), str(probe), "-x", str(exe)],
                       capture_output=True, text=True)
    if r.returncode != 0:
        sys.stderr.write(r.stdout + r.stderr)
        print("escape-truth: fbc refused the probe", file=sys.stderr)
        return 3
    r = subprocess.run([str(exe)], capture_output=True, text=True)
    if r.returncode != 0:
        print("escape-truth: the probe did not run", file=sys.stderr)
        return 3

    got = {}
    for line in r.stdout.splitlines():
        parts = line.split()
        if len(parts) < 2 or parts[0] != "CASE":
            continue
        got[int(parts[1])] = parts[2:]
    if len(got) != len(CASES):
        print(f"escape-truth: {len(got)} rows for {len(CASES)} cases -- the probe did "
              "not print them all", file=sys.stderr)
        return 4

    rows = ["# literal <TAB> length <TAB> byte codes, measured by RUNNING fbc's output.",
            "# Regenerate with tools/gen/escape-truth.py. Do not hand-edit.",
            f"# {len(CASES)} cases. '" + BS + "u' and '" + BS + "U' are deliberately "
            "absent: they make a WSTRING literal.",
            ""]
    for i, lit in enumerate(CASES):
        n, *codes = got[i]
        rows.append("\t".join([lit, n, " ".join(codes)]))
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(rows) + "\n", encoding="utf-8", newline="\n")
    print(f"escape-truth: {len(CASES)} cases -> {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
