#!/bin/sh
# check-mangle.sh -- the D3 gate: tiko-lang's mangled names against fbc's, byte for byte.
#
#   tools/gen/check-mangle.sh
#
# Compares tiko-lang --dump-mangle with the symbols tools/gen/mangle-truth.sh extracted
# from fbc. A single differing character here is a link error in someone else's
# project against a library tiko-lang never saw, so the comparison is exact and the gate
# is all-or-nothing.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
TKO="$ROOT/bin/tiko.exe"
[ -x "$TKO" ] || TKO="$ROOT/bin/tiko"
EXPECTED="$ROOT/tests/mangle/expected/fbc-mangle.txt"
WORK="$ROOT/build/.mg"

if [ ! -f "$EXPECTED" ]; then
    echo "check-mangle: no expected file; run tools/gen/mangle-truth.sh" >&2
    exit 3
fi

EXPECTED32="$ROOT/tests/mangle/expected/fbc-mangle-win32.txt"

mkdir -p "$WORK"
rc=0

one( ) {
    want=$1; tgt=$2; label=$3
    if [ ! -f "$want" ]; then
        echo "check-mangle: no $label expectations" >&2
        return 3
    fi
    "$TKO" --dump-mangle $tgt "$ROOT/tests/mangle/src/probe.bas" 2>/dev/null         | tr -d "\r" | sort > "$WORK/tiko-$label.txt"
    if diff -u "$want" "$WORK/tiko-$label.txt" > "$WORK/diff-$label.txt"; then
        n=$(wc -l < "$want" | tr -d ' ')
        echo "check-mangle: $label ok -- $n/$n names match fbc"
        return 0
    fi
    echo "check-mangle: $label MISMATCH"
    cat "$WORK/diff-$label.txt"
    return 1
}

one "$EXPECTED"   ""              win64 || rc=1
one "$EXPECTED32" "-target win32" win32 || rc=1
exit $rc
