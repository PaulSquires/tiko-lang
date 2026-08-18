#!/usr/bin/env python3
"""Extract fbc's ARRAY STORAGE SIZES, for comparison against fbx's slot sizes.

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
FBC = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe")
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


def main() -> int:
    if not FBC.exists():
        print(f"array-truth: fbc not found at {FBC}", file=sys.stderr)
        return 3
    WORK.mkdir(parents=True, exist_ok=True)
    src = WORK / "arr.bas"
    body = "sub P( )\n" + "".join(f"    {d}\n" for _, d in CASES) + "end sub\n"
    src.write_text(body, encoding="utf-8")
    proc = subprocess.run([str(FBC), "-c", "-r", str(src), "-o", str(WORK / "arr.o")],
                          capture_output=True, text=True, cwd=str(WORK))
    c = WORK / "arr.c"
    if not c.exists():
        print("array-truth: no C intermediate\n" + (proc.stdout or "") + (proc.stderr or ""),
              file=sys.stderr)
        return 1

    text = c.read_text(encoding="utf-8", errors="replace")
    lines = []
    for name, _ in CASES:
        # __builtin_memset( (int32*)A$1, 0, 40ll );  -- the storage, not the descriptor
        m = re.search(r"__builtin_memset\(\s*\(?[^)]*\)?\s*&?"
                      + name.upper() + r"\$\d+,\s*0,\s*(\d+)ll\s*\)", text)
        if not m:
            print(f"array-truth: no memset found for {name}", file=sys.stderr)
            return 1
        lines.append(f"{name}\t{m.group(1)}")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"array-truth: {len(lines)} array sizes -> {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
