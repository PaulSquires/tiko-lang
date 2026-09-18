#!/bin/sh
# build.sh -- build libtkogfx.
#
#   build/build.sh [Debug|Release|RelWithDebInfo] [target ...]
#
# WIN64-MSVC IS THE ONLY TARGET, and that is the point rather than a limitation.
# tiko emits the Microsoft ABI on Windows (TARGET_WIN64_MSVC, added 2026-09-05)
# and there is no MSVC libfbgfx anywhere to fall back to: fbc's is MinGW, so it
# cannot go into an MSVC binary at all. That absence is why build/gatemsvc.sh in
# lib/rt excludes gfx/ and fbc-int/gfx, and why 22 of the 26 unresolved symbols
# in its first full link were fb_Gfx*.
#
# THE LIBRARY IS HEADER-ONLY, so this is ONE translation unit. Every .bi under
# abi/, core/, driver/ and raster/ is included by src/all.bas, and every routine
# in them is `private`. That is deliberate -- RFC-0001 makes the entry-point
# layer the only public surface -- and it means the archive this produces today
# exports NOTHING. It compiles 7,781 lines into 108 functions and proves the
# tree builds for the Microsoft ABI; it does not yet make a graphics program
# link. See "WHAT IS NOT HERE" below.
#
# THE COMPILER MUST UNDERSTAND -z msvc. The prebuilt toolchain fbc does not --
# the switch landed in fbc-modern on 2026-09-05 -- so this refuses rather than
# falling back, because falling back emits the gnu triple and builds the wrong
# ABI without saying so.
#
# WHAT IS NOT HERE: the entry points. tiko's src/mir/rtl.bi names 32 of them
# with full signatures -- fb_GfxScreen( l, l, l, l, l ) as l and the rest -- and
# that table IS the ABI this library owes. None is implemented. An entry point
# that links and does nothing turns a loud failure into a silent one, so none is
# stubbed either.

set -e

GFX_ROOT=$(cd "$(dirname "$0")/.." && pwd)
FBC_TREE=${FBC_TREE:-/c/dev/fbc-modern}

die( ) { echo "libtkogfx: $*" >&2; exit 2; }

CFG=${1:-Release}
case "$CFG" in
    Debug|Release|RelWithDebInfo|MinSizeRel) ;;
    *) die "unknown configuration '$CFG' (Debug, Release, RelWithDebInfo, MinSizeRel)" ;;
esac
shift 2>/dev/null || true
TARGETS=${*:-win64-msvc}

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) ;;
    *) die "win64 host only -- the Microsoft ABI is not reachable from here" ;;
esac

FBC=${TKOGFX_FBC:-$FBC_TREE/src/fbc.exe}
[ -x "$FBC" ] || die "no fbc at $FBC (set TKOGFX_FBC)"
CLANG=${CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}
[ -x "$CLANG" ] || die "no clang at $CLANG (set CLANG)"
AR=${TKOGFX_AR:-"C:/Program Files/LLVM/bin/llvm-ar.exe"}
[ -x "$AR" ] || die "no llvm-ar at $AR (set TKOGFX_AR)"

# -z msvc, or nothing. Probed rather than assumed.
mkdir -p "$GFX_ROOT/obj"
printf 'end 0\n' > "$GFX_ROOT/obj/.zprobe.bas"
if "$FBC" -c -gen llvm -z msvc -m zprobe "$GFX_ROOT/obj/.zprobe.bas" -o "$GFX_ROOT/obj/.zprobe.o" 2>&1 | grep -q 'Invalid command-line option'; then
    die "$FBC does not understand -z msvc -- build fbc-modern from source (2026-09-05 or later)"
fi
rm -f "$GFX_ROOT/obj/.zprobe.bas" "$GFX_ROOT/obj/.zprobe.o" "$GFX_ROOT/obj/zprobe.ll"

case "$CFG" in
    Debug)          OPT=0 ;;
    Release)        OPT=2 ;;
    RelWithDebInfo) OPT=2 ;;
    # clang's own '-Os', which it honours -- this script calls clang directly.
    MinSizeRel)     OPT=s ;;
esac

for target in $TARGETS; do
    [ "$target" = "win64-msvc" ] || die "unsupported target '$target' (win64-msvc)"

    OBJDIR="$GFX_ROOT/obj/$target/$CFG"
    LIBDIR="$GFX_ROOT/lib/$target"
    rm -rf "$OBJDIR"; mkdir -p "$OBJDIR" "$LIBDIR"

    # The archive goes FIRST, so a failed build cannot leave a stale one behind
    # for the next tool to read as a complete library. lib/rt's build.sh records
    # five separate incidents of exactly that.
    rm -f "$LIBDIR/libtkogfx.a" "$LIBDIR/.config"

    # -m NAMES THE MAIN MODULE, AND all.bas MUST NOT BE IT. Compiled as the main
    # module fbc emits a `main` into it, and the archive then collides with every
    # program that links it:
    #
    #     libtkogfx.a(all.o) : error LNK2005: main already defined
    #
    # Naming a module that does not exist in this build makes every module here a
    # NON-main one, which is what a library wants -- the same device fbc's own
    # suite uses when it passes -m fbc-tests to every test module.
    ( cd "$OBJDIR" && "$FBC" -c "$GFX_ROOT/src/all.bas" -m __tkogfx_lib \
        -target win64 -gen llvm -r -z msvc -mt \
        -o "$OBJDIR/all.o" ) > "$OBJDIR/fbc.log" 2>&1 \
        || { sed 's/^/    /' "$OBJDIR/fbc.log" >&2; die "fbc failed -- see $OBJDIR/fbc.log"; }
    [ -f "$OBJDIR/all.ll" ] || die "fbc produced no .ll -- see $OBJDIR/fbc.log"

    "$CLANG" --target=x86_64-pc-windows-msvc -march=x86-64 "-O$OPT" \
        -Wno-override-module "$OBJDIR/all.ll" -c -o "$OBJDIR/all.o" \
        > "$OBJDIR/clang.log" 2>&1 \
        || { sed 's/^/    /' "$OBJDIR/clang.log" >&2; die "clang failed -- see $OBJDIR/clang.log"; }

    "$AR" rcs "$LIBDIR/libtkogfx.a" "$OBJDIR/all.o"

    # The configuration, beside the archive. lib/<target>/ holds ONE archive that
    # every configuration overwrites, so without this a tool told "Release" reads
    # whatever was built last and agrees with itself.
    echo "$CFG" > "$LIBDIR/.config"

    # REPORT WHAT IS IN THE ARCHIVE, NOT WHAT WAS IN THE IR.
    #
    # The .ll carries 108 functions and the archive carries NONE of them: every
    # routine in this library is `private`, nothing public references them, and
    # clang discards the lot. That is the structure working as designed -- the
    # entry-point layer is the only thing that can pull the internals in -- but a
    # build line reporting the IR count would say "108 functions" about an
    # archive containing two symbols and no code.
    ir=$(grep -c "^define" "$OBJDIR/all.ll" || echo 0)
    code=$(llvm-nm --defined-only "$LIBDIR/libtkogfx.a" 2>/dev/null | grep -c " T \| t " || true)
    pub=$(llvm-nm --defined-only "$LIBDIR/libtkogfx.a" 2>/dev/null | awk '$2=="T"{print $3}' | grep -cE "^fb_(Gfx|h)" || true)
    echo "build: $target/libtkogfx.a [$CFG] -- $ir functions compiled, $code reached the archive, $pub public entry points"
    if [ "$pub" = "0" ]; then
        echo "build: NOTE -- no entry points exist yet, so the archive holds no code." >&2
        echo "build:         tiko src/mir/rtl.bi names the 32 this library owes." >&2
    fi
done
echo "build: ok"
