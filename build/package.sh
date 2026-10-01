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
#   build/package.sh --implibs              regenerate the MSVC import libraries (*.lib)
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
#   fbc's    lib/<target>-fb/ still carries fbc's CRT objects, libfbgfx and the
#   CRT      third-party archives (MinGW, gcc's runtime, libffi) behind ours. It no
#            longer carries fbc's libfb: decision 0015 (D15) retired it, and
#            tiko-rt defines every symbol a tiko-built program reaches -- see
#            lib/rt/src/c/README.md. LinkExe names each path's libfb.a as a file
#            only when it is there, so the directory needs nothing in its place.
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
DO_IMPLIBS=0
T0=$(date +%s)
FBC_TREE=${FBC_TREE:-/c/dev/fbc-modern}
OUT=

die( ) { echo "package: $*" >&2; exit 1; }
note( ) { echo "package: [$(( $(date +%s) - T0 ))s] $*"; }
# THE MANIFEST IS WRITTEN WITH printf, NOT echo. dash -- Linux's /bin/sh -- expands
# backslash escapes in echo's arguments, so the Windows clang path came out as
# 'C:\Program Files\LLVMin': its '\b' was a backspace. Git Bash's sh does not, which
# is why the Windows manifest never showed it.
say( ) { printf '%s\n' "$*"; }

usage( ) {
    sed -n '2,46p' "$0" | sed 's/^# \{0,1\}//'
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
        --implibs)   DO_IMPLIBS=1; shift ;;
        -h|--help)   usage ;;
        *)           die "unknown option '$1' (try --help)" ;;
    esac
done

case $CFG in
    Debug|Release|RelWithDebInfo|MinSizeRel) ;;
    *) die "unknown configuration '$CFG' (Debug|Release|RelWithDebInfo|MinSizeRel)" ;;
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
# WIN64-MSVC IS THE DEFAULT and is listed first. It is the only target lib/gfx
# builds, so it is the only one where a SCREEN program links; and it is the ONE
# target that needs nothing behind it. That is measured, 2026-09-06: a program
# built for win64-msvc against lib/win64-msvc alone -- no fbc directory, none to
# have -- linked and ran. tiko-rt's MSVC archive carries no MinGW imports
# (build/abidelta.sh, and gatemsvc.sh at 3,922,073 assertions). win64 needed fbc's
# libfb behind it until decision 0015 (D15); now it needs only fbc's CRT behind it.
#
# win64 is still shipped and still selected with -target win64. It is the MinGW
# ABI, it is what fbc's own libraries are built for, and it has no graphics.

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        HOST=windows; EXT=".exe"; BINSUB=""
        TARGETS="win64-msvc win64"
        # The compiler's own default on this host -- HostTarget( ), src/types/type.bas.
        DEFTARGET=win64-msvc
        FBTC="$FBC_TREE/toolchains/fbc-modern-windows"
        FBLIB="$FBTC/lib"
        CLANG_DEFAULT='C:\Program Files\LLVM\bin\clang.exe'
        ;;
    Linux)
        HOST=linux; EXT=""; BINSUB="bin/"
        TARGETS="linux-x86_64"
        DEFTARGET=linux-x86_64
        FBTC="$FBC_TREE/toolchains/fbc-modern-linux"
        # fbc's LINUX install nests its runtime one level deeper: lib/freebasic/<target>.
        FBLIB="$FBTC/lib/freebasic"
        # The compiler's own default on Linux -- see src/codegen/toolchain.bas.
        CLANG_DEFAULT=/usr/bin/clang
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
    # THE PARTS BUILD CONCURRENTLY. The compiler, each target's runtime and the
    # graphics library share nothing: the runtime and lib/gfx build with fbc, not with
    # bin/tiko, and each writes its own obj/<target>/<config> tree. Run one after
    # another they were most of a Windows package's wall-clock time.
    mkdir -p "$ROOT/lib/rt/obj" "$ROOT/lib/gfx/obj"
    note "building the compiler [$CFG]"
    # --no-dll: the editor's tikoParser.dll ships with the editor, not in a toolchain.
    sh "$ROOT/build/build.sh" "$CFG" --no-dll >"$ROOT/lib/rt/obj/package-tiko.log" 2>&1 &
    _pid_tiko=$!
    _pids_rt=""
    for t in $TARGETS; do
        note "building the runtime [$CFG $t]"
        sh "$ROOT/lib/rt/build/build.sh" "$CFG" "$t" >"$ROOT/lib/rt/obj/package-$t.log" 2>&1 &
        _pids_rt="$_pids_rt $t:$!"
    done
    # The graphics library too -- see the note below on why its failure is not fatal.
    _pids_gfx=""
    for t in $TARGETS; do
        gfx_has_target "$t" || continue
        note "building the graphics library [$CFG $t]"
        sh "$ROOT/lib/gfx/build/build.sh" "$CFG" "$t" >"$ROOT/lib/gfx/obj/package-$t.log" 2>&1 &
        _pids_gfx="$_pids_gfx $t:$!"
    done
    if ! wait $_pid_tiko; then
        tail -20 "$ROOT/lib/rt/obj/package-tiko.log" >&2
        die "the compiler build failed -- lib/rt/obj/package-tiko.log"
    fi
    note "compiler built"
    for _tp in $_pids_rt; do
        if ! wait "${_tp#*:}"; then
            tail -20 "$ROOT/lib/rt/obj/package-${_tp%%:*}.log" >&2
            die "the runtime build failed for ${_tp%%:*} -- lib/rt/obj/package-${_tp%%:*}.log"
        fi
        note "runtime built [${_tp%%:*}]"
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
    # obj/ IS GITIGNORED, so a fresh clone or worktree has none -- the mkdir above makes
    # it, or the redirect failed before build.sh ran, reporting a build failure that never
    # happened and packaging whatever stale archive was lying about.
    for _tp in $_pids_gfx; do
        _gl="$ROOT/lib/gfx/obj/package-${_tp%%:*}.log"
        if wait "${_tp#*:}"; then
            note "graphics library built [${_tp%%:*}]"
        else
            GFX_FAIL=$( grep -m1 -iE 'error|die|no ' "$_gl" | cut -c1-120 )
            [ -n "$GFX_FAIL" ] || GFX_FAIL="see lib/gfx/obj/package-${_tp%%:*}.log"
            note "WARNING: graphics build failed for ${_tp%%:*} -- $GFX_FAIL"
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

# What the last package said of its import libraries, for when they are kept below.
_IMPLIB_PREV=$( sed -n 's/^import libraries: //p' "$OUT/MANIFEST.txt" 2>/dev/null | sed 's/ (kept.*//' | head -1 )

if [ "$DO_CLEAN" = "1" ] && [ -d "$OUT" ]; then
    note "cleaning $OUT"
    # Everything: the per-host toolchain directories hold build products only, and no
    # README is kept or written there.
    find "$OUT" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
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
#
# WHERE THEY ARE IS PER HOST, and the Linux one is a trap: fbc-modern-windows keeps
# its headers in inc/, while fbc-modern-linux keeps them in include/freebasic and its
# inc/ is an EMPTY DIRECTORY. The test here was '[ -d "$FBTC/inc" ]', which that empty
# directory passes -- so the copy ran, copied nothing, and tiko-linux shipped with an
# empty inc/. Every '#include "containers.bi"' was TKO0301 and --verify still said
# PASS, because its program includes no bundled header. Both halves are fixed: the
# source is whichever of the two actually HAS headers, and the check below refuses to
# package an empty one.
if [ "$DO_INC" = "1" ]; then
    SRCINC=""
    if [ -d "$FBTC/inc" ] && [ -n "$( ls -A "$FBTC/inc" 2>/dev/null )" ]; then
        SRCINC="$FBTC/inc"
    elif [ -d "$FBTC/include/freebasic" ]; then
        SRCINC="$FBTC/include/freebasic"
    fi
    if [ -n "$SRCINC" ]; then
        note "headers -> inc/  from $SRCINC  (large; --no-inc skips it)"
        rm -rf "$OUT/inc"
        cp -r "$SRCINC" "$OUT/inc"
        if [ -z "$( ls -A "$OUT/inc" 2>/dev/null )" ]; then
            die "packaged inc/ is EMPTY -- the compiler would find no headers at all"
        fi
    else
        note "WARNING: no headers at $FBTC/inc or $FBTC/include/freebasic -- inc/ not packaged"
    fi
    if [ -d "$FBTC/include" ]; then
        rm -rf "$OUT/include"
        cp -r "$FBTC/include" "$OUT/include"
    fi
    # fbx IS A PACKAGE NOW (ADR 0017 §20): pkg/fbx is its only copy, so the header library
    # the stage-0 toolchain carries is left out. Kept, it would also be the first package
    # named fbx that a '-i <inc>' root offers '#import "fbx/..."', ahead of the toolchain's.
    rm -rf "$OUT/inc/fbx" "$OUT/include/freebasic/fbx"
    if [ -e "$OUT/inc/fbx" ]; then die "packaged inc/ still has fbx/ -- it would shadow pkg/fbx"; fi
else
    note "--no-inc: headers not packaged"
fi

# THE PACKAGE TREE (ADR 0017; RFC-0007 §5): pkg/, beside inc/, which '#import "std/..."'
# finds as <exe-dir>/pkg or <exe-dir>/../pkg -- the two layouts the binaries sit in. The
# copy is ASSERTED: a pkg/ that silently failed to ship would look like a user's typo in
# an import path.
rm -rf "$OUT/pkg"
cp -r "$ROOT/pkg" "$OUT/pkg"
[ -f "$OUT/pkg/std/tiko.toml" ] || die "packaged pkg/ has no std/tiko.toml -- '#import \"std/...\"' would find nothing"
[ -f "$OUT/pkg/std/strings/strings.bas" ] || die "packaged pkg/ has no std/strings"
[ -f "$OUT/pkg/sys/windows/windows.bas" ] || die "packaged pkg/ has no sys/windows"
[ -f "$OUT/pkg/fbx/gui/CWindow.tiko" ] || die "packaged pkg/ has no fbx/gui"
note "packages -> pkg/ ($( ls "$OUT/pkg" | tr '\n' ' '))"

# The libraries. TWO directories per target, and the order they are given in
# matters:
#
#   lib/<target>/      ours   -- tiko-rt's libfb.a and libfbmt.a
#   lib/<target>-fb/   fbc's  -- the CRT objects, the import libraries; NOT its
#                                libfb, which is deleted after the copy (D15)
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
    # THE MSVC IMPORT LIBRARIES STAY, unless --implibs: they are generated from fbc's
    # MinGW libraries, which do not change between packages, so regenerating all 843 on
    # every run bought nothing. Everything else in the directory is replaced.
    if [ "$DO_IMPLIBS" = "0" ] && [ -d "$OUT/lib/$t" ]; then
        find "$OUT/lib/$t" -mindepth 1 -maxdepth 1 ! -name '*.lib' -exec rm -rf {} +
    else
        rm -rf "$OUT/lib/$t"
    fi
    mkdir -p "$OUT/lib/$t"
    cp -f "$ROOT/lib/rt/lib/$t/libfb.a"   "$OUT/lib/$t/"
    cp -f "$ROOT/lib/rt/lib/$t/libfbmt.a" "$OUT/lib/$t/"
    # THE PIC PAIR, where the runtime builds one (linux-x86_64): what a Linux '-dll'
    # links, as fbc's own '-lfbpic' does. lib/rt/build/build.sh says why.
    for _pic in libfbpic.a libfbmtpic.a; do
        [ -f "$ROOT/lib/rt/lib/$t/$_pic" ] && cp -f "$ROOT/lib/rt/lib/$t/$_pic" "$OUT/lib/$t/"
    done

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
    if [ -d "$FBLIB/$t" ]; then
        note "reference libraries -> lib/$t-fb/  (fbc's CRT, import libraries; not its libfb)"
        rm -rf "$OUT/lib/$t-fb"
        cp -r "$FBLIB/$t" "$OUT/lib/$t-fb"
        # fbc's RUNTIME IS NOT SHIPPED (decision 0015, D15). tiko-rt defines every
        # symbol it used to supply -- lib/rt/src/c/README.md has the list and what
        # replaced each -- and LinkExe names a path's libfb.a only when it exists,
        # so deleting these is the whole of the change. The -pic variants are the
        # same library; the compiler has never named them.
        for _rt in libfb.a libfbmt.a libfbpic.a libfbmtpic.a; do
            rm -f "$OUT/lib/$t-fb/$_rt"
        done
    elif [ "$t" = "win64-msvc" ]; then
        note "no lib/$t-fb: fbc has no MSVC target, and this one links without it"
    else
        note "WARNING: no reference libraries at $FBLIB/$t -- links will not resolve"
    fi
done

# THE MSVC IMPORT LIBRARIES, generated rather than copied -- there is nothing to
# copy. fbc's tree is MinGW and carries lib<name>.dll.a; the MSVC linker looks for
# <name>.lib and finds none of them.
#
# WITHOUT THESE THE DEFAULT TARGET DEPENDS ON VISUAL STUDIO. Measured 2026-09-06:
# clang's msvc driver passes -libpath for VS 2022 Community and Windows SDK
# 10.0.26100 out of its own knowledge of the machine, so win64-msvc linked here and
# would not link on a machine without them. A toolchain whose default target needs
# an unrelated install is not one that can be handed to anyone.
#
# NOT FATAL, on the same reasoning as the graphics build above: this needs
# llvm-dlltool, and losing the compiler and runtime because the import libraries
# could not be generated would be the wrong trade. The manifest records what
# happened either way.
IMPLIB_STATE="not generated"
_IMPLIB_N=$( ls "$OUT/lib/win64-msvc/"*.lib 2>/dev/null | wc -l | tr -d ' ' )
if [ "$HOST" = "windows" ] && [ "$DO_IMPLIBS" = "0" ] && [ "$_IMPLIB_N" -gt 0 ]; then
    IMPLIB_STATE="${_IMPLIB_PREV:-$_IMPLIB_N libraries} (kept; --implibs regenerates them)"
    note "msvc import libraries kept: $_IMPLIB_N in lib/win64-msvc/ (--implibs regenerates them)"
elif [ "$HOST" = "windows" ] && [ -d "$OUT/lib/win64-fb" ] && [ -d "$OUT/lib/win64-msvc" ]; then
    note "msvc import libraries -> lib/win64-msvc/  (generated from lib/win64-fb)"
    if IMPLIB_OUT=$( sh "$ROOT/build/mkmsvcimplibs.sh" "$OUT/lib/win64-fb" "$OUT/lib/win64-msvc" 2>&1 ); then
        IMPLIB_STATE=$( echo "$IMPLIB_OUT" | sed -n 's/^mkmsvcimplibs: //p' | head -1 )
        note "$IMPLIB_STATE"
    else
        IMPLIB_STATE="FAILED -- $( echo "$IMPLIB_OUT" | tail -1 )"
        note "WARNING: msvc import libraries not generated -- $IMPLIB_STATE"
    fi
else
    IMPLIB_STATE="not applicable on this host"
fi

# ------------------------------------------------------------------- fbcunit
#
# THE UNIT-TEST LIBRARY SHIPS, header and archive, so a user's test suite needs
# nothing that is not in the toolchain: '#include "fbcunit.bi"' is found in inc/,
# and its '#inclib "fbcunit"' in lib/<target>/, beside the runtime, where the
# compiler already looks. fbcunit is fbc's own -- tests/vendor/fbc-tests/fbcunit,
# vendored unmodified -- so it is BUILT HERE with the compiler just packaged,
# per target, rather than copied: fbc's archives are MinGW and the default target
# is the Microsoft ABI. libfbcunit.a on every target, the MSVC one included --
# LinkExe resolves lib<name>.a in a search path before it asks lld-link for
# <name>.lib.
#
# LGPL-2.1-or-later WITH A STATIC-LINKING EXCEPTION, so the archive carries an
# obligation: its source ships beside it, under src/fbcunit, with its notices.
#
# NOT FATAL, as the graphics library is not: a user without fbcunit has lost the
# test library, not the compiler. The manifest records each target either way.
FBCU="$ROOT/tests/vendor/fbc-tests/fbcunit"
FBCU_AR=${TKO_AR:-$( command -v llvm-ar 2>/dev/null || echo "/c/Program Files/LLVM/bin/llvm-ar.exe" )}
FBCU_STATE=""
for t in $TARGETS; do
    _fo="$OUT/.fbcunit.$t"
    rm -rf "$_fo"; mkdir -p "$_fo"
    _fok=1
    for _fs in "$FBCU"/src/*.bas; do
        _fn=$( basename "$_fs" .bas )
        "$OUT/${BINSUB}tiko$EXT" -target "$t" -c "$_fs" -i "$FBCU/inc" -i "$FBCU/src" \
            -o "$_fo/$_fn.o" >>"$_fo/log" 2>&1 || true
        # THE OBJECT IS THE TEST, not the exit code -- see verify_target below.
        [ -f "$_fo/$_fn.o" ] || _fok=0
    done
    rm -f "$OUT/lib/$t/libfbcunit.a"
    if [ "$_fok" = "1" ] && "$FBCU_AR" rcs "$OUT/lib/$t/libfbcunit.a" "$_fo"/*.o; then
        note "fbcunit -> lib/$t/libfbcunit.a"
        FBCU_STATE="$FBCU_STATE
  $t  packaged"
    else
        _fwhy=$( grep -m1 -iE 'error' "$_fo/log" | cut -c1-120 )
        [ -n "$_fwhy" ] || _fwhy="archive not written ($FBCU_AR)"
        note "WARNING: fbcunit not built for $t -- $_fwhy"
        FBCU_STATE="$FBCU_STATE
  $t  FAILED -- $_fwhy"
    fi
    rm -rf "$_fo"
done
if [ -d "$OUT/inc" ]; then
    cp -f "$FBCU/inc/fbcunit.bi" "$OUT/inc/fbcunit.bi"
else
    note "WARNING: no inc/ -- fbcunit.bi not packaged"
    FBCU_STATE="$FBCU_STATE
  header NOT packaged -- no inc/"
fi
rm -rf "$OUT/src/fbcunit"
mkdir -p "$OUT/src/fbcunit"
cp -r "$FBCU/src" "$FBCU/inc" "$OUT/src/fbcunit/"
cp -f "$FBCU/readme.txt" "$FBCU/license.txt" "$FBCU/lgpl-2.1.txt" "$OUT/src/fbcunit/"

# ------------------------------------------------------------------- fbsqlite
#
# THE DATABASE LIBRARY SHIPS ON EVERY TARGET, not only the one fbc-modern's tree
# happens to cover (T11). fbsqlite is the SQLite wrapper the book's Chapter 27 and
# its ledger capstone use: three headers, and '#inclib "sqlite3"'. Until this step,
# win64-msvc -- the default target -- failed to link it ('could not open
# sqlite3.lib'), and tiko-linux had neither the headers nor a library, because
# fbc-modern-linux carries neither.
#
# THE LIBRARY IS BUILT HERE, per target, from the amalgamation fbsqlite vendors --
# build/mksqlite.sh has the reasons for each flag. win64 keeps fbc-modern's MinGW
# archive in lib/win64-fb, which already links. The headers are copied from the same
# fbsqlite checkout, on both hosts, so they always match the library beside them.
#
# The source is TKO_SQLITE, else the fbsqlite repository beside this one. NOT FATAL,
# like fbcunit: a toolchain without a database library has lost a library, not the
# compiler. The manifest records each target either way.
SQLITE_SRC=${TKO_SQLITE:-$ROOT/../sqlite}
SQLITE_SRC=$( cd "$SQLITE_SRC" 2>/dev/null && pwd || printf '%s' "$SQLITE_SRC" )
SQLITE_STATE=""
for t in $TARGETS; do
    _sq=$( TKO_SQLITE="$SQLITE_SRC" sh "$ROOT/build/mksqlite.sh" "$t" "$OUT/lib/$t" 2>&1 ) || true
    _sqline=$( printf '%s\n' "$_sq" | sed -n 's/^mksqlite: //p' | tail -1 )
    [ -n "$_sqline" ] || _sqline="$t FAILED -- $( printf '%s\n' "$_sq" | tail -1 | cut -c1-120 )"
    note "fbsqlite: $_sqline"
    SQLITE_STATE="$SQLITE_STATE
  $_sqline"
done
if [ -d "$OUT/inc" ] && [ -f "$SQLITE_SRC/inc/fbsqlite.bi" ]; then
    for _h in fbsqlite.bi fbsqlite_csv.bi sqlite3api.bi; do
        cp -f "$SQLITE_SRC/inc/$_h" "$OUT/inc/$_h"
    done
    SQLITE_STATE="$SQLITE_STATE
  headers  fbsqlite.bi, fbsqlite_csv.bi, sqlite3api.bi from $SQLITE_SRC/inc"
else
    note "WARNING: fbsqlite headers not packaged -- no inc/ or no $SQLITE_SRC/inc/fbsqlite.bi"
    SQLITE_STATE="$SQLITE_STATE
  headers  NOT packaged"
fi

# ----------------------------------------------------------------- the notices
#
# lib/rt is LGPL-2.1-or-later and a derivative of libfb; lib/gfx is
# LGPL-2.1-or-later with the static-linking exception and a derivative of gfxlib2;
# and this tree redistributes fbc's own binaries. docs/plan/11 records that as
# permitted and carrying obligations rather than prohibitions -- so the notices
# ship with the toolchain instead of being something to remember at release time.
mkdir -p "$OUT/licences"
cp -f "$ROOT/LICENSE"              "$OUT/licences/LICENSE-tiko"
cp -f "$ROOT/COPYING"              "$OUT/licences/COPYING-tiko"
cp -f "$ROOT/COPYING.LGPL-2.1"     "$OUT/licences/COPYING.LGPL-2.1-tiko"
cp -f "$ROOT/lib/gfx/LICENSE"      "$OUT/licences/LICENSE-libtkogfx"
cp -f "$ROOT/lib/rt/LICENSE"       "$OUT/licences/LICENSE-tiko-rt"
cp -f "$ROOT/lib/rt/PROVENANCE.md" "$OUT/licences/PROVENANCE-tiko-rt.md"
cp -f "$FBCU/license.txt"         "$OUT/licences/LICENSE-fbcunit"
cp -f "$FBCU/lgpl-2.1.txt"        "$OUT/licences/COPYING.LGPL-2.1-fbcunit"
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
# Run from $OUT passing nothing but -target -- the invocation the manifest tells a
# user to use -- so what is verified is the documented one and not some other.

VERIFY_LINES=""

verify_target( ) {
    _t=$1
    _tmp="$OUT/.verify.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    # A BUNDLED HEADER IS PART OF THE TEST. 'print "ok"' alone needs no inc/ at all,
    # so a toolchain whose headers were unreachable -- tiko-linux, whose inc/ was
    # copied from fbc-modern-linux's EMPTY inc/ rather than its include/freebasic --
    # passed this, and the first '#include "containers.bi"' a user wrote was TKO0301.
    printf '#include once "containers.bi"
print "ok"
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

# FBCUNIT IS VERIFIED THE SAME WAY: a program that includes the shipped header,
# resolves its #inclib out of lib/<target>/ and RUNS. An archive that is present
# but was built for the wrong ABI links nothing, and only a link says so.
# fbsqlite IS VERIFIED BY A QUERY, not by a link: an in-memory database, a table, a row
# and a count read back. A library that links but was built without its options, or
# against the wrong runtime, fails here and not in a reader's program.
verify_fbsqlite( ) {
    _t=$1
    _tmp="$OUT/.verifysq.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf '#include once "fbsqlite.bi"
using SQLite
dim db as Database
if db.OpenMemory( ).IsOk( ) = false then end 1
db.Execute( "create virtual table t using fts5( word )" )
db.Execute( "insert into t values( ?1 )", Args( "tiko" ) )
dim n as MaybeValueResult = db.QueryScalar( "select count(*) from t where t match ?1", Args( "tiko" ) )
if n.IsOk( ) andalso n.Value( ).Value( ).AsInt64( ) = 1 then print "ok"
' > "$_tmp/sq.bas"
    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t" ".verifysq.$_t/sq.bas" -o ".verifysq.$_t/sq$EXT" ) >"$_tmp/log" 2>&1 || true
    if [ -f "$_tmp/sq$EXT" ] && [ "$( "$_tmp/sq$EXT" 2>/dev/null )" = "ok" ]; then
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbsqlite PASS -- compiled, linked and ran an FTS5 query"
    else
        _why=$( grep -m1 -iE 'error|undefined|could not open' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="built, but the query did not print ok"
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbsqlite FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

verify_fbcunit( ) {
    _t=$1
    _tmp="$OUT/.verifycu.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf '#include once "fbcunit.bi"
CU_ASSERT( 1 + 1 = 2 )
if fbcu.dblIsInf( 1.0 ) = false then print "ok"
' > "$_tmp/cu.bas"
    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t" ".verifycu.$_t/cu.bas" -o ".verifycu.$_t/cu$EXT" ) >"$_tmp/log" 2>&1 || true
    if [ -f "$_tmp/cu$EXT" ] && [ "$( "$_tmp/cu$EXT" 2>/dev/null )" = "ok" ]; then
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbcunit PASS -- compiled, linked and ran"
    else
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="built, but did not print ok"
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbcunit FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

# THE STANDARD PACKAGE IS VERIFIED THE SAME WAY: programs importing every std facade
# (RFC-0009 §7), found in the packaged pkg/ and nowhere else, their headers in the packaged
# inc/, built with their modules and RUN. Each facade prints one value on a line of its
# own: a wrong value fails that facade's line, and a header that renamed or dropped a name
# its facade exports fails the build, every line carrying the error that names it -- HERE,
# and not in a user's build. std/tasks gets a program of its own: its
# headers refuse to compile without -mt. The module cache goes to the scratch directory,
# which is removed.
STD_CHECKS='strings|print strings.Replace( "k-o", "-", "" )|ko
fs|print fs.PathExtension( "a.txt" )|.txt
containers|dim as containers.Array( of long ) a : a.Push( 7 ) : print str( a[0] )|7
chrono|print str( chrono.LocalDate( 2026, 9, 28 ).Day )|28
outcome|print str( outcome.Some( of long )( 5 ).Value( ) )|5
numeric|print str( numeric.GCD( 12ull, 18ull ) )|6
money|print money.DecimalFromInt( 12 ).ToString( )|12
logs|print logs.LevelName( logs.LOG_WARN )|WARN
tui|print str( tui.TuiStringWidth( "abc" ) )|3'
STD_TASKS='tasks|dim as tasks.WaitGroup wg : wg.Add( 1 ) : wg.Done( ) : print str( wg.Count( ) )|0'

# verify_std_run <target> <tag> <checks> <extra tiko flags>
verify_std_run( ) {
    _t=$1; _tag=$2; _checks=$3; _flags=$4
    _tmp="$OUT/.verifystd.$_t.$_tag"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    : > "$_tmp/std.bas"
    echo "$_checks" | while IFS='|' read -r _m _code _want; do
        printf '#import "std/%s"\n' "$_m" >> "$_tmp/std.bas"
    done
    echo "$_checks" | while IFS='|' read -r _m _code _want; do
        printf '%s\n' "$_code" >> "$_tmp/std.bas"
    done
    ( cd "$OUT" && TKO_MODCACHE=".verifystd.$_t.$_tag/cache" "./${BINSUB}tiko$EXT" $_flags -target "$_t" \
        ".verifystd.$_t.$_tag/std.bas" -o ".verifystd.$_t.$_tag/std$EXT" ) >"$_tmp/log" 2>&1 || true
    _why=""
    if [ -f "$_tmp/std$EXT" ]; then
        "$_tmp/std$EXT" 2>/dev/null | tr -d '\r' > "$_tmp/out" || true
    else
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="not built"
    fi
    _i=0
    _lines=$( echo "$_checks" | while IFS='|' read -r _m _code _want; do
        _i=$(( _i + 1 ))
        if [ -n "$_why" ]; then
            echo "  $_t  std/$_m FAIL -- $_why"
        elif [ "$( sed -n "${_i}p" "$_tmp/out" )" = "$_want" ]; then
            echo "  $_t  std/$_m PASS -- imported, compiled, linked and ran"
        else
            echo "  $_t  std/$_m FAIL -- printed '$( sed -n "${_i}p" "$_tmp/out" )', not '$_want'"
        fi
    done )
    VERIFY_LINES="$VERIFY_LINES
$_lines"
    rm -rf "$_tmp"
}

verify_std( ) {
    verify_std_run "$1" all "$STD_CHECKS" ""
    verify_std_run "$1" tasks "$STD_TASKS" "-mt"
}

# SYS/WINDOWS (ADR 0017 §19), on a Windows target only: a program with no UNICODE imports the
# facade and calls through it. 16 is SE_DEBUG_NAME's length and 2 win.TCHAR's size, both W;
# the call links user32. A header that renamed or dropped a name the facade exports fails
# the build here.
verify_sys( ) {
    _t=$1
    case "$_t" in win*) ;; *) return ;; esac
    _tmp="$OUT/.verifysys.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf '#import "sys/windows" as win
print len( win.SE_DEBUG_NAME ); sizeof( win.TCHAR ); win.IsWindow( 0 )
' > "$_tmp/sys.bas"
    ( cd "$OUT" && TKO_MODCACHE=".verifysys.$_t/cache" "./${BINSUB}tiko$EXT" -target "$_t" \
        ".verifysys.$_t/sys.bas" -o ".verifysys.$_t/sys$EXT" ) >"$_tmp/log" 2>&1 || true
    if [ -f "$_tmp/sys$EXT" ] && [ "$( "$_tmp/sys$EXT" 2>/dev/null | tr -d '\r' )" = " 16 2 0" ]; then
        VERIFY_LINES="$VERIFY_LINES
  $_t  sys/windows PASS -- imported, compiled, linked and ran"
    else
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="built, but did not print ' 16 2 0'"
        VERIFY_LINES="$VERIFY_LINES
  $_t  sys/windows FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

# FBX (ADR 0017 §20), on a Windows target only: core, datetime and gui imported from the
# packaged pkg/fbx -- the gui import builds the largest module, and its headers -- and a
# DWSTRING's length, a string helper and a COleDateTime printed.
verify_fbx( ) {
    _t=$1
    case "$_t" in win*) ;; *) return ;; esac
    _tmp="$OUT/.verifyfbx.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf '#import "fbx/core"
#import "fbx/datetime"
#import "fbx/gui"
dim as core.DWSTRING s = "fbx modules"
dim as datetime.COleDateTime dt = datetime.COleDateTime( 2026, 9, 29, 12, 0, 0 )
print len( s ); core.fbxParseCount( "a,b,c" ); dt.GetYear( )
' > "$_tmp/fbx.bas"
    ( cd "$OUT" && TKO_MODCACHE=".verifyfbx.$_t/cache" "./${BINSUB}tiko$EXT" -target "$_t" \
        ".verifyfbx.$_t/fbx.bas" -o ".verifyfbx.$_t/fbx$EXT" ) >"$_tmp/log" 2>&1 || true
    if [ -f "$_tmp/fbx$EXT" ] && [ "$( "$_tmp/fbx$EXT" 2>/dev/null | tr -d '\r' )" = " 11 32026" ]; then
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbx PASS -- core, datetime and gui imported, compiled, linked and ran"
    else
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="built, but did not print ' 11 32026'"
        VERIFY_LINES="$VERIFY_LINES
  $_t  fbx FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

if [ "$DO_VERIFY" = "1" ]; then
    for t in $TARGETS; do
        note "verifying $t: compile, link and run"
        verify_target "$t"
        verify_fbcunit "$t"
        verify_fbsqlite "$t"
        verify_std "$t"
        verify_sys "$t"
        verify_fbx "$t"
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

# UNDER WSL a worktree made by Windows git records its gitdir as 'C:/...', which
# Linux git cannot open -- the Linux toolchain was stamped 'commit unknown'. Windows
# git, reachable through WSL interop, answers for the same tree.
git_in_root( ) {
    if ( cd "$ROOT" && git rev-parse --git-dir >/dev/null 2>&1 ); then
        ( cd "$ROOT" && git "$@" )
    elif command -v git.exe >/dev/null 2>&1 && command -v wslpath >/dev/null 2>&1; then
        git.exe -C "$( wslpath -w "$ROOT" )" "$@" | tr -d '\r'
    else
        return 1
    fi
}
REV=$( git_in_root rev-parse --short HEAD 2>/dev/null || echo unknown )
[ -n "$REV" ] || REV=unknown
if [ -n "$( git_in_root status --porcelain 2>/dev/null | head -1 )" ]; then
    REV="$REV+dirty"
fi

NFILES=$( cd "$OUT" && find . -type f ! -name MANIFEST.txt | wc -l )
SIZE=$( du -sh "$OUT" | cut -f1 )

{
    say "tiko toolchain -- $HOST"
    say
    say "packaged       $(date -u '+%Y-%m-%d %H:%M:%SZ')"
    say "from           $ROOT"
    say "commit         $REV"
    say "configuration  $CFG"
    say "targets        $TARGETS"
    say "reference fbc  $FBTC"
    say "contents       $NFILES files, $SIZE"
    say
    say "-- what is NOT in here -------------------------------------------------"
    say "clang       REQUIRED, not bundled. The compiler runs it for both the"
    say "            .ll -> .o step and the link. Install LLVM, and point at it"
    say "            by setting TKO_CLANG if it is not at the default"
    say "            $CLANG_DEFAULT."
    say
    say "-- libraries, per target -----------------------------------------------"
    say "lib/<target>/     tiko-rt: libfb.a and libfbmt.a, plus libtkogfx.a"
    say "                  where there is one -- the compiler looks for all"
    say "                  three in the same directory."
    if [ "$HOST" = "windows" ]; then
        say "lib/<target>-fb/  fbc's CRT objects and import libraries, behind"
        say "                  ours -- NOT fbc's libfb, which tiko no longer needs"
        say "                  (decision 0015). Absent for win64-msvc: fbc has no"
        say "                  MSVC target and that one links without."
        say
        say "lib/win64-msvc/*.lib   MSVC-format import libraries for the Windows"
        say "                  DLLs, GENERATED from fbc's MinGW lib<name>.dll.a --"
        say "                  the MSVC linker looks for <name>.lib and would"
        say "                  otherwise fall back on an installed Visual Studio."
        say "                  build/mkmsvcimplibs.sh, rerunnable on its own."
        say
        say "import libraries: $IMPLIB_STATE"
    else
        say "lib/<target>-fb/  fbc's startup objects and support libraries, behind"
        say "                  ours -- NOT fbc's libfb, which tiko no longer needs"
        say "                  (decision 0015)."
    fi
    say
    say "graphics:$GFX_STATE"
    say
    say "fbcunit (the unit-test library; source in src/fbcunit):$FBCU_STATE"
    say
    say "fbsqlite (SQLite 3, public domain; built by build/mksqlite.sh):$SQLITE_STATE"
    say
    say "-- verification --------------------------------------------------------"
    say "Each target below was checked by compiling AND RUNNING a program with"
    say "this tree, using exactly the invocation shown under 'linking'."
    say "$VERIFY_LINES"
    say
    say "-- linking -------------------------------------------------------------"
    say "Nothing has to be passed. tiko appends inc/ to the include search and"
    say "lib/<target>/ then lib/<target>-fb/ to the library search on its own,"
    say "all relative to the executable, as fbc does with inc/ and lib/<target>."
    say
    say "The -fb half has no fbc counterpart and is ours. It holds what a MinGW"
    say "or glibc link needs from fbc's toolchain -- its startup objects, which"
    say "must match that toolchain -- and no runtime: tiko-rt is complete, and"
    say "the compiler names a directory's libfb.a only where there is one."
    say "OURS COMES FIRST, and that order is fixed in the compiler, not left to"
    if [ "$HOST" = "windows" ]; then
        say "the caller. win64-msvc needs no second directory at all."
    else
        say "the caller."
    fi
    say
    say "  tiko yourprogram.bas                  the default, $DEFTARGET"
    for t in $TARGETS; do
        say "  tiko -target $t yourprogram.bas"
    done
    say
    if [ "$HOST" = "windows" ]; then
        say "GRAPHICS IS win64-msvc ONLY. libtkogfx is built for the Microsoft ABI"
        say "and there is no MinGW build of it, so a SCREEN or PSET program links"
        say "on the default target and nowhere else. That is why it is the default."
    else
        say "NO GRAPHICS ON THIS HOST. libtkogfx is built for win64-msvc only, so a"
        say "SCREEN or PSET program does not link here: fb_Gfx* are undefined."
    fi
    say
    say "A -p of your own is searched BEFORE both, so it can override either."
    say "TKO_LIBPATH replaces them instead, as TKO_INCLUDE replaces inc/."
    say
    say "-- licences ------------------------------------------------------------"
    say "licences/ holds tiko's own notices -- the compiler under GPL-2.0+, and"
    say "tiko-rt and libtkogfx under LGPL-2.1+ with the static-linking"
    say "exception -- with tiko-rt's provenance, and FreeBASIC's own. This tree"
    say "redistributes binaries built from LGPL sources; distributing it"
    say "carries the source-offer obligation."
} > "$OUT/MANIFEST.txt"

note "manifest -> MANIFEST.txt"
note "ok -- $NFILES files, $SIZE"
