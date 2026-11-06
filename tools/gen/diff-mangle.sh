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
. "$(dirname "$0")/../../build/toolchain.sh"    # TIKO_ORACLE_FBC, TIKO_ORACLE_ROOT, TIKO_CLANG (BLD-12)
FBC=${TIKO_FBC:-$TIKO_ORACLE_FBC}
# THE HOST'S BINARY, chosen by PLATFORM and not by which file happens to
# exist. Preferring bin/tiko.exe and falling back only when it is absent
# picks the WINDOWS build under WSL, where both binaries sit in bin/ after
# a dual-platform session. WSL cannot run it, the 2>/dev/null below ate the
# error, and the comparison reported all 135 names missing rather than
# saying it never ran. Same idiom as build/build.sh.
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;; *) EXT="" ;; esac
TKO="$ROOT/bin/tiko$EXT"
# ...AND SAY SO WHEN IT IS NOT THERE. The dump below discards stderr, so a
# missing binary produced an empty result that read as "every name wrong".
[ -x "$TKO" ] || { echo "${0##*/}: $TKO not built" >&2; exit 3; }
LIST="$ROOT/build/.corpus.lst"
WORK="$ROOT/build/.mg/d"
LIMIT=${1:-400}

[ -x "$FBC" ]  || { echo "diff-mangle: SKIPPED -- no oracle fbc at $FBC (TIKO_ORACLE_FBC)"; exit 0; }
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
