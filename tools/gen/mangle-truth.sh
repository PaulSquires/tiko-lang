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
. "$(dirname "$0")/../../build/toolchain.sh"    # TIKO_ORACLE_FBC, TIKO_ORACLE_ROOT, TIKO_CLANG (BLD-12)
FBC=${TIKO_FBC:-$TIKO_ORACLE_FBC}
SRC="$ROOT/tests/mangle/src/probe.bas"
OUT="$ROOT/tests/mangle/expected/fbc-mangle.txt"
WORK="$ROOT/build/.mg"

if [ ! -x "$FBC" ]; then
    echo "mangle-truth: fbc not found at $FBC" >&2
    exit 3
fi

mkdir -p "$WORK"
"$FBC" -c "$SRC" -o "$WORK/probe.o"
python "$ROOT/tools/gen/coffsyms.py" "$WORK/probe.o" | tr -d "\r" | sort > "$OUT"
echo "mangle-truth: $(wc -l < "$OUT" | tr -d ' ') symbols -> tests/mangle/expected/fbc-mangle.txt"

