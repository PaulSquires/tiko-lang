#!/bin/sh
# linkscan.sh -- LINK the corpus, rather than stopping at the object.
#
# WHY THIS EXISTS. build/icescan.sh stops at '-c', so it sees the emitter and clang and
# nothing after them. A whole class of fault lives past that point and reads as clean
# from both existing instruments:
#
#     type T2 : as string s : end type
#     dim as const T2 c2 = T2( )
#
# -- '0 statements not lowered', no ICE, clang happy, and then
#
#     lld-link: error: undefined symbol: T2::T2()
#
# because the SYNTHESISED constructor and destructor are DECLARED and never defined.
# tests/mir/src/const-object-init.bas has carried both 'declare's in its golden since
# before this file existed and nothing was in a position to notice.
#
# IT IS SLOWER THAN icescan, because every file pays for a link on top of a compile, and
# noisier: a corpus file that is one half of a pair has no 'main' and cannot link on its
# own. Those are recognised and reported separately rather than counted as findings --
# see the 'nomain' tag -- so the number at the top means what it says.
#
# WHAT IT REPORTS is any lld or clang failure at the LINK step. An ICE or a codegen
# failure belongs to icescan and is not counted here: a file that cannot compile cannot
# link either, and reporting it twice would put the same fault in two censuses.
set -e

cd "$(dirname "$0")/.."

CORPUS_ROOT=tests/vendor/fbc-tests
[ -d "$CORPUS_ROOT" ] || { echo "linkscan: corpus not vendored" >&2; exit 3; }
[ -x ./bin/tiko.exe ] || { echo "linkscan: build bin/tiko.exe first" >&2; exit 3; }

FBCUNIT=""
[ -d "$CORPUS_ROOT/fbcunit/inc" ] && FBCUNIT="-i $CORPUS_ROOT/fbcunit/inc"

TKOINC=${TKO_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$TKOINC" ]; then
    TKO_INCLUDE="$TKOINC"
    export TKO_INCLUDE
fi

# THE DEVELOPMENT TREE HAS NO lib/<target>. AppendBundledLibDirs_ looks under
# <exe-dir>/../lib, and lib/ there holds gfx and rt and no import libraries at all, so a
# bare './bin/tiko.exe prog.bas -o prog.exe' fails on ucrtbase.lib. The toolchain's own
# directory is where they are; TKO_LIBPATH is the supported way to say so.
if [ -z "$TKO_LIBPATH" ]; then
    if [ -d toolchains/tiko-windows/lib/win64-msvc ]; then
        TKO_LIBPATH="$PWD/toolchains/tiko-windows/lib/win64-msvc"
        export TKO_LIBPATH
    fi
fi

# THE CORPUS'S OWN TEST FRAMEWORK, BUILT BY tiko ITSELF. 592 of the 2,709 files
# '#inclib "fbcunit"', and without the library every one of them reports the same
# missing-file error and buries whatever else the scan found. Building it here is not a
# convenience: it is the only way the number at the top means anything -- and it is a
# real exercise of -lib over three source files besides.
FBCUNITLIB=build/.fbcunit
if [ ! -f "$FBCUNITLIB/libfbcunit.a" ]; then
    mkdir -p "$FBCUNITLIB"
    ./bin/tiko.exe -lib \
        "$CORPUS_ROOT/fbcunit/src/fbcunit.bas" \
        "$CORPUS_ROOT/fbcunit/src/fbcunit_console.bas" \
        "$CORPUS_ROOT/fbcunit/src/fbcunit_report.bas" \
        -i "$CORPUS_ROOT/fbcunit/inc" -i "$CORPUS_ROOT/fbcunit/src" \
        -o "$FBCUNITLIB/libfbcunit.a" >/dev/null 2>&1 || true
fi
if [ -f "$FBCUNITLIB/libfbcunit.a" ]; then
    FBCUNIT="$FBCUNIT -p $PWD/$FBCUNITLIB"
else
    echo "linkscan: WARNING -- libfbcunit.a could not be built; every file that" >&2
    echo "linkscan: includes fbcunit.bi will report a missing library, not a finding" >&2
fi

find "$CORPUS_ROOT" -name '*.bas' | sort > build/.linkcorpus.lst

JOBS=${LINKSCAN_JOBS:-6}

if [ -d build/.linkparts ]; then
    rm -rf build/.linkparts 2>/dev/null || true
fi
if [ -d build/.linkparts ]; then
    echo "linkscan: cannot clear build/.linkparts -- a previous scan is still running" >&2
    exit 1
fi
mkdir -p build/.linkparts build/.linkbin

xargs -a build/.linkcorpus.lst -d '
' -P "$JOBS" -I{} sh -c '
    key=$(printf %s "$1" | tr -c "A-Za-z0-9._-" "_")
    exe=build/.linkbin/$key.exe
    raw=build/.linkparts/$key.raw
    timeout 180 ./bin/tiko.exe '"$FBCUNIT"' "$1" -o "$exe" > "$raw" 2>&1 || true
    # A FILE THAT DID NOT COMPILE IS NOT A LINK FINDING. icescan owns those, and a
    # frontend diagnostic owns the ones above it.
    if grep -qiE "ICE:|clang: error: linker command|internal compiler" "$raw" ; then
        : # fall through -- the linker line is the interesting half, see below
    fi
    # A FRONTEND error, that is -- not the ids of the toolchain. A failed link is
    # TKO0116 now, and it is exactly what this scan is for; TKO0993 (the emission
    # ICE, once "emit: ICE:") belongs to icescan and is skipped just below.
    if grep -E "error TKO" "$raw" | grep -qvE "error TKO(0993|011[1-6])" ; then
        : > "build/.linkparts/$key"
        rm -f "$raw" "$exe"
        exit 0
    fi
    if grep -qE "error TKO0993" "$raw" ; then
        : > "build/.linkparts/$key"
        rm -f "$raw" "$exe"
        exit 0
    fi
    # A HALF OF A PAIR HAS NO ENTRY POINT and is not expected to link alone. lld says so
    # in one distinctive way, and it is tagged rather than counted.
    if grep -qE "subsystem must be defined" "$raw" ; then
        echo "nomain $1: no entry point" > "build/.linkparts/$key"
        rm -f "$raw" "$exe"
        exit 0
    fi
    if grep -qE "TEST_MODE *: *COMPILE_(ONLY|AND_RUN)_FAIL" "$1" ; then
        tag=neg
    else
        tag=ok
    fi
    # NOT THE clang SUMMARY LINE. "linker command failed with exit code 1" accompanies
    # every real lld error and says nothing on its own; counting it doubled the total
    # and put a meaningless message at the top of the census.
    grep -iE "lld[^:]*: error|ld\.lld: error" "$raw" \
        | sed "s|^|$tag $1: |" > "build/.linkparts/$key" || true
    rm -f "$raw" "$exe"
' _ {}

want=$(wc -l < build/.linkcorpus.lst)
got=$(ls build/.linkparts | wc -l)
if [ "$got" -ne "$want" ]; then
    echo "linkscan: INCOMPLETE -- $got parts for $want files; the totals below are wrong" >&2
    exit 4
fi

cat build/.linkparts/* > build/.link.out 2>/dev/null || true
rm -rf build/.linkbin 2>/dev/null || true

nomain=$(grep -c '^nomain ' build/.link.out || true)
grep -v '^nomain ' build/.link.out > build/.link.real 2>/dev/null || true
total=$(wc -l < build/.link.real)
files=$(cut -d' ' -f2 build/.link.real | sort -u | wc -l)
neg=$(grep -c '^neg ' build/.link.real || true)
echo "linkscan: $want files, $total link failures in $files files"
echo "linkscan: $neg of them are in files fbc REJECTS too; $nomain files have no entry point"
echo "linkscan: --- by message ---"
cut -d' ' -f3- build/.link.real \
    | sed -E "s/[0-9]+/N/g" \
    | sort | uniq -c | sort -rn | head -15 | sed 's/^/linkscan:  /'
# UNDEFINED USER SYMBOL vs UNDEFINED RUNTIME SYMBOL, and the difference decides
# whether it is a finding at all.
#
# fbc's suite compiles the WHOLE corpus to objects and links ONE fbc-tests.exe
# (unit-tests.mk), so a file may legitimately reference a symbol defined in a
# SIBLING module -- uzstring-fixed.bas is the implementation half of
# udt-zstring-fixed.bas, and every UZSTRING_FIXED error below is that pair, not a
# tiko fault. This scan links each file ALONE and cannot tell the two apart by
# linking; the NAME is what tells them apart.
#
# fb_*, __*, _* and the crt spellings are the RUNTIME's, and one of those
# undefined IS a finding: it is a symbol tiko emitted a call to and tiko-rt does
# not define.
rt=$(grep -h "undefined symbol" build/.link.real      | sed -E "s/.*undefined symbol: //"      | grep -cE "^(fb_|_|__)" || true)
usr=$(grep -hc "undefined symbol" build/.link.real || true)
usr=$((usr - rt))
echo "linkscan: of the undefined symbols, $rt are RUNTIME names and $usr are USER names"
echo "linkscan: a USER name is usually the other half of a pair -- fbc links the whole"
echo "linkscan: corpus into one binary, and this scan links each file alone"
echo "linkscan: --- the files fbc ACCEPTS, worst first ---"
grep '^ok ' build/.link.real | cut -d' ' -f2 | sort | uniq -c | sort -rn | head -20 | sed 's/^/linkscan:  /'
