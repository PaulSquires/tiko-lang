#!/bin/sh
# runscan.sh -- RUN the corpus against fbc, rather than stopping at the link.
#
# WHY THIS EXISTS. build/icescan.sh stops at '-c' and build/linkscan.sh stops at the
# link, so neither can see a program that builds perfectly and then prints the wrong
# thing. That class is the one this project cares about most and the one it had no
# instrument for: 'open err' was a miscompile inside a decline group, FOR-over-UDT was
# garbage IR that passed the verifier, and both printed rather than crashed.
#
# IT IS A DIFFERENTIAL, and fbc is the ground truth -- the same rule CLAUDE.md states.
# Each file is built TWICE, once by tiko and once by fbc, run, and the two outputs
# compared byte for byte. A file where FBC ITSELF will not build or run is reported as
# 'fbcfail' and never as a finding: that is a corpus file newer than the installed
# headers, not a tiko fault.
#
# WHAT IS RUN, AND WHY IT IS A SUBSET. Only files tagged
#
#     ' TEST_MODE : COMPILE_AND_RUN_OK
#
# which is the corpus's own statement that the file is a standalone program meant to run
# and exit 0. The fbcunit tests are NOT here: they are designed to be linked into ONE
# fbc-tests.exe (unit-tests.mk) and running them one at a time answers a question nobody
# asked. Some of the tagged files still cannot be run unattended -- anything reading
# stdin or opening a graphics window -- so every run has a timeout and a closed stdin,
# and a timeout is reported as its own class rather than as a mismatch.
set -e

cd "$(dirname "$0")/.."

CORPUS_ROOT=tests/vendor/fbc-tests
[ -d "$CORPUS_ROOT" ] || { echo "runscan: corpus not vendored" >&2; exit 3; }
# TKO_RUNSCAN_FLAGS: extra tiko flags for every build -- "-O2", "-O3" -- for the Phase 11
# corpus runs at each optimisation level. Unset is the ordinary run.
[ -x ./bin/tiko.exe ] || { echo "runscan: build bin/tiko.exe first" >&2; exit 3; }

FBC=${FBC:-/c/dev/tiko_editor/toolchains/FreeBASIC-1.10.1-winlibs-gcc-9.3.0/fbc64.exe}
[ -x "$FBC" ] || { echo "runscan: fbc not found at $FBC -- set FBC=" >&2; exit 3; }

# THE SECOND REFERENCE, and a third of the corpus needs it. 72 of the 103 files were
# reported "fbc will not build it" on the first run, and the reason is one line:
#
#     error 23: File not found, "fb/comptr.bi"
#
# fb/comptr.bi, fb/logging.bi, fb/vector.bi and their siblings are FBC-MODERN's library
# headers and fbc 1.10 has none of them. Those files are not unbuildable; they are
# written against the other compiler. So the reference is chosen PER FILE -- 1.10 first,
# because it is the compatibility target, and fbc-modern only where 1.10 cannot see the
# headers at all -- and every finding says which one answered.
FBCM=${FBCM:-${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}}

FBCUNIT=""
[ -d "$CORPUS_ROOT/fbcunit/inc" ] && FBCUNIT="-i $CORPUS_ROOT/fbcunit/inc"

TKOINC=${TKO_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$TKOINC" ]; then
    TKO_INCLUDE="$TKOINC"
    export TKO_INCLUDE
fi

# See linkscan.sh: the development tree has no lib/<target>, so the toolchain's own
# directory has to be named.
if [ -z "$TKO_LIBPATH" ]; then
    if [ -d toolchains/tiko-windows/lib/windows-x86_64 ]; then
        TKO_LIBPATH="$PWD/toolchains/tiko-windows/lib/windows-x86_64"
        export TKO_LIBPATH
    fi
fi

grep -rl "TEST_MODE *: *COMPILE_AND_RUN_OK" "$CORPUS_ROOT" --include='*.bas' \
    | sort > build/.runcorpus.lst

JOBS=${RUNSCAN_JOBS:-4}

if [ -d build/.runparts ]; then
    rm -rf build/.runparts 2>/dev/null || true
fi
if [ -d build/.runparts ]; then
    echo "runscan: cannot clear build/.runparts -- a previous scan is still running" >&2
    exit 1
fi
mkdir -p build/.runparts build/.runbin

export FBC FBCM FBCUNIT

xargs -a build/.runcorpus.lst -d '
' -P "$JOBS" -I{} sh -c '
    key=$(printf %s "$1" | tr -c "A-Za-z0-9._-" "_")
    d=build/.runbin/$key
    mkdir -p "$d"
    part=build/.runparts/$key

    # THE REFERENCE FIRST, because a file neither compiler will build is not a finding
    # and there is no point paying for the tiko half.
    #
    # ...AND WITH THE DIALECT THE FILE IS WRITTEN IN. The corpus keeps its non-fb
    # dialects in directories, the way fbcs own runner does, and most of those files
    # carry no #lang line at all -- the RUNNER is expected to pass -lang. Without it
    # the reference failed on eighteen files and this scan recorded them as
    # "neither compiler builds it", which was a claim about fbc that is not true:
    # fbc64 -lang qb qb/rnd.bas builds clean, and so does every one of the four
    # deprecated/ files under -lang deprecated. They belong in the tiko column --
    # tiko-lang is fb-dialect only and declines them -- not in fbcs.
    dialect=""
    case "$1" in
        */qb/*)         dialect="-lang qb" ;;
        */fblite/*)     dialect="-lang fblite" ;;
        */deprecated/*) dialect="-lang deprecated" ;;
    esac
    ref=fbc
    if ! timeout 120 "$FBC" $dialect $FBCUNIT "$1" -x "$d/f.exe" > "$d/f.build" 2>&1 ; then
        ref=fbcm
        if [ ! -x "$FBCM" ]; then
            echo "fbcfail $1: fbc will not build it and fbc-modern is not installed" > "$part"
            rm -rf "$d"
            exit 0
        fi
        if ! timeout 120 "$FBCM" $dialect $FBCUNIT "$1" -x "$d/f.exe" > "$d/f.build" 2>&1 ; then
            why=$(grep -m1 -iE "error [0-9]+" "$d/f.build" | cut -c1-80)
            [ -n "$why" ] || why="no diagnostic"
            echo "fbcfail $1: neither compiler builds it -- $why" > "$part"
            rm -rf "$d"
            exit 0
        fi
    fi
    timeout 30 "$d/f.exe" > "$d/f.out" 2>&1 < /dev/null
    frc=$?
    if [ $frc -ge 124 ]; then
        echo "fbcfail $1: the reference times out or needs input" > "$part"
        rm -rf "$d"
        exit 0
    fi

    if ! timeout 120 ./bin/tiko.exe $TKO_RUNSCAN_FLAGS $FBCUNIT "$1" -o "$d/t.exe" > "$d/t.build" 2>&1 ; then
        # THE FIRST LINE ONLY. A build failure here is already icescan or linkscan
        # material; what this census needs is that it happened and roughly why.
        # THE DIAGNOSTIC, not the first line. A build that reaches codegen prints the
        # module before it fails, so head -1 reported a global variable rather than a
        # reason.
        why=$(grep -m1 -iE "error TKO|ICE:|lld[^:]*: error|clang: error" "$d/t.build" | cut -c1-90)
        [ -n "$why" ] || why=$(head -1 "$d/t.build" | cut -c1-90)
        echo "build $1: [$ref] $why" > "$part"
        rm -rf "$d"
        exit 0
    fi
    timeout 30 "$d/t.exe" > "$d/t.out" 2>&1 < /dev/null
    trc=$?
    # A TIMEOUT IS 124, AND ONLY 124. 'timeout' reports 124 when it fires and 137 when
    # it has to SIGKILL; 127 is not a timeout at all -- under this shell a Windows
    # process that dies on a fatal exception reports it, and so does an exe that will
    # not start. Lumping 127 in with the timeouts labelled twelve files "hang" when
    # tuple/equality.bas was in fact exiting 0xC0000374, heap corruption, in under a
    # second. Measured by running the same binary under PowerShell, which reports the
    # real status word.
    if [ $trc -eq 124 ] || [ $trc -eq 137 ]; then
        echo "hang $1: [$ref] tiko build runs past 30s where the reference exited $frc" > "$part"
        rm -rf "$d"
        exit 0
    fi
    if [ $trc -eq 127 ]; then
        echo "crash $1: [$ref] tiko build died or would not start; the reference exited $frc" > "$part"
        rm -rf "$d"
        exit 0
    fi

    if [ "$trc" != "$frc" ]; then
        echo "exit $1: [$ref] tiko exits $trc where the reference exits $frc" > "$part"
        rm -rf "$d"
        exit 0
    fi
    if cmp -s "$d/t.out" "$d/f.out" ; then
        : > "$part"
    else
        first=$(diff "$d/f.out" "$d/t.out" | head -4 | tr "\n" " " | cut -c1-120)
        echo "output $1: [$ref] $first" > "$part"
    fi
    rm -rf "$d"
' _ {}

want=$(wc -l < build/.runcorpus.lst)
got=$(ls build/.runparts | wc -l)
if [ "$got" -ne "$want" ]; then
    echo "runscan: INCOMPLETE -- $got parts for $want files; the totals below are wrong" >&2
    exit 4
fi

cat build/.runparts/* > build/.run.out 2>/dev/null || true
rm -rf build/.runbin 2>/dev/null || true

fbcfail=$(grep -c '^fbcfail ' build/.run.out || true)
bld=$(grep -c '^build ' build/.run.out || true)
hang=$(grep -c '^hang ' build/.run.out || true)
crash=$(grep -c '^crash ' build/.run.out || true)
exitn=$(grep -c '^exit ' build/.run.out || true)
outn=$(grep -c '^output ' build/.run.out || true)
ok=$((want - fbcfail - bld - hang - crash - exitn - outn))
# THE DIALECT FILES, COUNTED SEPARATELY. tiko-lang is fb-dialect only, so a qb,
# fblite or deprecated file is out of scope by decision rather than by defect --
# and it goes wrong in TWO ways, which is why they are counted rather than skipped.
# One carries a #lang line and is declined outright; one carries none, because the
# runner is meant to pass -lang, and tiko compiles it as fb and gives a DIFFERENT
# ANSWER in silence. Folding either into the plain totals made the score look like a
# statement about correctness when it is a statement about scope.
dialectfiles=$(grep -cE "/(qb|fblite|deprecated)/|-(qb|fblite)[.]bas" build/.runcorpus.lst)
dialectbad=$(grep -E "^(build|exit|output|hang|crash) " build/.run.out | grep -cE "/(qb|fblite|deprecated)/|-(qb|fblite)[.]bas")
echo "runscan: $want files tagged COMPILE_AND_RUN_OK"
echo "runscan: $ok match the reference byte for byte, $fbcfail no reference can build or run"
echo "runscan: $bld tiko will not build, $hang hang, $crash CRASH, $exitn differ in EXIT CODE, $outn in OUTPUT"
echo "runscan: of those, $dialectfiles are qb/fblite/deprecated DIALECT files -- out of scope; $dialectbad of them do not match"
echo "runscan: --- crashes ---"
grep '^crash ' build/.run.out | sed 's/^/runscan:  /' | head -15
echo "runscan: --- output mismatches ---"
grep '^output ' build/.run.out | sed 's/^/runscan:  /' | head -25
echo "runscan: --- exit-code mismatches ---"
grep '^exit ' build/.run.out | sed 's/^/runscan:  /' | head -15
echo "runscan: --- build failures ---"
grep '^build ' build/.run.out | sed 's/^/runscan:  /' | head -15
