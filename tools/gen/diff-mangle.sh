#!/bin/sh
# diff-mangle.sh -- the D3 gate at CORPUS scale: tiko-lang's mangled names against fbc's,
# over third-party source rather than over a probe tiko-lang's author wrote.
#
#   tools/gen/diff-mangle.sh [<file-count>]
#
# For each corpus file fbc can compile standalone, the object file's CODE symbols are
# compared with tiko-lang --dump-mangle. Files fbc rejects are skipped and counted, not
# silently dropped: a gate that quietly compares nothing reports a perfect score.
#
# Only code-section symbols are compared. An object file's externals also carry
# public variables and the linker's .refptr.* indirection stubs for imported data,
# and tiko-lang --dump-mangle emits procedures only.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
FBC=${TKO_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
TKO="$ROOT/bin/tiko.exe"
[ -x "$TKO" ] || TKO="$ROOT/bin/tiko"
LIST="$ROOT/build/.corpus.lst"
WORK="$ROOT/build/.mg/d"
LIMIT=${1:-400}

[ -x "$FBC" ]  || { echo "diff-mangle: fbc not found at $FBC" >&2; exit 3; }
[ -f "$LIST" ] || { echo "diff-mangle: no corpus list; run build/sweep.sh" >&2; exit 3; }

rm -rf "$WORK"
mkdir -p "$WORK"
: > "$WORK/miss.txt"
# fbc knows its own inc/ directory implicitly; tiko-lang has to be told, or the comparison
# is between a compiler that found its headers and one that did not.
FBCINC=$(dirname "$FBC")/inc
INC="-i $ROOT/tests/vendor/fbc-tests -i $ROOT/tests/vendor/fbc-tests/fbcunit/inc"
TKOINC="$INC -i $FBCINC"

# A UNIQUE object per file, never a reused one. Sharing a single t.o means a
# lingering lock on Windows makes 'rm' fail, and under 'set -e' that aborted the run
# mid-sweep -- which showed up as a plausible but wrong score, not as an error.
ok=0; skip=0; exact=0; partial=0; tot=0; hit=0; idx=0
for f in $(head -"$LIMIT" "$LIST"); do
    idx=$((idx + 1))
    OBJ="$WORK/o$idx.o"
    if ! timeout 25 "$FBC" -c $INC "$f" -o "$OBJ" >/dev/null 2>&1; then
        skip=$((skip + 1)); continue
    fi
    [ -f "$OBJ" ] || { skip=$((skip + 1)); continue; }
    python "$ROOT/tools/gen/coffsyms.py" "$OBJ" --functions 2>/dev/null \
        | tr -d '\r' | sort -u > "$WORK/a.txt" || { skip=$((skip + 1)); continue; }
    n=$(wc -l < "$WORK/a.txt" | tr -d ' ')
    [ "$n" -eq 0 ] && { skip=$((skip + 1)); continue; }
    timeout 25 "$TKO" --dump-mangle $TKOINC "$f" 2>/dev/null \
        | tr -d '\r' | sort -u > "$WORK/b.txt" || true
    h=$(comm -12 "$WORK/a.txt" "$WORK/b.txt" | wc -l | tr -d ' ')
    ok=$((ok + 1)); tot=$((tot + n)); hit=$((hit + h))
    if [ "$h" -eq "$n" ]; then
        exact=$((exact + 1))
    else
        partial=$((partial + 1))
        echo "$f  $h/$n" >> "$WORK/miss.txt"
        comm -23 "$WORK/a.txt" "$WORK/b.txt" | sed 's/^/    fbc only: /' >> "$WORK/miss.txt"
    fi
done

echo "diff-mangle: $ok files compared, $skip skipped (fbc would not compile them)"
echo "diff-mangle: $exact byte-exact, $partial with differences"
if [ "$tot" -gt 0 ]; then
    echo "diff-mangle: $hit/$tot symbols match"
fi
[ "$partial" -eq 0 ]
