#!/bin/sh
# parse-gap.sh -- the REAL parser-quality metric: corpus files that fbc ACCEPTS and fbx
# does not parse cleanly.
#
# Counting fbx's error nodes alone is misleading, badly. The corpus is fbc's own test
# suite and contains many files fbc itself REJECTS -- deliberately invalid input, and
# machine-generated syntax-torture files. Measured 2026-08-18: of 11,719 error nodes,
# 11,613 (99.1%) were in files fbc also rejects. The raw count says the parser is failing
# on a third of everything; the comparison says 50 files.
#
# So the number that means something is this one: fbc exit-clean AND fbx error node.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
FBC=${FBX_FBC:-/c/dev/tiko_editor/toolchains/FreeBASIC-1.10.1-winlibs-gcc-9.3.0/fbc64.exe}
[ -x "$FBC" ] || { echo "parse-gap: fbc not found at $FBC" >&2; exit 3; }
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "parse-gap: corpus not vendored" >&2; exit 3; }

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
mkdir -p build/.rt
: > build/.parsegap.out
while IFS= read -r f; do
    n=$(./bin/fbx.exe --dump-ir "$f" 2>/dev/null | awk '/^  unlowered N_ERROR/{print $3}')
    [ -n "$n" ] || continue
    e=$("$FBC" -c "$f" -o build/.rt/pg.o 2>&1 | grep -c 'error [0-9]' || true)
    [ "$e" = "0" ] && echo "$n $f" >> build/.parsegap.out
done < build/.corpus.lst

files=$(wc -l < build/.parsegap.out)
nodes=$(awk '{s+=$1} END{print s+0}' build/.parsegap.out)
echo "parse-gap: $files files fbc accepts and fbx does not parse cleanly, $nodes error nodes"
echo "parse-gap: worst first ->"
sort -rn build/.parsegap.out | head -10 | sed 's/^/parse-gap:   /'
