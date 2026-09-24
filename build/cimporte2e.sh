#!/bin/sh
# cimporte2e.sh -- C libraries used through #cinclude, linked and RUN, on this host's targets.
#
#   bash build/cimporte2e.sh
#
# The tests in tests/cimport stop at the IR. This builds programs and runs them, because a
# binding whose declarations parse can still call C wrongly -- a struct by value in the
# wrong registers, a variadic, a callback -- and only running it shows that:
#
#   e2e.bas     tests/cimport/e2e/testlib.c, built by clang for the target: structs of 4,
#               8, 12, 16 and 24 bytes by value both ways, a callback, a variadic, globals
#   sys.bas     the target's own C library, and windows.h on Windows, as four #cinclude
#               lines in one unit -- each after the first a delta over the ones before
#   sqlite.bas  sqlite3.h against the amalgamation clang builds, when SQLITE_SRC (default
#               C:\dev\sqlite\vendor\sqlite3 or ~/sqlite3) holds sqlite3.c
#
# Each must print tests/cimport/e2e/<name>.expected byte for byte. e2e.expected is what the
# same program prints built by fbc-modern, whose importer it shares nothing with.
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        TARGETS="win64-msvc win64"; TKO=${TKO:-$ROOT/bin/tiko.exe}; EXE=.exe
        INC=${TKO_E2E_INC:-$ROOT/toolchains/tiko-windows/inc}
        SQL=${SQLITE_SRC:-/c/dev/sqlite/vendor/sqlite3} ;;
    *)
        TARGETS="linux-x86_64"; TKO=${TKO:-$ROOT/bin/tiko}; EXE=
        INC=${TKO_E2E_INC:-/mnt/c/dev/fbc-modern/toolchains/fbc-modern-linux/include/freebasic}
        SQL=${SQLITE_SRC:-$HOME/sqlite3} ;;
esac
case "$TKO" in /*) ;; *) TKO=$ROOT/$TKO ;; esac   # the script changes directory
CLANG=${CLANG:-clang}
WK=${TMPDIR:-/tmp}/cimporte2e.$$
mkdir -p "$WK"
trap 'rm -rf "$WK"' EXIT
unset TKO_LIBPATH
export TKO_INCLUDE="$INC"

libdirs() {
    case "$1" in
        win64-msvc)   echo "-p $ROOT/toolchains/tiko-windows/lib/win64-msvc" ;;
        win64)        echo "-p $ROOT/toolchains/tiko-windows/lib/win64 -p $ROOT/toolchains/tiko-windows/lib/win64-fb" ;;
        linux-x86_64) echo "-p $ROOT/lib/rt/lib/linux-x86_64" ;;
    esac
}
triple() {
    case "$1" in
        win64-msvc) echo x86_64-pc-windows-msvc ;;
        win64) echo x86_64-w64-windows-gnu ;;
        linux-x86_64) echo x86_64-pc-linux-gnu ;;
    esac
}

nrun=0; nok=0; nbad=0

# one <name> <target> <extra tiko args...>
one() {
    name=$1; t=$2; shift 2
    nrun=$((nrun + 1))
    # shellcheck disable=SC2046
    if ! "$TKO" -target "$t" -cnocache $(libdirs "$t") "tests/cimport/e2e/$name.bas" "$@" -o "$WK/$name.$t$EXE" > "$WK/$name.$t.log" 2>&1; then
        echo "$name $t: did not build"; sed -n 1,8p "$WK/$name.$t.log"; nbad=$((nbad + 1)); return
    fi
    # RUNS OF SPACES ARE ONE: the values are the test, and Windows' runtime pads the first
    # print zone of a redirected stdout by one more than Linux's does.
    "$WK/$name.$t$EXE" | tr -d '\r' | tr -s ' ' > "$WK/$name.$t.out"
    tr -d '\r' < "tests/cimport/e2e/$name.expected" | tr -s ' ' > "$WK/$name.$t.want"
    if cmp -s "$WK/$name.$t.want" "$WK/$name.$t.out"; then
        echo "$name $t: runs, and prints what it must"
        nok=$((nok + 1))
    else
        echo "$name $t: WRONG OUTPUT"; diff "$WK/$name.$t.want" "$WK/$name.$t.out" | head -12
        nbad=$((nbad + 1))
    fi
}

for t in $TARGETS; do
    if "$CLANG" --target="$(triple "$t")" -w -c tests/cimport/e2e/testlib.c -o "$WK/testlib.$t.o" > "$WK/cc.log" 2>&1; then
        one e2e "$t" "$WK/testlib.$t.o"
    else
        echo "e2e $t: clang could not build testlib.c"; sed -n 1,5p "$WK/cc.log"; nbad=$((nbad + 1))
    fi
    one sys "$t"
    if [ -f "$SQL/sqlite3.c" ]; then
        if "$CLANG" --target="$(triple "$t")" -O1 -w -c "$SQL/sqlite3.c" -o "$WK/sqlite3.$t.o" > "$WK/cc.log" 2>&1; then
            one sqlite "$t" -cinclude "$SQL" "$WK/sqlite3.$t.o"
        else
            echo "sqlite $t: clang could not build the amalgamation"; sed -n 1,5p "$WK/cc.log"; nbad=$((nbad + 1))
        fi
    else
        echo "sqlite $t: skipped -- no sqlite3.c in $SQL (set SQLITE_SRC)"
    fi
done
echo "cimporte2e: $nrun programs -- $nok right, $nbad not"
[ $nbad -eq 0 ]
