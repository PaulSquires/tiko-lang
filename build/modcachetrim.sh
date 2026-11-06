#!/bin/sh
# modcachetrim.sh -- the module cache removes what nothing can use (ADR 0017 §21).
#
#   bash build/modcachetrim.sh
#
# Each step is about what an EARLIER build left in the pool, which one test invocation cannot
# express. The program is compiled with '-c', which builds its modules into the pool and
# links nothing.
#
#   1. cold        one entry
#   2. edit        the module's source changes: its entry is REPLACED, not joined
#   3. config      the same module built with -g: a second entry, and the first stays
#   4. edit again  the -g entry is replaced; the other configuration's is untouched
#   5. unused      an entry unused for ten days goes at the daily trim; a fresh one stays
#   6. clean       --clean-module-cache removes every entry and nothing else in the pool
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TKO=${TKO:-$ROOT/bin/tiko.exe} ;;
    *) TKO=${TKO:-$ROOT/bin/tiko} ;;
esac
case "$TKO" in /*) ;; *) TKO=$ROOT/$TKO ;; esac   # the script changes directory
WK=${TMPDIR:-/tmp}/modcachetrim.$$
mkdir -p "$WK/acme/m"
trap 'rm -rf "$WK"' EXIT
cd "$WK"
export TIKO_MODCACHE="$WK/pool"
P="$WK/pool"

nok=0; nbad=0
pass() { echo "ok    $1"; nok=$((nok + 1)); }
fail() { echo "FAIL  $1"; nbad=$((nbad + 1)); }
entries() { ls "$P" 2>/dev/null | grep -cE '^[0-9a-f]{16}$'; }
build() { "$TKO" -c -m main "$@" -i "$WK" main.tiko -o main.o > out 2>&1; }

printf '#module "m"\npublic function A( ) as long\n    return 1\nend function\n' > acme/m/a.tiko
printf '#import "acme/m"\nprint m.A( )\n' > main.tiko

# 1. cold
build
first=$(ls "$P" | grep -E '^[0-9a-f]{16}$' | head -1)
if [ "$(entries)" = 1 ]; then pass "cold: one entry"; else fail "cold: $(entries) entries"; sed -n 1,5p out; fi

# 2. edit: replaced
sed -i 's/return 1/return 2/' acme/m/a.tiko
build
if [ "$(entries)" = 1 ] && [ ! -d "$P/$first" ]; then
    pass "edit: the superseded entry is gone, one left"
else
    fail "edit: $(entries) entries, first entry $( [ -d "$P/$first" ] && echo kept || echo gone )"
fi
plain=$(ls "$P" | grep -E '^[0-9a-f]{16}$' | head -1)

# 3. another configuration: kept beside it
build -g
if [ "$(entries)" = 2 ] && [ -d "$P/$plain" ]; then
    pass "config: -g adds an entry and keeps the other"
else
    fail "config: $(entries) entries"
fi

# 4. edit again under -g: only the -g entry is replaced
sed -i 's/return 2/return 3/' acme/m/a.tiko
build -g
if [ "$(entries)" = 2 ] && [ -d "$P/$plain" ]; then
    pass "edit again: the -g entry replaced, the other configuration's kept"
else
    fail "edit again: $(entries) entries, plain entry $( [ -d "$P/$plain" ] && echo kept || echo gone )"
fi

# 5. unused for ten days: trimmed at the next daily pass
rm -f "$P/$plain/used" "$P/trim.txt"
touch -d "10 days ago" "$P/$plain/key.txt"
build -g
if [ ! -d "$P/$plain" ] && [ "$(entries)" = 1 ]; then
    pass "unused: the ten-day-old entry trimmed, the fresh one kept"
else
    fail "unused: $(entries) entries, old entry $( [ -d "$P/$plain" ] && echo kept || echo gone )"
fi

# 6. clean: every entry, nothing else
mkdir -p "$P/keepme"; echo x > "$P/notes.txt"
"$TKO" --clean-module-cache > out 2>&1
if [ "$(entries)" = 0 ] && [ -d "$P/keepme" ] && [ -f "$P/notes.txt" ] && grep -q "removed 1 module cache entry" out; then
    pass "clean: every entry removed, the rest of the directory left"
else
    fail "clean: $(entries) entries"; cat out
fi

echo "modcachetrim: $nok ok, $nbad failed"
[ $nbad -eq 0 ]
