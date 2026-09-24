#!/bin/sh
# cimportcache.sh -- the #cinclude cache: a miss, a hit, invalidation, -cnocache, and two
# cold builds at once.
#
#   bash build/cimportcache.sh
#
# What one test invocation cannot express, because each step is about what an EARLIER
# build left on disk. A hit is proved, not timed: a constant is planted in the cached
# binding, and only a build that used the entry can see it.
#
#   1. cold        the entry is made, deps.txt last
#   2. hit         a build sees the planted constant
#   3. edit        a header the binding read changes: the entry is remade, the plant gone
#   4. -cnocache   neither reads the entry (the plant is not seen) nor writes it
#   5. race        two cold builds at once both succeed and leave one whole entry
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TKO=${TKO:-$ROOT/bin/tiko.exe} ;;
    *) TKO=${TKO:-$ROOT/bin/tiko} ;;
esac
case "$TKO" in /*) ;; *) TKO=$ROOT/$TKO ;; esac   # the script changes directory
WK=${TMPDIR:-/tmp}/cimportcache.$$
mkdir -p "$WK/h"
trap 'rm -rf "$WK"' EXIT
cp tests/cimport/src/ci/common.h tests/cimport/src/ci/a.h "$WK/h/"
cd "$WK"
C="$WK/cache"
nok=0; nbad=0
pass() { echo "ok    $1"; nok=$((nok + 1)); }
fail() { echo "FAIL  $1"; nbad=$((nbad + 1)); }

printf '#cinclude "h/a.h"\ndim as ci_a v\nprint sizeof( v )\n' > use.bas
printf '#cinclude "h/a.h"\nprint CACHE_PLANT\n' > plant.bas

# 1. cold
"$TKO" --dump-ir -ccachedir "$C" use.bas > out1 2>&1
entry=$(ls "$C" 2>/dev/null | head -1)
if [ -n "$entry" ] && [ -f "$C/$entry/deps.txt" ] && [ -f "$C/$entry/binding.bi" ] && [ -f "$C/$entry/state.txt" ]; then
    pass "cold: the entry is made ($entry)"
else
    fail "cold: no whole entry"; sed -n 1,5p out1
fi

# 2. hit
printf '\nconst CACHE_PLANT = 7\n' >> "$C/$entry/binding.bi"
if "$TKO" --dump-ir -ccachedir "$C" plant.bas > out2 2>&1 && ! grep -q "error TKO" out2; then
    pass "hit: the planted constant is seen"
else
    fail "hit: the cached binding was not used"; sed -n 1,5p out2
fi

# 4. -cnocache (before the edit, while the plant is still there)
if "$TKO" --dump-ir -cnocache -ccachedir "$C" plant.bas > out4 2>&1; then
    fail "-cnocache: the plant was seen, so the cache was read"
elif grep -q "CACHE_PLANT = 7" "$C/$entry/binding.bi"; then
    pass "-cnocache: not read, and the entry is untouched"
else
    fail "-cnocache: the entry was rewritten"
fi

# 3. edit a dependency: the entry is remade and the plant is gone
sleep 1
sed 's/short s;/short s; int grown;/' h/common.h > h/common.tmp && mv h/common.tmp h/common.h
if "$TKO" --dump-ir -ccachedir "$C" plant.bas > out3 2>&1; then
    fail "edit: the stale binding was used"
elif grep -q "CACHE_PLANT = 7" "$C/$entry/binding.bi"; then
    fail "edit: the entry was not remade"
else
    "$TKO" --dump-ir -ccachedir "$C" use.bas > out3b 2>&1 && pass "edit: the entry is remade from the edited header" \
        || { fail "edit: the remade binding does not compile"; sed -n 1,5p out3b; }
fi

# 5. two cold builds at once
rm -rf "$C"
"$TKO" --dump-ir -ccachedir "$C" use.bas > r1 2>&1 & p1=$!
"$TKO" --dump-ir -ccachedir "$C" use.bas > r2 2>&1 & p2=$!
wait $p1; s1=$?
wait $p2; s2=$?
n=$(ls "$C" | wc -l | tr -d ' ')
e=$(ls "$C" | head -1)
if [ $s1 -eq 0 ] && [ $s2 -eq 0 ] && [ "$n" = 1 ] && [ -f "$C/$e/deps.txt" ] && ! ls "$C/$e" | grep -q '\.tmp$'; then
    pass "race: both builds succeed, one whole entry, no temporaries left"
else
    fail "race: exits $s1 $s2, $n entries"; ls -la "$C/$e" 2>&1 | head
fi

echo "cimportcache: $nok ok, $nbad failed"
[ $nbad -eq 0 ]
