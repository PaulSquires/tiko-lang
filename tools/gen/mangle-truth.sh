#!/bin/sh
# mangle-truth.sh -- regenerate the expected mangled names from FBC ITSELF.
#
#   tools/gen/mangle-truth.sh
#
# Compiles tests/mangle/src/probe.bas with fbc and reads the LINKER-VISIBLE symbols
# out of the resulting object file. The names are never written by hand: decision D3
# is that tiko-lang's output must be byte-identical to fbc's, and a hand-copied expectation
# would only ever prove that two humans agreed.
#
# The toolchain ships no nm or objdump, so tools/gen/coffsyms.py reads the COFF
# symbol table directly. Reading fbc's -r C intermediate instead would be wrong: its
# names carry the C emitter's own decoration, which is not what the linker sees.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
FBC=${TKO_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
SRC="$ROOT/tests/mangle/src/probe.bas"
OUT="$ROOT/tests/mangle/expected/fbc-mangle.txt"
WORK="$ROOT/build/.mg"

if [ ! -x "$FBC" ]; then
    echo "mangle-truth: fbc not found at $FBC" >&2
    exit 3
fi

# The win32 half comes from a DIFFERENT fbc, because fbc-modern has no 32-bit build.
# That is a cross-version comparison, so it is controlled rather than assumed: running
# 1.10.1 win64 over the same probe gives a file BYTE-IDENTICAL to fbc-modern's, which is
# what makes 1.10.1 win32 usable as ground truth for mangling.
FBC32=${TKO_FBC32:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc32.exe}
OUT32="$ROOT/tests/mangle/expected/fbc-mangle-win32.txt"

mkdir -p "$WORK"
"$FBC" -c "$SRC" -o "$WORK/probe.o"
python "$ROOT/tools/gen/coffsyms.py" "$WORK/probe.o" | tr -d "\r" | sort > "$OUT"
echo "mangle-truth: $(wc -l < "$OUT" | tr -d ' ') symbols -> tests/mangle/expected/fbc-mangle.txt"

if [ -x "$FBC32" ]; then
    "$FBC32" -c "$SRC" -o "$WORK/probe32.o"
    python "$ROOT/tools/gen/coffsyms.py" "$WORK/probe32.o" | tr -d "\r" | sort > "$OUT32"
    echo "mangle-truth: $(wc -l < "$OUT32" | tr -d ' ') symbols -> tests/mangle/expected/fbc-mangle-win32.txt"
else
    echo "mangle-truth: no 32-bit fbc at $FBC32; win32 expectations left as they are" >&2
fi
