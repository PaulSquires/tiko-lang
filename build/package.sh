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
#   build/package.sh --third-party-inc DIR  third-party bindings (default: the seed's inc/)
#   build/package.sh --out DIR              somewhere other than toolchains/
#
# The output is toolchains/tiko-windows or toolchains/tiko-linux: what an end user
# unpacks, as opposed to bin/tiko, which is what build/build.sh produces for
# developing the compiler.
#
# ---------------------------------------------------------------- what it is NOT
#
# THIS DOES NOT PRODUCE A SELF-CONTAINED TOOLCHAIN, and the manifest it writes says
# so. One thing stays external, and one is optional:
#
#   clang    src/codegen/toolchain.tiko runs clang for BOTH steps -- the .ll to .o
#            compile and the link. It is found at C:\Program Files\LLVM\bin, or
#            wherever TKO_CLANG points. Bundling LLVM is a gigabyte and a separate
#            decision, so a packaged toolchain depends on an installed one.
#
#   win64    -target win64, the MinGW ABI, is NOT PACKAGED (the author's order,
#            2026-10-10; decision Q2): no lib/win64, no MinGW runtime. The compiler
#            still accepts the target -- build tiko-rt for it (lib/rt/build/build.sh
#            Release win64) and link with a MinGW-w64 on PATH. windows-x86_64, the
#            default, and linux-x86_64 need nothing of the kind.
#
# Neither is a packaging bug. Both are written into MANIFEST.txt so that a
# toolchain cannot be passed on with them invisible.
#
# ------------------------------------------------------------------- NO fbc
#
# Since 2026-10-10 nothing here reads fbc or fbc-modern. The compiler is built by the
# pinned seed (seed/seed.lock), the runtime and the graphics library by that compiler,
# the headers are the tree's inc/, the import libraries lib/implib/, and FreeBASIC's
# notices licences/. The third-party bindings come from the seed's inc/ -- tiko's own
# last release -- until the author decides where they live.
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
T0=$(date +%s)
TPINC=${TKO_THIRDPARTY_INC:-}
OUT=

die( ) { echo "package: $*" >&2; exit 1; }
note( ) { echo "package: [$(( $(date +%s) - T0 ))s] $*"; }
# THE MANIFEST IS WRITTEN WITH printf, NOT echo. dash -- Linux's /bin/sh -- expands
# backslash escapes in echo's arguments, so the Windows clang path came out as
# 'C:\Program Files\LLVMin': its '\b' was a backspace. Git Bash's sh does not, which
# is why the Windows manifest never showed it.
say( ) { printf '%s\n' "$*"; }

usage( ) {
    sed -n '2,53p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

while [ $# -gt 0 ]; do
    case $1 in
        --config)    CFG=$2;      shift 2 ;;
        --mingw-lib) die "--mingw-lib is gone: -target win64 is not packaged since 2026-10-10" ;;
        --third-party-inc) TPINC=$2; shift 2 ;;
        --out)       OUT=$2;      shift 2 ;;
        --no-build)  DO_BUILD=0;  shift ;;
        --no-inc)    DO_INC=0;    shift ;;
        --clean)     DO_CLEAN=1;  shift ;;
        --verify)    DO_VERIFY=1; shift ;;
        # Both retired 2026-10-10, refused by name rather than as 'unknown'.
        --fbc-tree)  die "--fbc-tree is gone: nothing reads fbc now (--third-party-inc for bindings)" ;;
        --implibs)   die "--implibs is gone: the import libraries are built from lib/implib/ on every run" ;;
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
# WINDOWS-X86_64 IS THE DEFAULT and is listed first. It is the only target lib/gfx
# builds, so it is the only one where a SCREEN program links; and it is the ONE
# target that needs nothing behind it. That is measured, 2026-09-06: a program
# built for windows-x86_64 against lib/windows-x86_64 alone -- no fbc directory, none to
# have -- linked and ran. tiko-rt's MSVC archive carries no MinGW imports
# (build/abidelta.sh, and gatemsvc.sh at 3,922,073 assertions). win64 needed fbc's
# libfb behind it until decision 0015 (D15); now it needs only fbc's CRT behind it.
#
# win64, the MinGW ABI, is not packaged -- see 'what it is NOT' above.

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        HOST=windows; EXT=".exe"; BINSUB=""
        TARGETS="windows-x86_64"
        # The compiler's own default on this host -- HostTarget( ), src/types/type.tiko.
        DEFTARGET=windows-x86_64
        CLANG_DEFAULT='C:\Program Files\LLVM\bin\clang.exe'
        ;;
    Linux)
        HOST=linux; EXT=""; BINSUB="bin/"
        TARGETS="linux-x86_64"
        DEFTARGET=linux-x86_64
        # The compiler's own default on Linux -- see src/codegen/toolchain.tiko.
        CLANG_DEFAULT=/usr/bin/clang
        ;;
    *)  die "unsupported host '$(uname -s)' -- this packages Windows or Linux" ;;
esac

# WHICH TARGETS HAVE A GRAPHICS LIBRARY. windows-x86_64 alone, and lib/gfx/build
# says why: tiko emits the Microsoft ABI for it and there is no MSVC libfbgfx
# anywhere to fall back on, so that is the target the library was written for.
# Kept as a list rather than a test so that the day a second one appears, this
# is the line that changes.
GFX_TARGETS="windows-x86_64"

gfx_has_target( ) {
    for __g in $GFX_TARGETS; do [ "$1" = "$__g" ] && return 0; done
    return 1
}

[ -n "$OUT" ] || OUT="$ROOT/toolchains/tiko-$HOST"

MINGW_STATE="not applicable on this host"
[ "$HOST" = "windows" ] && MINGW_STATE="-target win64 (MinGW) is not packaged"

# THE THIRD-PARTY BINDINGS' SOURCE: the one given, else the seed's inc/ -- the pinned
# seed's (seed/cache) or, failing that, a locally packaged toolchain's, the same search
# build/build.sh makes for its compiler. tiko-lang's own inc/ goes over them below.
if [ -z "$TPINC" ]; then
    . "$ROOT/build/defaultseed.sh"
    if [ "$HOST" = "windows" ]; then _sw=1; else _sw=0; fi
    if _seed=$( default_seed "$ROOT" "$_sw" ); then
        _sd=$( dirname "$_seed" ); [ "$HOST" = "linux" ] && _sd=$( dirname "$_sd" )
        [ -d "$_sd/inc" ] && TPINC="$_sd/inc"
    fi
fi

note "host $HOST, configuration $CFG, targets $TARGETS"
note "output $OUT"

# ------------------------------------------------------------------- the parts
#
# Everything is built BEFORE anything is copied, so a build failure leaves the
# previous toolchain intact rather than half-replaced.

if [ "$DO_BUILD" = "1" ]; then
    # THE COMPILER FIRST, THEN THE REST WITH IT. The runtime is built by tiko since
    # 2026-10-10 -- by THIS compiler, bin/tiko, not by the seed that built it: a seed
    # may predate a fix the runtime's own source needs (seed-1 does: R1-R3). So the
    # compiler builds alone, and the runtimes and the graphics library then build
    # concurrently, each into its own obj/<target>/<config> tree.
    mkdir -p "$ROOT/lib/rt/obj" "$ROOT/lib/gfx/obj"
    note "building the compiler [$CFG]"
    # --no-dll: the editor's tikoParser.dll ships with the editor, not in a toolchain.
    if ! sh "$ROOT/build/build.sh" "$CFG" --no-dll >"$ROOT/lib/rt/obj/package-tiko.log" 2>&1; then
        tail -20 "$ROOT/lib/rt/obj/package-tiko.log" >&2
        die "the compiler build failed -- lib/rt/obj/package-tiko.log"
    fi
    note "compiler built"
    TKORT_TIKO="$ROOT/bin/tiko$EXT"; export TKORT_TIKO
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
    # A FAILURE HERE IS NOTED, NOT FATAL, and that is deliberate: aborting the whole
    # package because the graphics library could not build would take the compiler
    # and runtime down with it. The manifest records the reason instead, so the
    # absence is never silent.
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

# ----------------------------------------------------------------- the assembly

if [ "$DO_CLEAN" = "1" ] && [ -d "$OUT" ]; then
    note "cleaning $OUT"
    # Everything: the per-host toolchain directories hold build products only, and no
    # README is kept or written there.
    find "$OUT" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
fi

mkdir -p "$OUT"
[ -z "$BINSUB" ] || mkdir -p "$OUT/$BINSUB"

# NO examples/ IN A TOOLCHAIN (the author's order, 2026-10-10). Nothing here ever wrote one:
# 2,098 fbx examples were placed in toolchains/tiko-windows by hand on 2026-09-29, and since
# packaging replaces only what it writes, they rode along in every package -- and in its
# MANIFEST file count -- until a release recipe excluded them. A toolchain no longer has it.
if [ -e "$OUT/examples" ]; then
    note "removing examples/ -- a toolchain does not ship one"
    rm -rf "$OUT/examples"
fi

note "compiler -> ${BINSUB}tiko$EXT"
cp -f "$TIKO" "$OUT/${BINSUB}tiko$EXT"

# The headers. The compiler finds these itself: AppendDefaultIncludeDir looks at
# <exe-dir>/inc and then <exe-dir>/../inc, which is exactly why the Windows binary
# sits at the root and the Linux one under bin/ -- both resolve to ./inc.
#
# TWO LAYERS, assembled in a scratch directory and then swapped in, because the
# first layer's source may be this very directory (a seed found as
# toolchains/tiko-<host>, which is where this writes):
#
#   1. the third-party bindings -- SDL, GTK, AfxNova and the rest tiko-lang does not
#      carry -- from --third-party-inc, else the seed's inc/. NOT fbc's: since
#      2026-10-10 they come from tiko's own last release.
#   2. tiko-lang's OWN HEADERS over them (phase H): crt/, win/, windows.bi and the rest
#      of FreeBASIC's set are the tree's inc/, the one copy (fb/ and containers.bi are the
#      std modules in pkg/ since 2026-10-10, and inc-exclude.txt keeps the seed's out) --
#      inc/PROVENANCE.md says where each came from.
#
# AN EMPTY inc/ IS REFUSED. tiko-linux once shipped one -- copied from fbc-modern-linux's
# empty inc/ rather than its include/freebasic -- and --verify still said PASS, because
# its program then included no bundled header. It does now.
if [ "$DO_INC" = "1" ]; then
    _newinc="$OUT/.inc.new"
    rm -rf "$_newinc"; mkdir -p "$_newinc"
    if [ -n "$TPINC" ] && [ -d "$TPINC" ]; then
        note "headers -> inc/  third-party bindings from $TPINC"
        cp -r "$TPINC/." "$_newinc/"
        INC_STATE="inc/ at this commit, over the third-party bindings in $TPINC"
    else
        note "WARNING: no third-party bindings -- no --third-party-inc and no seed inc/"
        INC_STATE="inc/ at this commit ONLY -- no third-party bindings (no --third-party-inc, no seed)"
    fi
    # fbx IS NOT SHIPPED (ADR 0017 §20): its successor is the package pkg/tkl. Kept, it
    # would also be a package named fbx that a '-i <inc>' root offers '#import "fbx/..."'.
    rm -rf "$_newinc/fbx"
    note "headers -> inc/  tiko-lang's own over them: $(find "$ROOT/inc" -name '*.bi' | wc -l | tr -d ' ') files from inc/"
    cp -r "$ROOT/inc/." "$_newinc/"
    rm -f "$_newinc/.import-manifest.tsv"
    # THE EXCLUSIONS (build/inc-exclude.txt): top-level entries the toolchain does not ship --
    # third-party bindings tiko does not carry, by the author's list. A header that IS shipped
    # but includes an excluded one would fail at its first '#include' in a user's build, so
    # that is refused here rather than discovered there.
    # One entry per line, a path below inc/; a second word 'unreachable' exempts it from the
    # include check below (inc-exclude.txt says when that is true).
    _exf=$( grep -v '^[[:space:]]*#' "$ROOT/build/inc-exclude.txt" | tr -d '\r' | grep -v '^[[:space:]]*$' )
    _excl=$( printf '%s\n' "$_exf" | awk '{ print $1 }' )
    _chk=$( printf '%s\n' "$_exf" | awk '$2 != "unreachable" { print $1 }' )
    _nex=0
    for _e in $_excl; do
        if [ -e "$_newinc/$_e" ]; then rm -rf "$_newinc/$_e"; _nex=$(( _nex + 1 )); fi
    done
    _pat=$( printf '%s\n' $_chk | sed 's/[.]/\\./g' | paste -sd'|' - )
    _dang=$( grep -rIliE "^[[:space:]]*#[[:space:]]*include([[:space:]]+once)?[[:space:]]+\"($_pat)(\"|/)" "$_newinc" 2>/dev/null | head -5 | sed "s#^$_newinc/##" | tr '\n' ' ' )
    [ -z "$_dang" ] || { rm -rf "$_newinc"; die "shipped headers include excluded ones (build/inc-exclude.txt): $_dang"; }
    note "headers -> inc/  $_nex entries left out (build/inc-exclude.txt)"
    INC_STATE="$INC_STATE; $_nex entries left out by build/inc-exclude.txt"
    [ -n "$( ls -A "$_newinc" 2>/dev/null )" ] || { rm -rf "$_newinc"; die "packaged inc/ is EMPTY -- the compiler would find no headers at all"; }
    # include/ was fbc-modern-linux's header tree, copied whole beside inc/. The compiler
    # never looked in it (<exe-dir>/inc, <exe-dir>/../inc); it goes.
    rm -rf "$OUT/include"
    # EMPTIED, NOT REMOVED. The directory itself is sometimes held open -- a shell whose cwd
    # is inside it, an editor, a junction -- and 'rm -rf inc' then deleted every header and
    # failed on the directory, leaving the toolchain with NONE (2026-09-23, 09-24, 10-10).
    # Its contents can always go, so they do, and the new set moves in entry by entry.
    mkdir -p "$OUT/inc"
    find "$OUT/inc" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    for _e in "$_newinc"/* "$_newinc"/.[!.]*; do
        [ -e "$_e" ] && mv "$_e" "$OUT/inc/"
    done
    rmdir "$_newinc"
else
    note "--no-inc: headers not packaged"
    INC_STATE="not packaged (--no-inc)"
fi

# THE PACKAGE TREE (ADR 0017; RFC-0007 §5): pkg/, beside inc/, which '#import "std/..."'
# finds as <exe-dir>/pkg or <exe-dir>/../pkg -- the two layouts the binaries sit in. The
# copy is ASSERTED: a pkg/ that silently failed to ship would look like a user's typo in
# an import path.
rm -rf "$OUT/pkg"
cp -r "$ROOT/pkg" "$OUT/pkg"
[ -f "$OUT/pkg/std/tiko.toml" ] || die "packaged pkg/ has no std/tiko.toml -- '#import \"std/...\"' would find nothing"
[ -f "$OUT/pkg/std/strings/string.tiko" ] || die "packaged pkg/ has no std/strings"
[ -f "$OUT/pkg/tkl/tkGui/CWindow.tiko" ] || die "packaged pkg/ has no tkl/tkGui"
note "packages -> pkg/ ($( ls "$OUT/pkg" | tr '\n' ' '))"

# THE VENDOR PACKAGES (tiko-vendor RFC-0002 V9, V11): their translated headers came with
# pkg/; their binaries are never copied from the tree -- vendorfetch.sh downloads or builds
# this host's, pinned and SHA-256-checked, straight into the output -- and fetch.toml is
# that script's alone. Each module must end with binaries and its library's licence --
# binaries only where its fetch.toml has entries for this host: the vendor/SDL3* modules have
# none on Linux, where SDL publishes no binaries and they link the system's libraries instead.
rm -rf "$OUT"/pkg/vendor/*/lib
rm -f "$OUT"/pkg/vendor/*/fetch.toml
sh "$ROOT/build/vendorfetch.sh" --out "$OUT/pkg" || die "vendorfetch.sh failed: the vendor packages have no binaries"
for _vm in "$OUT"/pkg/vendor/*/; do
    _vft="$ROOT/pkg/vendor/$( basename "$_vm" )/fetch.toml"
    if grep -q "^\[$HOST\." "$_vft" 2>/dev/null; then
        [ -n "$( ls "$_vm/lib" 2>/dev/null )" ] || die "packaged $_vm has no lib/ -- '#import \"vendor/...\"' would not link"
    else
        note "packaged $_vm has no $HOST binaries: its fetch.toml has no [$HOST.<n>] entry"
    fi
    [ -f "$_vm/LICENSE" ] || die "packaged $_vm has no LICENSE"
done
note "vendor packages -> pkg/vendor ($( cd "$OUT/pkg/vendor" && ls -d */ | tr -d '/' | tr '\n' ' '))"

# The libraries: lib/<target>/, ours alone -- tiko-rt, its startup object on a gnu
# target, libtkogfx where there is one. No target has a second, -fb, directory since
# 2026-10-10: linux-x86_64's held nothing the driver names, and win64's MinGW runtime
# went with the win64 target.
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
            case ${d##*/} in "$t") _keep=1 ;; esac
        done
        # No -fb directory for any target now: linux-x86_64-fb held fbc's fbrt0.o and
        # libraries the driver never names (tiko-rt has its own fbrt0, R8), and win64 --
        # whose MinGW runtime win64-fb was -- is not packaged. Both are swept here.
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
    # THE PIC PAIR, where the runtime builds one (linux-x86_64): what a Linux '-dll'
    # links, as fbc's own '-lfbpic' does. lib/rt/build/build.sh says why.
    for _pic in libfbpic.a libfbmtpic.a; do
        [ -f "$ROOT/lib/rt/lib/$t/$_pic" ] && cp -f "$ROOT/lib/rt/lib/$t/$_pic" "$OUT/lib/$t/"
    done
    # THE STARTUP OBJECT, tiko-rt's own since 2026-10-09 (lib/rt/src/c/fbrt0.c), for a
    # gnu target. It goes beside the runtime so the driver's first-match search finds
    # it before lib/<target>-fb/; that copy of fbc's is deleted below all the same.
    for _rt0 in fbrt0.o fbrt0pic.o; do
        [ -f "$ROOT/lib/rt/lib/$t/$_rt0" ] && cp -f "$ROOT/lib/rt/lib/$t/$_rt0" "$OUT/lib/$t/"
    done
    case $t in
        windows-x86_64) ;;
        *) [ -f "$OUT/lib/$t/fbrt0.o" ] || \
               die "no fbrt0.o for $t -- lib/rt/build/build.sh builds it beside libfb.a" ;;
    esac

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

done

# THE MSVC IMPORT LIBRARIES, built from the tree: lib/implib/*.def, one llvm-dlltool
# run each, and lib/implib/static/*.lib copied through (build/implibs.sh). The MSVC
# linker looks for <name>.lib; nothing else here supplies one.
#
# WITHOUT THESE THE DEFAULT TARGET DEPENDS ON VISUAL STUDIO. Measured 2026-09-06:
# clang's msvc driver passes -libpath for VS 2022 Community and Windows SDK
# 10.0.26100 out of its own knowledge of the machine, so windows-x86_64 linked here and
# would not link on a machine without them. A toolchain whose default target needs
# an unrelated install is not one that can be handed to anyone.
#
# NOT FROM fbc ANY MORE (phase L, 2026-10-10). They were generated at every run from
# fbc's MinGW lib*.dll.a, and the .def files that made were thrown away; those are
# what lib/implib/ commits, and all 843 libraries came out byte for byte the same.
#
# NOT FATAL, on the same reasoning as the graphics build above: this needs
# llvm-dlltool, and losing the compiler and runtime because the import libraries
# could not be built would be the wrong trade. The manifest records what happened.
IMPLIB_STATE="not applicable on this host"
if [ "$HOST" = "windows" ]; then
    note "msvc import libraries -> lib/windows-x86_64/  (from lib/implib/)"
    if IMPLIB_OUT=$( sh "$ROOT/build/implibs.sh" build --out "$OUT/lib/windows-x86_64" 2>&1 ); then
        IMPLIB_STATE=$( echo "$IMPLIB_OUT" | sed -n 's/^implibs: //p' | tail -1 | sed 's/ -> .*//' )
        note "$IMPLIB_STATE"
    else
        IMPLIB_STATE="FAILED -- $( echo "$IMPLIB_OUT" | tail -1 )"
        note "WARNING: msvc import libraries not built -- $IMPLIB_STATE"
    fi
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
# windows-x86_64 -- the default target -- failed to link it ('could not open
# sqlite3.lib'), and tiko-linux had neither the headers nor a library, because
# fbc-modern-linux carries neither.
#
# THE LIBRARY IS BUILT HERE, per target, from the amalgamation fbsqlite vendors --
# build/mksqlite.sh has the reasons for each flag. The headers are copied from the same
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
# THE WRAPPER IS A MODULE, pkg/db/sqlite (2026-10-10): fbsqlite.bi and fbsqlite_csv.bi
# include fb/ library headers, which are the std modules now, so tiko ships its own port
# ('#import "db/sqlite"') and only the C binding beside it, sqlite3api.bi, from fbsqlite.
if [ -d "$OUT/inc" ] && [ -f "$SQLITE_SRC/inc/sqlite3api.bi" ]; then
    cp -f "$SQLITE_SRC/inc/sqlite3api.bi" "$OUT/inc/sqlite3api.bi"
    rm -f "$OUT/inc/fbsqlite.bi" "$OUT/inc/fbsqlite_csv.bi"
    SQLITE_STATE="$SQLITE_STATE
  headers  sqlite3api.bi from $SQLITE_SRC/inc; the wrapper is pkg/db/sqlite"
else
    note "WARNING: sqlite3api.bi not packaged -- no inc/ or no $SQLITE_SRC/inc/sqlite3api.bi"
    SQLITE_STATE="$SQLITE_STATE
  headers  NOT packaged"
fi

# ----------------------------------------------------------------- the notices
#
# lib/rt is LGPL-2.1-or-later and a derivative of libfb; lib/gfx is
# LGPL-2.1-or-later with the static-linking exception and a derivative of gfxlib2;
# inc/ carries FreeBASIC's headers. docs/plan/11 records that as permitted and
# carrying obligations rather than prohibitions -- so the notices ship with the
# toolchain instead of being something to remember at release time.
mkdir -p "$OUT/licences"
cp -f "$ROOT/LICENSE"              "$OUT/licences/LICENSE-tiko"
cp -f "$ROOT/COPYING"              "$OUT/licences/COPYING-tiko"
cp -f "$ROOT/COPYING.LGPL-2.1"     "$OUT/licences/COPYING.LGPL-2.1-tiko"
cp -f "$ROOT/lib/gfx/LICENSE"      "$OUT/licences/LICENSE-libtkogfx"
cp -f "$ROOT/lib/rt/LICENSE"       "$OUT/licences/LICENSE-tiko-rt"
cp -f "$ROOT/pkg/LICENSE"          "$OUT/licences/LICENSE-pkg"
cp -f "$ROOT/lib/rt/PROVENANCE.md" "$OUT/licences/PROVENANCE-tiko-rt.md"
cp -f "$FBCU/license.txt"         "$OUT/licences/LICENSE-fbcunit"
cp -f "$FBCU/lgpl-2.1.txt"        "$OUT/licences/COPYING.LGPL-2.1-fbcunit"
# FreeBASIC's own notices, FROM THE TREE (licences/), not from an fbc install: which
# licence covers which part, and the two licence texts -- the same files as tiko's
# own COPYING and COPYING.LGPL-2.1, so they are not committed twice. cp -f under
# set -e: a missing one stops the package rather than shipping without it.
cp -f "$ROOT/licences/LICENSE.freebasic" "$OUT/licences/LICENSE.freebasic"
cp -f "$ROOT/COPYING"                    "$OUT/licences/COPYING.GPL-2.0.freebasic"
cp -f "$ROOT/COPYING.LGPL-2.1"           "$OUT/licences/COPYING.LGPL-2.1.freebasic"
# mingw-w64's, for the import libraries built from lib/implib/.
if [ "$HOST" = "windows" ]; then
    cp -f "$ROOT/lib/implib/COPYING.MinGW-w64-runtime.txt" "$OUT/licences/COPYING.MinGW-w64-runtime.txt"
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
    # crt.bi since 2026-10-10, when containers.bi became std/containers (checked below).
    printf '#include once "crt.bi"
print "ok"
' > "$_tmp/hello.tiko"

    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t"             ".verify.$_t/hello.tiko" -o ".verify.$_t/hello$EXT" ) >"$_tmp/log" 2>&1 || true

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
    printf '#import "db/sqlite"
using sqlite
dim db as Database
if db.OpenMemory( ).IsOk( ) = false then end 1
db.Execute( "create virtual table t using fts5( word )" )
db.Execute( "insert into t values( ?1 )", Args( "tiko" ) )
dim n as MaybeValueResult = db.QueryScalar( "select count(*) from t where t match ?1", Args( "tiko" ) )
if n.IsOk( ) andalso n.Value( ).Value( ).AsInt64( ) = 1 then print "ok"
' > "$_tmp/sq.tiko"
    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t" ".verifysq.$_t/sq.tiko" -o ".verifysq.$_t/sq$EXT" ) >"$_tmp/log" 2>&1 || true
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
' > "$_tmp/cu.tiko"
    ( cd "$OUT" && "./${BINSUB}tiko$EXT" -target "$_t" ".verifycu.$_t/cu.tiko" -o ".verifycu.$_t/cu$EXT" ) >"$_tmp/log" 2>&1 || true
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
tui|print str( tui.TuiStringWidth( "abc" ) )|3
memory|dim as memory.SharedPtr( of long ) sp = memory.MakeSharedFrom( of long )( 9 ) : print str( *sp )|9'
STD_TASKS='tasks|dim as tasks.WaitGroup wg : wg.Add( 1 ) : wg.Done( ) : print str( wg.Count( ) )|0'

# verify_std_run <target> <tag> <checks> <extra tiko flags>
verify_std_run( ) {
    _t=$1; _tag=$2; _checks=$3; _flags=$4
    _tmp="$OUT/.verifystd.$_t.$_tag"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    : > "$_tmp/std.tiko"
    echo "$_checks" | while IFS='|' read -r _m _code _want; do
        printf '#import "std/%s"\n' "$_m" >> "$_tmp/std.tiko"
    done
    echo "$_checks" | while IFS='|' read -r _m _code _want; do
        printf '%s\n' "$_code" >> "$_tmp/std.tiko"
    done
    ( cd "$OUT" && TKO_MODCACHE=".verifystd.$_t.$_tag/cache" "./${BINSUB}tiko$EXT" $_flags -target "$_t" \
        ".verifystd.$_t.$_tag/std.tiko" -o ".verifystd.$_t.$_tag/std$EXT" ) >"$_tmp/log" 2>&1 || true
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

# TKL, on a Windows target only: tkCore, gdiplus and tkGui imported from the packaged
# pkg/tkl -- the tkGui import builds the largest module, and imports the other two -- and
# a string helper, a GDI+ colour and a CWindow used.
verify_tkl( ) {
    _t=$1
    case "$_t" in win*) ;; *) return ;; esac
    _tmp="$OUT/.verifytkl.$_t"
    rm -rf "$_tmp"; mkdir -p "$_tmp"
    printf '#import "tkl/tkCore"
#import "tkl/gdiplus"
#import "tkl/tkGui"
dim as tkGui.CWindow w
print tkCore.tkUcase( "tiko" ); " "; hex( gdiplus.GDIP_ARGB( &hFF, 1, 2, 3 ) )
' > "$_tmp/tkl.tiko"
    ( cd "$OUT" && TKO_MODCACHE=".verifytkl.$_t/cache" "./${BINSUB}tiko$EXT" -target "$_t"         ".verifytkl.$_t/tkl.tiko" -o ".verifytkl.$_t/tkl$EXT" ) >"$_tmp/log" 2>&1 || true
    if [ -f "$_tmp/tkl$EXT" ] && [ "$( "$_tmp/tkl$EXT" 2>/dev/null | tr -d '' )" = "TIKO FF010203" ]; then
        VERIFY_LINES="$VERIFY_LINES
  $_t  tkl PASS -- tkCore, gdiplus and tkGui imported, compiled, linked and ran"
    else
        _why=$( grep -m1 -iE 'error|undefined' "$_tmp/log" | cut -c1-160 )
        [ -n "$_why" ] || _why="built, but did not print 'TIKO FF010203'"
        VERIFY_LINES="$VERIFY_LINES
  $_t  tkl FAIL -- $_why"
    fi
    rm -rf "$_tmp"
}

# THE VENDOR PACKAGES, the RFC's own program (tiko-vendor RFC-0002 §1): vendor/sqlite
# imported 'link static' and 'link dynamic', from the packaged pkg/ alone, built and RUN --
# the dynamic one from beside the DLL / .so the compiler copied there (V13).
verify_vendor( ) {
    _t=$1
    for _mode in static dynamic; do
        _tmp="$OUT/.verifyvendor.$_t.$_mode"
        rm -rf "$_tmp"; mkdir -p "$_tmp"
        printf '#import "vendor/sqlite" link %s
dim as sqlite3 ptr db
if sqlite3_open( ":memory:", @db ) <> SQLITE_OK then print "open failed"
dim as sqlite3_stmt ptr st
sqlite3_prepare_v2( db, "select ? || %s", -1, @st, 0 )
sqlite3_bind_text( st, 1, "sqlite", -1, SQLITE_TRANSIENT )
if sqlite3_step( st ) = SQLITE_ROW then print *cast( zstring ptr, sqlite3_column_text( st, 0 ) )
sqlite3_finalize( st )
sqlite3_close( db )
' "$_mode" "'ok'" > "$_tmp/v.tiko"
        ( cd "$OUT" && TKO_MODCACHE=".verifyvendor.$_t.$_mode/cache" "./${BINSUB}tiko$EXT" -target "$_t" \
            ".verifyvendor.$_t.$_mode/v.tiko" -o ".verifyvendor.$_t.$_mode/v$EXT" ) >"$_tmp/log" 2>&1 || true
        if [ -f "$_tmp/v$EXT" ] && [ "$( "$_tmp/v$EXT" 2>/dev/null | tr -d '\r' )" = "sqliteok" ]; then
            VERIFY_LINES="$VERIFY_LINES
  $_t  vendor/sqlite link $_mode PASS -- imported, compiled, linked and ran"
        else
            _why=$( grep -m1 -iE 'error|undefined|cannot' "$_tmp/log" | cut -c1-160 )
            [ -n "$_why" ] || _why="built, but did not print 'sqliteok'"
            VERIFY_LINES="$VERIFY_LINES
  $_t  vendor/sqlite link $_mode FAIL -- $_why"
        fi
        rm -rf "$_tmp"
    done
}

if [ "$DO_VERIFY" = "1" ]; then
    for t in $TARGETS; do
        note "verifying $t: compile, link and run"
        verify_target "$t"
        verify_fbcunit "$t"
        verify_fbsqlite "$t"
        verify_std "$t"
        verify_tkl "$t"
        verify_vendor "$t"
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

# The seed the lock pins -- what build/build.sh builds the compiler with unless TKO_SEED
# or TKO_ORACLE_FBC says otherwise, in which case that is recorded instead.
SEED_STATE=$( awk -v h="$HOST" '$1 == h { print $2 " (" $3 ", sha256 " $4 ")" }' "$ROOT/seed/seed.lock" 2>/dev/null )
[ -n "$SEED_STATE" ] || SEED_STATE="none pinned for $HOST"
[ -n "${TKO_SEED:-}" ] && SEED_STATE="TKO_SEED=$TKO_SEED (the lock pins $SEED_STATE)"
[ -z "${TKO_SEED:-}" ] && [ -n "${TKO_ORACLE_FBC:-}" ] && SEED_STATE="TKO_ORACLE_FBC=$TKO_ORACLE_FBC -- NOT a release build (the lock pins $SEED_STATE)"

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
    say "seed           $SEED_STATE"
    say "headers        $INC_STATE"
    say "MinGW runtime  $MINGW_STATE"
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
        say "-target win64 (the MinGW ABI) is not packaged: no lib/win64. The"
        say "                  compiler accepts it; its runtime is built from"
        say "                  lib/rt in tiko-lang, and it links with a MinGW-w64"
        say "                  on PATH."
        say
        say "lib/windows-x86_64/*.lib   MSVC-format import libraries for the Windows"
        say "                  DLLs, built from tiko-lang's lib/implib/*.def by"
        say "                  build/implibs.sh -- the MSVC linker looks for"
        say "                  <name>.lib and would otherwise fall back on an"
        say "                  installed Visual Studio."
        say
        say "import libraries: $IMPLIB_STATE"
    else
        say "Nothing behind lib/<target>/: the C runtime and libc are the system's."
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
    say "lib/<target>/ to the library search on its own, both relative to the"
    say "executable."
    say
    say "  tiko yourprogram.tiko                 the default, $DEFTARGET"
    for t in $TARGETS; do
        say "  tiko -target $t yourprogram.tiko"
    done
    say
    if [ "$HOST" = "windows" ]; then
        say "GRAPHICS IS windows-x86_64 ONLY. libtkogfx is built for the Microsoft ABI"
        say "and there is no MinGW build of it, so a SCREEN or PSET program links"
        say "on the default target and nowhere else. That is why it is the default."
    else
        say "NO GRAPHICS ON THIS HOST. libtkogfx is built for windows-x86_64 only, so a"
        say "SCREEN or PSET program does not link here: fb_Gfx* are undefined."
    fi
    say
    say "A -p of your own is searched BEFORE both, so it can override either."
    say "TKO_LIBPATH replaces them instead, as TKO_INCLUDE replaces inc/."
    say
    say "-- licences ------------------------------------------------------------"
    say "licences/ holds tiko's own notices -- the compiler under GPL-2.0+, pkg/"
    say "under GPL-2.0+ with a linking exception, and"
    say "tiko-rt and libtkogfx under LGPL-2.1+ with the static-linking"
    say "exception -- with tiko-rt's provenance, FreeBASIC's own, and on Windows"
    say "mingw-w64's for the import libraries. This tree"
    say "redistributes binaries built from LGPL sources; distributing it"
    say "carries the source-offer obligation."
} > "$OUT/MANIFEST.txt"

note "manifest -> MANIFEST.txt"
note "ok -- $NFILES files, $SIZE"
