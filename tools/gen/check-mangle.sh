#!/bin/sh
# check-mangle.sh -- the D3 gate: fbx's mangled names against fbc's, byte for byte.
#
#   tools/gen/check-mangle.sh
#
# Compares fbx --dump-mangle with the symbols tools/gen/mangle-truth.sh extracted
# from fbc. A single differing character here is a link error in someone else's
# project against a library fbx never saw, so the comparison is exact and the gate
# is all-or-nothing.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
FBX="$ROOT/bin/fbx.exe"
[ -x "$FBX" ] || FBX="$ROOT/bin/fbx"
EXPECTED="$ROOT/tests/mangle/expected/fbc-mangle.txt"
WORK="$ROOT/build/.mg"

if [ ! -f "$EXPECTED" ]; then
    echo "check-mangle: no expected file; run tools/gen/mangle-truth.sh" >&2
    exit 3
fi

mkdir -p "$WORK"
"$FBX" --dump-mangle "$ROOT/tests/mangle/src/probe.bas" 2>/dev/null | tr -d "\r" | sort > "$WORK/fbx.txt"

if diff -u "$EXPECTED" "$WORK/fbx.txt" > "$WORK/diff.txt"; then
    echo "check-mangle: ok -- $(wc -l < "$EXPECTED" | tr -d ' ')/$(wc -l < "$EXPECTED" | tr -d ' ') names match fbc"
    exit 0
fi

echo "check-mangle: MISMATCH"
cat "$WORK/diff.txt"
exit 1
