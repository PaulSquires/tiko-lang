#!/bin/sh
# goldenrun.sh -- BUILD AND RUN every test source, and difference it against fbc.
#
# The MIR tests dump IR and stop. --dump-ir runs before the LLVM emitter, so a test
# whose golden looks right may still describe a program that does not build, or builds
# and prints the wrong thing. Fifteen-plus goldens in one session held exactly that,
# every one of them a file nobody had ever executed.
#
# This is the instrument that would have found them. For each tests/*/src/*.bas:
#
#   - build it with tiko and with fbc
#   - where BOTH build, run both and compare the bytes
#
# A file only fbc builds is reported; one only tiko builds is reported too, and so is
# an output difference. A file NEITHER builds is silent: the diagnostics tests are
# meant not to compile, and so are several MIR sources.
#
# Not a gate: it is slow (two compilers over 500 files) and some sources are
# deliberately partial. Read the three counts.
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
FBC=${FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
TKO=${TKO:-$ROOT/bin/tiko.exe}
WK=${TMPDIR:-/tmp}/goldenrun.$$
mkdir -p "$WK"
export TKO_LIBPATH="$ROOT/toolchains/tiko-windows/lib/win64-msvc"

nboth=0; nsame=0; ndiff=0; ntonly=0; nfonly=0; nneither=0
for f in tests/*/src/*.bas ; do
    n=$(basename "$f" .bas)
    tok=0; fbk=0
    "$TKO" "$f" -o "$WK/t_$n.exe" >/dev/null 2>&1 && [ -f "$WK/t_$n.exe" ] && tok=1
    "$FBC" "$f" -x "$WK/f_$n.exe" >/dev/null 2>&1 && [ -f "$WK/f_$n.exe" ] && fbk=1
    if [ $tok = 1 ] && [ $fbk = 1 ] ; then
        nboth=$((nboth+1))
        ( cd "$WK" && ./t_$n.exe > t_$n.txt 2>&1 ; echo $? > t_$n.rc )
        ( cd "$WK" && ./f_$n.exe > f_$n.txt 2>&1 ; echo $? > f_$n.rc )
        if cmp -s "$WK/t_$n.txt" "$WK/f_$n.txt" && cmp -s "$WK/t_$n.rc" "$WK/f_$n.rc" ; then
            nsame=$((nsame+1))
        else
            ndiff=$((ndiff+1))
            echo "goldenrun: DIFF $f"
            diff "$WK/f_$n.txt" "$WK/t_$n.txt" 2>/dev/null | head -6 | sed 's/^/goldenrun:     /'
            if ! cmp -s "$WK/t_$n.rc" "$WK/f_$n.rc" ; then
                echo "goldenrun:     exit fbc=$(cat "$WK/f_$n.rc") tiko=$(cat "$WK/t_$n.rc")"
            fi
        fi
    elif [ $tok = 1 ] ; then
        ntonly=$((ntonly+1)) ; echo "goldenrun: TIKO-ONLY $f"
    elif [ $fbk = 1 ] ; then
        nfonly=$((nfonly+1)) ; echo "goldenrun: FBC-ONLY  $f"
    else
        nneither=$((nneither+1))
    fi
done
echo "goldenrun: $nboth both build, $nsame match, $ndiff DIFFER"
echo "goldenrun: $ntonly only tiko builds, $nfonly only fbc builds, $nneither neither"
rm -rf "$WK"
