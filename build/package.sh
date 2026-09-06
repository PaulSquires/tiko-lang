#!/bin/sh
# package.sh -- assemble a distributable tiko toolchain under toolchains/.
#
#   build/package.sh [options]
#
#   build/package.sh                        Release, the current host, everything
#   build/package.sh --config Debug         a debug toolchain, for chasing a bug
#   build/package.sh --no-build             package what is already built
#   build/package.sh --no-inc               skip the ~100 MB header copy
#   build/package.sh --clean                empty the output directory first
#   build/package.sh --verify               compile and RUN a program per target
#   build/package.sh --fbc-tree DIR         the reference fbc install (or FBC_TREE)
#   build/package.sh --out DIR              somewhere other than toolchains/
#
# The output is toolchains/tiko-windows or toolchains/tiko-linux: what an end user
# unpacks, as opposed to bin/tiko, which is what build/build.sh produces for
# developing the compiler.
#
# ---------------------------------------------------------------- what it is NOT
#
# THIS DOES NOT PRODUCE A SELF-CONTAINED TOOLCHAIN, and the manifest it writes says
# so. Two things stay external:
#
#   clang    src/codegen/toolchain.bas runs clang for BOTH steps -- the .ll to .o
#            compile and the link. It is found at C:\Program Files\LLVM\bin, or
#            wherever TKO_CLANG points. Bundling LLVM is a gigabyte and a separate
#            decision, so a packaged toolchain depends on an installed one.
#
#   libfb    tiko-rt is PARTIAL. Its thread layer references fb_AtomicCasLong,
#            which only fbc's libfb defines, so a link needs both archives named
#            in order -- see LinkExe: a single -l resolves once, from the first
#            path that has the archive, which is why each library path's libfb.a
#            is named as a file. Hence two directories per target, and hence fbc's
#            runtime is redistributed alongside ours.
#
# Neither is a packaging bug. Both are written into MANIFEST.txt so that a
# toolchain cannot be passed on with them invisible.
#
# --------------------------------------------------------------- cross-packaging
#
# A host packages ITSELF. build/build.sh compiles the compiler for the machine it
# runs on, so tiko-linux comes from running this under Linux or WSL and
# tiko-windows from running it on Windows. There is no --host flag: it would only
# ever produce a tree with a foreign binary in it.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)

CFG=Release
DO_BUILD=1
DO_INC=1
DO_CLEAN=0
DO_VERIFY=0
FBC_TREE=${FBC_TREE:-/c/dev/fbc-modern}
OUT=

die( ) { echo "package: $*" >&2; exit 1; }
note( ) { echo "package: $*"; }

usage( ) {
    sed -n '2,45p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

while [ $# -gt 0 ]; do
    case $1 in
        --config)    CFG=$2;      shift 2 ;;
        --fbc-tree)  FBC_TREE=$2; shift 2 ;;
        --out)       OUT=$2;      shift 2 ;;
        --no-build)  DO_BUILD=0;  shift ;;
        --no-inc)    DO_INC=0;    shift ;;
        --clean)     DO_CLEAN=1;  shift ;;
        --verify)    DO_VERIFY=1; shift ;;
        -h|--help)   usage ;;
        *)           die "unknown option '$1' (try --help)" ;;
    esac
done

case $CFG in
    Debug|Release|RelWithDebInfo) ;;
    *) die "unknown configuration '$CFG' (Debug|Release|RelWithDebInfo)" ;;
esac

# ------------------------------------------------------------------- the host
#
# The target list is the host's rather than a choice.
#
# WIN32 IS GONE, and it took packaging with it. D14 made x86-64 the only
# architecture -- -m32 is now an error and TargetFromName knows no "win32" -- so
# lib/rt/build/common.sh dropped it from RT_TARGETS, and the guard below then
# died with "no runtime for win32" on every single run. Nothing could be
# packaged on Windows at all, which is also why no libtkogfx ever reached a
# toolchain: the script never got as far as copying one.
#
# WIN64-MSVC IS SHIPPED, for three reasons and not as a spare. It is a real
# -target; it is the only target lib/gfx builds, so leaving it out means
# shipping no graphics at all; and it is the ONE target that links with nothing
# but our own archives behind it. That last is measured, 2026-09-06: a program
# built -target win64-msvc against lib/win64-msvc alone -- no fbc directory,
# none to have -- linked and ran. tiko-rt's MSVC archive carries no MinGW
# imports (build/abidelta.sh, and gatemsvc.sh at 3,922,073 assertions), which is
# what makes that possible where win64 still needs fbc's libfb behind it.

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        HOST=windows; EXT=".exe"; BINSUB=""
        TARGETS="win64 win64-msvc"
        FBTC="$FBC_TREE/toolchains/fbc-modern-windows"
        ;;
    Linux)
        HOST=linux; EXT=""; BINSUB="bin/"
        TARGETS="linux-x86_64"
        FBTC="$FBC_TREE/toolchains/fbc-modern-linux"
        ;;
    *)  die "unsupported host '$(uname -s)' -- this packages Windows or Linux" ;;
esac

# WHICH TARGETS HAVE A GRAPHICS LIBRARY. win64-msvc alone, and lib/gfx/build
# says why: tiko emits the Microsoft ABI for it and there is no MSVC libfbgfx
# anywhere to fall back on, so that is the target the library was written for.
# Kept as a list rather than a test so that the day a second one appears, this
# is the line that changes.
GFX_TARGETS="win64-msvc"

gfx_has_target( ) {
    for __g in $GFX_TARGETS; do [ "$1" = "$__g" ] && return 0; done
    return 1
}

[ -n "$OUT" ] || OUT="$ROOT/toolchains/tiko-$HOST"

note "host $HOST, configuration $CFG"
note "output $OUT"

# ------------------------------------------------------------------- the parts
#
# Everything is built BEFORE anything is copied, so a build failure leaves the
# previous toolchain intact rather than half-replaced.

if [ "$DO_BUILD" = "1" ]; then
    note "building the compiler [$CFG]"
    sh "$ROOT/build/build.sh" "$CFG" >/dev/null

    for t in $TARGETS; do
        note "building the runtime [$CFG $t]"
        sh "$ROOT/lib/rt/build/build.sh" "$CFG" "$t" >/dev/null
    done

    # THE GRAPHICS LIBRARY IS BUILT, NOT SCAVENGED. It used to be neither: the
    # copy below looked for an archive nobody here had built, so whether a
    # toolchain shipped graphics came down to whether someone had happened to
    # run lib/gfx/build/build.sh by hand first, and to which configuration.
    #
    # A FAILURE HERE IS NOTED, NOT FATAL, and that is deliberate. lib/gfx needs a
    # working-tree fbc ($FBC_TREE/src/fbc.exe) that understands -z msvc, which is
    # a heavier dependency than anything else in this script -- the packaged
    # toolchain fbc will not do. Aborting the whole package because the graphics
    # library could not build would take the compiler and runtime down with it.
    # The manifest records the reason instead, so the absence is never silent.
    for t in $TARGETS; do
        gfx_has_target "$t" || continue
        note "building the graphics library [$CFG $t]"
        if ! sh "$ROOT/lib/gfx/build/build.sh" "$CFG" "$t" >"$ROOT/lib/gfx/obj/package.log" 2>&1; then
            GFX_FAIL=$( grep -m1 -iE 'error|die|no ' "$ROOT/lib/gfx/obj/package.log" | cut -c1-120 )
            [ -n "$GFX_FAIL" ] || GFX_FAIL="see lib/gfx/obj/package.log"
            note "WARNING: graphics build failed for $t -- $GFX_FAIL"
        fi
    done
else
    note "--no-build: packaging what is already built"
fi

TIKO="$ROOT/bin/tiko$EXT"
[ -f "$TIKO" ] || die "no compiler at $TIKO -- run build/build.sh $CFG"

for t in $TARGETS; do
    [ -f "$ROOT/lib/rt/lib/$t/libfb.a" ] || \
        die "no runtime for $t -- run lib/rt/build/build.sh $CFG $t"
done

[ -d "$FBTC" ] || die "no reference fbc toolchain at $FBTC -- set FBC_TREE or --fbc-tree"

# ----------------------------------------------------------------- the assembly

if [ "$DO_CLEAN" = "1" ] && [ -d "$OUT" ]; then
    note "cleaning $OUT"
    # Everything but the README, which is tracked and describes the layout.
    find "$OUT" -mindepth 1 -maxdepth 1 ! -name README.md -exec rm -rf {} +
fi

mkdir -p "$OUT"
[ -z "$BINSUB" ] || mkdir -p "$OUT/$BINSUB"

note "compiler -> ${BINSUB}tiko$EXT"
cp -f "$TIKO" "$OUT/${BINSUB}tiko$EXT"

# The headers. The compiler finds these itself: AppendDefaultIncludeDir looks at
# <exe-dir>/inc and then <exe-dir>/../inc, which is exactly why the Windows binary
# sits at the root and the Linux one under bin/ -- both resolve to ./inc.
#
# Taken whole from the reference fbc toolchain, because tiko ships no headers of
# its own yet: the fb/*.bi set, the platform bindings, and the third-party ones
# that make an include like "vbcompat.bi" resolve the way it does under fbc.
if [ "$DO_INC" = "1" ]; then
    if [ -d "$FBTC/inc" ]; then
        note "headers -> inc/  (large; --no-inc skips it)"
        rm -rf "$OUT/inc"
        cp -r "$FBTC/inc" "$OUT/inc"
    else
        note "WARNING: no headers at $FBTC/inc -- inc/ not packaged"
    fi
    if [ -d "$FBTC/include" ]; then
        rm -rf "$OUT/include"
        cp -r "$FBTC/include" "$OUT/include"
    fi
else
    note "--no-inc: headers not packaged"
fi

# The libraries. TWO directories per target, and the order they are given in
# matters:
#
#   lib/<target>/      ours   -- tiko-rt's libfb.a and libfbmt.a
#   lib/<target>-fb/   fbc's  -- its libfb.a, the CRT objects, the import libraries
#
# A link names both, ours first, so what tiko-rt defines wins and what it does not
# yet define still resolves. -B points at each of them too, and it is fbc's
# directory that carries crt2.o, crtbegin.o and crtend.o -- which have to come
# from the same toolchain as libfb, because fbc's are SJLJ and the MinGW clang
# finds on its own is SEH.
# STALE TARGET DIRECTORIES ARE REMOVED FIRST, and this is not housekeeping.
# Packaging into an existing tree only ever replaced the directories it was about
# to write, so lib/win32 and lib/win32-fb from an older run would sit there
# afterwards -- 60 MB of libraries for a target that no longer exists, counted in
# the manifest's file total, and looking exactly like something meant to be used.
# A stale archive does not announce itself; it links, and answers plausibly.
#
# Only lib/ is swept, and only entries that do not belong to a current target,
# so this cannot touch inc/, licences/ or the compiler.
if [ -d "$OUT/lib" ]; then
    for d in "$OUT"/lib/*; do
        [ -d "$d" ] || continue
        _keep=0
        for t in $TARGETS; do
            case ${d##*/} in "$t"|"$t-fb") _keep=1 ;; esac
        done
        if [ "$_keep" = "0" ]; then
            note "removing stale lib/${d##*/} -- not a target of this toolchain"
            rm -rf "$d"
        fi
    done
fi

GFX_STATE=""

for t in $TARGETS; do
    note "runtime -> lib/$t/  (tiko-rt)"
    rm -rf "$OUT/lib/$t"
    mkdir -p "$OUT/lib/$t"
    cp -f "$ROOT/lib/rt/lib/$t/libfb.a"   "$OUT/lib/$t/"
    cp -f "$ROOT/lib/rt/lib/$t/libfbmt.a" "$OUT/lib/$t/"

    # THE GRAPHICS LIBRARY GOES BESIDE THE RUNTIME, in lib/<target>/ and not a
    # directory of its own, because that is where the compiler looks: since
    # 2026-09-06 it appends <exe-dir>/lib/<target> to its own library search, and
    # LinkExe names each search path's libtkogfx.a the same way it names libfb.a.
    # A separate lib/gfx/ in the package would need a -p nobody would know to pass.
    #
    # THE CONFIGURATION IS CHECKED, not assumed. lib/gfx writes .config beside the
    # archive precisely so a Release toolchain cannot quietly ship a Debug library:
    # a stale archive does not error, it links and yields a plausible wrong answer.
    _gfx="$ROOT/lib/gfx/lib/$t/libtkogfx.a"
    if [ -f "$_gfx" ]; then
        _gcfg=$( cat "$ROOT/lib/gfx/lib/$t/.config" 2>/dev/null || echo unknown )
        cp -f "$_gfx" "$OUT/lib/$t/"
        if [ "$_gcfg" = "$CFG" ]; then
            note "graphics -> lib/$t/libtkogfx.a  ($_gcfg)"
            GFX_STATE="$GFX_STATE
  $t  packaged, $_gcfg"
        else
            note "WARNING: graphics archive for $t is $_gcfg, not $CFG -- packaged anyway"
            GFX_STATE="$GFX_STATE
  $t  packaged, but built $_gcfg where this toolchain is $CFG"
        fi
    elif gfx_has_target "$t"; then
        note "WARNING: no graphics archive for $t -- the build above did not produce one"
        GFX_STATE="$GFX_STATE
  $t  MISSING -- lib/gfx builds for this target and produced nothing"
    else
        note "graphics: none for $t -- lib/gfx builds $GFX_TARGETS only"
        GFX_STATE="$GFX_STATE
  $t  none -- lib/gfx builds $GFX_TARGETS only"
    fi

    # fbc's runtime behind ours. NOT NEEDED BY EVERY TARGET, and win64-msvc is the
    # one that does without: fbc has no MSVC target, so $FBTC/lib/win64-msvc does
    # not exist and cannot -- and measurement says it is not wanted either, since a
    # program linked against lib/win64-msvc alone runs. Reporting that as the old
    # "links will not resolve" warning would be crying wolf on the one target where
    # the absence is correct.
    if [ -d "$FBTC/lib/$t" ]; then
        note "reference runtime -> lib/$t-fb/  (fbc's libfb, CRT, import libraries)"
        rm -rf "$OUT/lib/$t-fb"
        cp -r "$FBTC/lib/$t" "$OUT/lib/$t-fb"
    elif [ "$t" = "win64-msvc" ]; then
        note "no lib/$t-fb: fbc has no MSVC target, and this one links without it"
    else
        note "WARNING: no reference libraries at $FBTC/lib/$t -- links will not resolve"
    fi
done

# ----------------------------------------------------------------- the notices
#
# lib/rt is LGPL-2.1-or-later and a derivative of libfb; lib/gfx is
# LGPL-2.1-or-later with the static-linking exception and a derivative of gfxlib2;
# and this tree redistributes fbc's own binaries. docs/plan/11 records that as
# permitted and carrying obligations rather than prohibitions -- so the notices
# ship with the toolchain instead of being something to remember at release time.
mkdir -p "$OUT/licences"
cp -f "$ROOT/lib/rt/LICENSE"       "$OUT/licences/LICENSE-tiko-rt"
cp -f "$ROOT/lib/rt/PROVENANCE.md" "$OUT/licences/PROVENANCE-tiko-rt.md"
for f in COPYING.LGPL-2.1 COPYING.GPL-2.0 LICENSE; do
    if [ -f "$FBC_TREE/$f" ]; then
        cp -f "$FBC_TREE/$f" "$OUT/licences/$f.freebasic"
        FBLIC=1
    fi
done
# Shipping fbc's binaries without fbc's licence text is the one failure here that
# would matter legally, and it is exactly the kind that a silent 'for' loop over
# names that have changed produces. Say it.
if [ -z "${FBLIC:-}" ]; then
    note "WARNING: no FreeBASIC licence text found in $FBC_TREE -- licences/ is incomplete"
fi

# --------------------------------------------------------------- verification
#
# A toolchain that assembles is not a toolchain that works, and the difference is
# invisible: every file is present, every size is plausible, and the first thing
# that fails is a user's link. So --verify compiles and RUNS a program with the
# tree as packaged, per target, and the result goes into the manifest as a
# measurement rather than a claim.
#
# Run from $OUT with the same relative -p paths the manifest tells a user to use,
# so what is verified is the documented invocation and not some other one.

VERIFY_LINES=""

verify_target( ) {
    _t=$1
    _tmp="$OUT/.verify.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf 'print "ok"
' > "$_tmp/hello.bas"

    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t"             ".verify.$_t/hello.bas" -o ".verify.$_t/hello$EXT" ) >"$_tmp/log" 2>&1 || true

    # THE EXIT CODE IS NOT THE TEST. Measured 2026-09-04: tiko returns 0 when the
    # link fails and writes no executable, so trusting it reported a win32 link
    # failure as 'built but did not run'. The artifact existing is the test.
    if [ -f "$_tmp/hello$EXT" ]; then
        if [ "$( "$_tmp/hello$EXT" 2>/dev/null )" = "ok" ]; then
            VERIFY_LINES="$VERIFY_LINES
  $_t  PASS -- compiled, linked and ran"
        else
            VERIFY_LINES="$VERIFY_LINES
  $_t  FAIL -- built, but the program did not run correctly"
        fi
    else
        # The first linker line is the useful one; the rest are the same fact
        # repeated once per undefined symbol.
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="see the build log"
        VERIFY_LINES="$VERIFY_LINES
  $_t  FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

if [ "$DO_VERIFY" = "1" ]; then
    for t in $TARGETS; do
        note "verifying $t: compile, link and run"
        verify_target "$t"
    done
else
    VERIFY_LINES="
  not run -- pass --verify to compile and run a program per target"
fi

# ---------------------------------------------------------------- the manifest
#
# A packaged toolchain is a pile of copied binaries with nothing in it that says
# WHICH ones. A stale archive does not error -- it links, and yields a plausible
# wrong answer. So every part records where it came from and at what commit, and
# a dirty tree is marked as such.

REV=$( cd "$ROOT" && git rev-parse --short HEAD 2>/dev/null || echo unknown )
if [ -n "$( cd "$ROOT" && git status --porcelain 2>/dev/null | head -1 )" ]; then
    REV="$REV+dirty"
fi

NFILES=$( cd "$OUT" && find . -type f ! -name MANIFEST.txt | wc -l )
SIZE=$( du -sh "$OUT" | cut -f1 )

{
    echo "tiko toolchain -- $HOST"
    echo
    echo "packaged       $(date -u '+%Y-%m-%d %H:%M:%SZ')"
    echo "from           $ROOT"
    echo "commit         $REV"
    echo "configuration  $CFG"
    echo "targets        $TARGETS"
    echo "reference fbc  $FBTC"
    echo "contents       $NFILES files, $SIZE"
    echo
    echo "-- what is NOT in here -------------------------------------------------"
    echo "clang       REQUIRED, not bundled. The compiler runs it for both the"
    echo "            .ll -> .o step and the link. Install LLVM, and point at it"
    echo "            by setting TKO_CLANG if it is not at the default"
    echo "            C:\\Program Files\\LLVM\\bin\\clang.exe."
    echo
    echo "-- libraries, per target -----------------------------------------------"
    echo "lib/<target>/     tiko-rt: libfb.a and libfbmt.a, plus libtkogfx.a"
    echo "                  where there is one -- the compiler looks for all"
    echo "                  three in the same directory."
    echo "lib/<target>-fb/  fbc's runtime, the CRT objects and the import"
    echo "                  libraries, behind ours. Absent for win64-msvc:"
    echo "                  fbc has no MSVC target and that one links without."
    echo
    echo "graphics:$GFX_STATE"
    echo
    echo "-- verification --------------------------------------------------------"
    echo "Each target below was checked by compiling AND RUNNING a program with"
    echo "this tree, using exactly the invocation shown under 'linking'."
    echo "$VERIFY_LINES"
    echo
    echo "-- linking -------------------------------------------------------------"
    echo "Nothing has to be passed. tiko appends inc/ to the include search and"
    echo "lib/<target>/ then lib/<target>-fb/ to the library search on its own,"
    echo "all relative to the executable, as fbc does with inc/ and lib/<target>."
    echo
    echo "The -fb half has no fbc counterpart and is ours: tiko-rt is partial on"
    echo "win64, its thread layer references fb_AtomicCasLong, and only fbc's"
    echo "libfb defines that. OURS COMES FIRST -- a single -l resolves once, from"
    echo "the first path holding the archive -- and that order is fixed in the"
    echo "compiler, not left to the caller. win64-msvc needs no second directory"
    echo "at all; it was measured linking against ours alone."
    echo
    for t in $TARGETS; do
        echo "  tiko -target $t yourprogram.bas"
    done
    echo
    echo "A -p of your own is searched BEFORE both, so it can override either."
    echo "TKO_LIBPATH replaces them instead, as TKO_INCLUDE replaces inc/."
    echo
    echo "-- licences ------------------------------------------------------------"
    echo "licences/ holds the runtime's LGPL-2.1 notice and its provenance, and"
    echo "FreeBASIC's own. This tree redistributes binaries built from LGPL"
    echo "sources; distributing it carries the source-offer obligation."
} > "$OUT/MANIFEST.txt"

note "manifest -> MANIFEST.txt"
note "ok -- $NFILES files, $SIZE"
