#!/usr/bin/env python3
"""Extract fbc's ARRAY STORAGE SIZES, for comparison against tiko-lang's slot sizes.

    python tools/gen/array-truth.py

Writes tests/types/expected/fbc-array.txt.

NOTE ON THE ORACLE. 'sizeof' is NOT usable here: applied to an array FreeBASIC returns
the ELEMENT size, not the total -- sizeof(a) is 4 for 'dim as long a(0 to 9)'. So the
sizes are read from the memset fbc emits over the storage in its C intermediate, which
is the total it actually reserves.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
import tkotargets

FBC = tkotargets.FBC64
LABEL = "win64"
OUT = ROOT / "tests/types/expected/fbc-array.txt"
WORK = ROOT / "build/.ar"

# Shapes where a size computation goes wrong quietly: an implicit lower bound, a
# non-zero one, several dimensions, and an element wider or narrower than the index.
CASES = [
    ("a", "dim as long a(0 to 9)"),
    ("b", "dim as long b(1 to 3, 1 to 4)"),
    ("c", "dim as long c(9)"),
    ("d", "dim as double d(2 to 4)"),
    ("e", "dim as byte e(1 to 5)"),
    ("g", "dim as long g(0 to 1, 0 to 1, 0 to 1)"),
    ("h", "dim as short h(-3 to 3)"),
    ("k", "dim as string k(0 to 1)"),
]


def one_target() -> int:
    if not FBC.exists():
        print(f"array-truth: {LABEL}: SKIPPED -- no oracle fbc at {FBC} (set TIKO_ORACLE_FBC)")
        return tkotargets.SKIP
    WORK.mkdir(parents=True, exist_ok=True)
    src = WORK / "arr.bas"
    body = "sub P( )\n" + "".join(f"    {d}\n" for _, d in CASES) + "end sub\n"
    src.write_text(body, encoding="utf-8")
    # The 32-bit fbc needs the gcc backend to leave a C intermediate at all; without
    # it there is no file to read the __builtin_memset sizes out of.
    # -gen gcc was win32's; LABEL cannot be win32 any more (D14).
    gen = []
    proc = subprocess.run([str(FBC), "-c", "-r", str(src), "-o", str(WORK / "arr.o")] + gen,
                          capture_output=True, text=True, cwd=str(WORK))
    c = WORK / "arr.c"
    if not c.exists():
        print("array-truth: no C intermediate\n" + (proc.stdout or "") + (proc.stderr or ""),
              file=sys.stderr)
        return 1

    text = c.read_text(encoding="utf-8", errors="replace")
    lines = []
    for name, _ in CASES:
        # __builtin_memset( (int32*)A$1, 0, 40ll );  -- the storage, not the descriptor.
        # The 'll' suffix is win64's: on win32 the size is a plain int and fbc writes
        # '40'. Requiring it made every win32 case report "no memset found".
        m = re.search(r"__builtin_memset\(\s*\(?[^)]*\)?\s*&?"
                      + name.upper() + r"\$\d+,\s*0,\s*(\d+)(?:ll)?\s*\)", text)
        if not m:
            print(f"array-truth: {LABEL}: no memset found for {name}", file=sys.stderr)
            return 1
        lines.append(f"{name}\t{m.group(1)}")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"array-truth: {LABEL}: {len(lines)} array sizes -> {OUT.name}")
    return 0


def main() -> int:
    """Every target, into its own expectations file."""
    global FBC, OUT, WORK, LABEL
    rc = 0
    skipped = 0
    for LABEL, FBC, OUT, WORK in tkotargets.truth_targets(OUT, WORK):
        r = one_target()
        if r == tkotargets.SKIP:
            skipped += 1
        elif r != 0:
            rc = 1
    # ALL SKIPPED is a skip; a failure anywhere is a failure.
    if rc == 0 and skipped:
        return tkotargets.SKIP
    return rc


if __name__ == "__main__":
    sys.exit(main())
