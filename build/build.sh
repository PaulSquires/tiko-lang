#!/bin/sh
# build.sh -- build tiko-rt's archives with FBC-Modern.
#
#   build/build.sh [Debug|Release|RelWithDebInfo] [target ...]
#
#   build/build.sh                       Debug, all three targets, st and mt
#   build/build.sh Release win64         Release, win64 only
#   build/build.sh Debug linux-x86_64
#
# Produces  lib/<target>/libfb.a   (single-threaded)
#           lib/<target>/libfbmt.a (ENABLE_MT)
#
# Both come from ONE source tree, distinguished by -d ENABLE_MT, exactly as the
# C runtime's two builds do.
#
# The archive names are deliberately fbc's own: that is what makes build/gate.sh
# able to drop tiko-rt into fbc's link line and run fbc's suite unmodified
# (docs/tiko-rt/RFC-0001 section 4.1).

set -e

. "$(dirname "$0")/common.sh"
rt_check_tools

CFG=${1:-Debug}
FLAGS=$(rt_cfg_flags "$CFG") || rt_die "unknown configuration '$CFG' (Debug|Release|RelWithDebInfo)"
shift 2>/dev/null || true

TARGETS=${*:-$RT_TARGETS}
for t in $TARGETS; do
    rt_is_target "$t" || rt_die "unsupported target '$t' (R3: $RT_TARGETS)"
done

SOURCES=$(rt_sources)

build_one( ) {
    target=$1
    thread=$2                       # st | mt
    case $thread in
        st) archive=libfb.a;   mtdef="" ;;
        mt) archive=libfbmt.a; mtdef="-d ENABLE_MT" ;;
    esac

    objdir="$RT_ROOT/obj/$target/$CFG/$thread"
    libdir="$RT_ROOT/lib/$target"
    rm -rf "$objdir"
    mkdir -p "$objdir" "$libdir"

    # THE ARCHIVE IS REMOVED BEFORE THE COMPILE, NOT AFTER IT.
    #
    # build.sh already exits non-zero when a compile fails (verified by planting
    # one), but it used to leave the PREVIOUS run's archive sitting in lib/, so
    # anything reading it afterwards saw a complete, valid, stale library.
    #
    # That is not hypothetical: a linux-only failure in strw/case.bas let
    # build/symbols.sh report "912 symbol names identical" for a tree that had
    # just failed to build, because the caller piped build.sh through `tail` and
    # `&&` then saw the PIPE's exit status rather than the build's.
    #
    # Removing the archive first makes the failure impossible to read past --
    # every downstream tool dies with "no archive" instead of agreeing with a
    # library nobody just built. Fifth stale-artefact incident here, and the
    # same shape as the other four.
    rm -f "$libdir/$archive"

    # A stale object yields a plausible archive, never an error, so the object
    # directory is removed above rather than reused.
    objs=""
    for src in $SOURCES; do
        obj="$objdir/$(echo "$src" | tr '/' '_' | sed 's/\.bas$/.o/')"
        "$TKORT_FBC" -c "$RT_ROOT/src/$src" \
            -target "$target" -gen llvm $(rt_incflags) \
            $FLAGS $mtdef -o "$obj"
        objs="$objs $obj"
    done

    if [ -z "$objs" ]; then
        # S0: no modules yet. An archive with no members is still a valid
        # archive and still proves the whole toolchain path works.
        "$TKORT_AR" rcs "$libdir/$archive"
    else
        "$TKORT_AR" rcs "$libdir/$archive" $objs
    fi

    n=$("$TKORT_NM" --defined-only "$libdir/$archive" 2>/dev/null | grep -c ' T ' || true)
    echo "build: $target/$archive [$CFG] -- $(echo $objs | wc -w) objects, $n text symbols"
}

echo "build: tiko-rt [$CFG] with $TKORT_FBC"
for target in $TARGETS; do
    build_one "$target" st
    build_one "$target" mt
done
echo "build: ok"
