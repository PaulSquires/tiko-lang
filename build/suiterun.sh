#!/bin/sh
# suiterun.sh -- RUN the corpus's fbcunit SUITES under both compilers and compare.
#
# runscan.sh runs the 103 files tagged COMPILE_AND_RUN_OK. Most of the corpus is not
# those: it is fbcunit SUITES, which declare their assertions inside TEST blocks and
# cannot run standalone -- they have no main. icescan.sh compiles them to an object and
# stops, so what nobody has ever checked is whether the assertions PASS.
#
# They can be run. A suite links with fbcunit's own driver (tests/tests.bas) and its
# library, and the driver prints a table: asserts, passed, failed, per suite. That table
# is the differential -- and the ASSERTS ARE THE CORPUS'S OWN, thousands of them per file,
# written by fbc's authors to pin behaviour this project is trying to reproduce.
#
# BOTH COMPILERS BUILD THEIR OWN COPY OF THE LIBRARY, into separate directories: the
# archives are not interchangeable (fbc's objects want MinGW's __iob_func, tiko's MSVC
# target wants __acrt_iob_func) and lld-link will happily pick up the wrong one if they
# share a directory. That cost an hour; hence two directories and a comment.
#
# tiko is given its OWN headers, not fbc-modern's: the crt bindings differ per target and
# tiko's win64-msvc stdio.bi is the one that matches what it links against.
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
FBC=${FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
# TKO_SUITERUN_FLAGS: extra tiko flags for every compile -- "-O2" -- for the Phase 11 runs
# at each optimisation level. Unset is the ordinary run.
TKO=${TKO:-$ROOT/bin/tiko.exe}
AR=${AR:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/bin/win64/ar.exe}
CU=$ROOT/tests/vendor/fbc-tests/fbcunit
WK=${SUITERUN_WK:-${TMPDIR:-/tmp}/suiterun}
# THE RUN LIMIT, AND WHY IT IS NOT 60. math/core.bas walks all 2^32 single-precision
# bit patterns -- 4.3 BILLION iterations, classifying each one -- and these suites are
# built WITHOUT optimisation, because the comparison is tiko against fbc and both must
# get the same flags. Unoptimised that file takes 57.6 s under tiko and 38.5 s under
# fbc, so a 60 s limit left it 2.4 s of margin and one busy machine away from being
# reported as a difference it is not. Its output matches fbc's byte for byte.
#
# THE 1.5x IS -O0 CODE SHAPE AND NOTHING ELSE. The same suite, same machine:
#
#     tiko -O0  57.6 s      fbc -O 0  38.5 s
#     tiko -O1   2.70 s
#     tiko -O2   1.675 s    fbc -O 2   1.735 s
#
# At -O2 tiko is FASTER than fbc, so there is no codegen-quality gap to chase here --
# only unoptimised code, which is what a differential harness has to compare.
RUNTIMEOUT=${RUNTIMEOUT:-180}

export TKO_INCLUDE="$ROOT/toolchains/tiko-windows/inc"
export TKO_LIBPATH="$ROOT/toolchains/tiko-windows/lib/win64-msvc"

mkdir -p "$WK/fb" "$WK/tk" "$WK/o"
if [ ! -f "$WK/fb/libfbcunit.a" ] ; then
    echo "suiterun: building fbcunit with fbc"
    for f in "$CU"/src/*.bas ; do
        "$FBC" -c "$f" -i "$CU/inc" -i "$CU/src" -o "$WK/o/$(basename "$f" .bas).fbc.o" || exit 1
    done
    "$AR" rcs "$WK/fb/libfbcunit.a" "$WK/o"/*.fbc.o || exit 1
fi
if [ ! -f "$WK/tk/fbcunit.lib" ] ; then
    echo "suiterun: building fbcunit with tiko"
    for f in "$CU"/src/*.bas ; do
        "$TKO" ${TKO_SUITERUN_FLAGS:-} -c "$f" -i "$CU/inc" -i "$CU/src" -o "$WK/o/$(basename "$f" .bas).tko.o" || exit 1
    done
    "$AR" rcs "$WK/tk/fbcunit.lib" "$WK/o"/*.tko.o || exit 1
fi

DRV="$CU/tests/tests.bas"
nrun=0; nsame=0; ndiff=0; nfonly=0; ntonly=0; nneither=0
# ONE SUITE, OR A FAMILY OF THEM: the optional argument is a substring of the path.
# Phase 14 runs the whole corpus at each -O level and then has to ask whether one file
# that moved is a real difference or a flaky one, and re-running 630 suites to see a
# single answer costs eighteen minutes.
#
#   build/suiterun.sh                     every suite
#   build/suiterun.sh numbers/infnan      that one
#   build/suiterun.sh concurrency/        the family
SUITEPAT=${1:-}
for f in $(grep -rl "END_SUITE" tests/vendor/fbc-tests --include='*.bas' | sort | grep -F -- "$SUITEPAT") ; do
    n=$(echo "$f" | sed 's|[/\.]|_|g')
    fok=0; tok=0
    "$FBC"  "$DRV" "$f" -i "$CU/inc" -p "$WK/fb" -x "$WK/f_$n.exe" >/dev/null 2>&1 \
        && [ -f "$WK/f_$n.exe" ] && fok=1
    "$TKO" ${TKO_SUITERUN_FLAGS:-} "$DRV" "$f" -i "$CU/inc" -p "$WK/tk" -o "$WK/t_$n.exe" >/dev/null 2>&1 \
        && [ -f "$WK/t_$n.exe" ] && tok=1
    if [ $fok = 1 ] && [ $tok = 1 ] ; then
        nrun=$((nrun+1))
        # FROM A COPY OF THE TEST FILE'S OWN DIRECTORY. The exes ran in $WK, which
        # has none of the corpus's data files, so every suite that opens one relative
        # to itself -- file/*.bas, filesystem/*.bas -- failed its TRUE assertions
        # under BOTH compilers and reported dozens of defects that are the harness's.
        #
        # A COPY, not the directory itself: these suites WRITE files as well as read
        # them, and tests/vendor is fbc's own suite -- never edited, not even by a
        # test run. Copied once per directory and reused.
        # ONE COPY PER COMPILER, so a file the fbc run WRITES is not there for the
        # tiko run to read -- that would compare two different inputs.
        d=$(dirname "$f")
        for side in f t ; do
            if [ ! -d "$WK/rd/$side/$d" ] ; then
                mkdir -p "$WK/rd/$side/$d"
                cp "$d"/* "$WK/rd/$side/$d"/ 2>/dev/null
            fi
        done
        ( cd "$WK/rd/f/$d" && timeout "$RUNTIMEOUT" "$WK/f_$n.exe" </dev/null >"$WK/f_$n.txt" 2>&1 )
        ( cd "$WK/rd/t/$d" && timeout "$RUNTIMEOUT" "$WK/t_$n.exe" </dev/null >"$WK/t_$n.txt" 2>&1 )
        # PATH SEPARATORS ARE NOT A DIFFERENCE: fbc reports a failing assert as 'tests\vendor\...' and
        # tiko as 'tests/vendor/...', so two suites failing identically counted as DIFF (20 of 83).
        if cmp -s <(tr '\\' '/' < "$WK/f_$n.txt") <(tr '\\' '/' < "$WK/t_$n.txt") ; then
            nsame=$((nsame+1))
        else
            ndiff=$((ndiff+1))
            echo "suiterun: DIFF $f"
            diff "$WK/f_$n.txt" "$WK/t_$n.txt" 2>/dev/null | head -4 | sed 's/^/suiterun:     /'
        fi
    elif [ $fok = 1 ] ; then
        nfonly=$((nfonly+1)) ; echo "suiterun: FBC-ONLY  $f"
    elif [ $tok = 1 ] ; then
        ntonly=$((ntonly+1)) ; echo "suiterun: TIKO-ONLY $f"
    else
        nneither=$((nneither+1))
    fi
done
echo "suiterun: $nrun suites ran under both, $nsame match, $ndiff DIFFER"
echo "suiterun: $nfonly only fbc builds, $ntonly only tiko builds, $nneither neither"
