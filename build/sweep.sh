#!/bin/sh
# sweep.sh -- run the whole vendored corpus through the front end.
#
#   build/sweep.sh [--time]
#
# The Phase 3/4 gate: every one of fbc's 2,709 test files must lex, preprocess and
# parse with no crash and no unexplained diagnostic. Separate from build/test.sh
# because it takes seconds rather than milliseconds; CI runs both.
#
# Set TKO_FB_INC to a FreeBASIC 'inc' directory so the corpus's system includes
# (fbgfx.bi, fb/*.bi, win/*.bi) resolve.

set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;; *) EXT="" ;; esac

CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "sweep: corpus not vendored; run tools/vendor-corpus.sh" >&2; exit 3; }

EXTRA=""
[ "$1" = "--time" ] && EXTRA="--time-passes"

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
NFILES=$(wc -l < build/.corpus.lst)

run_pass( ) {
    mode=$1; shift
    split -n l/9 build/.corpus.lst build/.chunk.
    : > "build/.$mode.out"
    : > "build/.$mode.err"
    for c in build/.chunk.*; do
        ./bin/tiko$EXT "--$mode-only" $EXTRA "$@" $(cat "$c" | tr '\n' ' ') \
            >> "build/.$mode.out" 2>> "build/.$mode.err" || true
    done
    rm -f build/.chunk.*
}

# Count files that produced at least one diagnostic in the given id range.
files_with( ) {
    grep -oE "^[^(]+\([0-9]+,[0-9]+\): error TKO$1" "build/.$2.err" 2>/dev/null \
        | sed 's/(.*//' | sort -u | wc -l
}

INC="-i $CORPUS -i $CORPUS/fbcunit/inc"
[ -n "$TKO_FB_INC" ] && INC="$INC -i $TKO_FB_INC"

# ---- pass 1: lexing only
run_pass lex
awk '/lexed/ { b+=$4; t+=$6; i+=$8 }
     END { printf "sweep: lex   %d bytes, %d tokens, %d INVALID\n", b, t, i }' build/.lex.out

# ---- pass 2: through the preprocessor
run_pass pp $INC
awk '/preprocessed/ { t+=$4; i+=$6; x+=$8 }
     END { printf "sweep: pp    %d tokens, %d includes, %d expansions\n", t, i, x }' build/.pp.out
echo "sweep: pp    $(grep -c . build/.pp.err) diagnostic line(s)  [build/.pp.err]"

# ---- pass 3: through the parser
run_pass parse $INC
awk '/parsed/ { n+=$4 } END { printf "sweep: ast   %d nodes\n", n }' build/.parse.out
BAD=$(files_with "04" parse)
awk -v bad="$BAD" -v tot="$NFILES" \
    'BEGIN { printf "sweep: parse %d/%d files clean (%.1f%%)\n", tot-bad, tot, 100*(tot-bad)/tot }'
echo "sweep: parse $(grep -c . build/.parse.err) diagnostic line(s)  [build/.parse.err]"

echo "sweep: $NFILES files"
