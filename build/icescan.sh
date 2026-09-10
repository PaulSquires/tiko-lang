#!/bin/sh
# icescan.sh -- COMPILE the corpus, rather than dumping its IR.
#
# WHY THIS EXISTS. build/mirsweep.sh runs '--dump-ir', which stops before the LLVM
# emitter. Every fault in codegen is therefore invisible to it: the file reports
# '0 statements not lowered' and the sweep calls it clean. Two ICEs were found sitting in
# that blind spot by hand, and neither was exotic --
#
#     dim as zstring * 50 t = "42"
#     print clng( t )        fbc prints 42; tiko: emit: ICE: an aggregate value with no size
#
# -- two lines, no UDT. The decline census cannot see this class at all, so it needs an
# instrument of its own. This is it: '-c' on every corpus file, which runs the emitter and
# clang and stops before the link.
#
# IT IS SLOWER THAN THE SWEEP, several times over, because every file pays for clang. It
# is not meant to run on every change; it is meant to run when codegen has been touched,
# and before believing that a decline count means the corpus compiles.
#
# WHAT IT REPORTS is anything the emitter or the assembler refuses: 'ICE:' from the
# emitter, and a clang or lld failure. A file that DECLINES a statement still compiles,
# so a decline is not a finding here -- the two instruments answer different questions.
set -e

cd "$(dirname "$0")/.."

CORPUS_ROOT=tests/vendor/fbc-tests
CORPUS=$CORPUS_ROOT
[ -d "$CORPUS" ] || { echo "icescan: corpus not vendored" >&2; exit 3; }

[ -x ./bin/tiko.exe ] || { echo "icescan: build bin/tiko.exe first" >&2; exit 3; }

FBCUNIT=""
[ -d "$CORPUS_ROOT/fbcunit/inc" ] && FBCUNIT="-i $CORPUS_ROOT/fbcunit/inc"

TKOINC=${TKO_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$TKOINC" ]; then
    TKO_INCLUDE="$TKOINC"
    export TKO_INCLUDE
fi

find "$CORPUS" -name '*.bas' | sort > build/.icecorpus.lst

# Same reasoning as mirsweep's: one process per file, each writing its OWN part, six at a
# time so the fork table has headroom. Raise with ICESCAN_JOBS.
JOBS=${ICESCAN_JOBS:-6}

if [ -d build/.iceparts ]; then
    rm -rf build/.iceparts 2>/dev/null || true
fi
if [ -d build/.iceparts ]; then
    echo "icescan: cannot clear build/.iceparts -- a previous scan is still running" >&2
    exit 1
fi
mkdir -p build/.iceparts build/.iceobj

xargs -a build/.icecorpus.lst -d '
' -P "$JOBS" -I{} sh -c '
    key=$(printf %s "$1" | tr -c "A-Za-z0-9._-" "_")
    out=build/.iceobj/$key.o
    raw=build/.iceparts/$key.raw
    timeout 120 ./bin/tiko.exe -c '"$FBCUNIT"' "$1" -o "$out" > "$raw" 2>&1 || true
    # ONLY codegen-and-later faults. A TKO diagnostic is the frontend refusing the
    # program and belongs to mirsweep; an ICE or a clang failure belongs here.
    # A NEGATIVE TEST IS TAGGED, NOT SKIPPED. An ICE is wrong on invalid input
    # too -- a compiler diagnoses, it does not crash -- but a crash on a program
    # fbc also rejects is a different priority from one on a program fbc
    # compiles, and the census has to tell them apart.
    if grep -qE "TEST_MODE *: *COMPILE_(ONLY|AND_RUN)_FAIL" "$1" ; then
        tag=neg
    else
        tag=ok
    fi
    grep -iE "ICE:|clang: error|lld[^:]*: error|internal compiler" "$raw" \
        | sed "s|^|$tag $1: |" > "build/.iceparts/$key" || true
    rm -f "$raw" "$out"
' _ {}

want=$(wc -l < build/.icecorpus.lst)
got=$(ls build/.iceparts | wc -l)
if [ "$got" -ne "$want" ]; then
    echo "icescan: INCOMPLETE -- $got parts for $want files; the totals below are wrong" >&2
    exit 4
fi

cat build/.iceparts/* > build/.ice.out 2>/dev/null || true
rmdir build/.iceobj 2>/dev/null || true

total=$(wc -l < build/.ice.out)
files=$(cut -d' ' -f2 build/.ice.out | sort -u | wc -l)
neg=$(grep -c '^neg ' build/.ice.out || true)
echo "icescan: $want files compiled, $total codegen failures in $files files"
echo "icescan: $neg of them are in files fbc REJECTS too (TEST_MODE fail); the rest are not"
echo "icescan: --- by message ---"
cut -d' ' -f3- build/.ice.out \
    | sed -E "s/[0-9]+/N/g" \
    | sort | uniq -c | sort -rn | head -12 | sed 's/^/icescan:  /'
echo "icescan: --- the files fbc ACCEPTS, worst first ---"
grep '^ok ' build/.ice.out | cut -d' ' -f2 | sort | uniq -c | sort -rn | head -20 | sed 's/^/icescan:  /'
