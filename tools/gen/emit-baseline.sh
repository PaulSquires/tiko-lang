#!/bin/sh
# emit-baseline.sh -- which corpus files emit NO code, as a committed list.
#
# This exists because a question could not be answered. mirsweep.sh reports "N files emit
# code" as a single number; when it moved by one across six commits there was no way to
# say which file or which commit did it, and "I cannot tell" is the wrong answer to have
# available about a possible regression.
#
# The zero-emitting set is the useful one to pin: it is small (a tenth of the corpus),
# and a file moving in EITHER direction shows up as a diff rather than as a count.
#
#   tools/gen/emit-baseline.sh            compare against the committed list
#   tools/gen/emit-baseline.sh --accept   rewrite it
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
CORPUS=tests/vendor/fbc-tests
OUT=tests/expected/fbx-emit-none.txt
[ -d "$CORPUS" ] || { echo "emit-baseline: corpus not vendored" >&2; exit 3; }

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
: > build/.emitnone.txt
while IFS= read -r f; do
    n=$(./bin/fbx.exe --dump-ir "$f" 2>/dev/null | awk '/^lowered:/{print $2}')
    [ "${n:-0}" = "0" ] && echo "$f" >> build/.emitnone.txt
done < build/.corpus.lst

if [ "$1" = "--accept" ]; then
    mkdir -p "$(dirname "$OUT")"
    cp build/.emitnone.txt "$OUT"
    echo "emit-baseline: wrote $(wc -l < "$OUT") files to $OUT"
    exit 0
fi

[ -f "$OUT" ] || { echo "emit-baseline: no baseline; run with --accept" >&2; exit 3; }
if diff -u "$OUT" build/.emitnone.txt > build/.emitdiff.txt; then
    echo "emit-baseline: $(wc -l < build/.emitnone.txt) files emit nothing, unchanged"
else
    echo "emit-baseline: THE SET CHANGED --"
    grep -E '^[+-]tests/' build/.emitdiff.txt | sed 's/^/emit-baseline:   /'
    exit 1
fi
