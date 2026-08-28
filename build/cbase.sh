#!/bin/sh
# cbase.sh -- build the CLANG baseline that Gate 4 has to be measured against.
#
#   build/cbase.sh [target]
#
# WHY THIS EXISTS
#
# fbc builds its own libfb.a with **gcc** at -O2 (src/makefile:179). tiko-rt goes
# through -gen llvm to **clang** at -O2. Same optimisation level, different
# compiler -- so a benchmark between them contains a gcc-versus-clang difference
# on the runtime itself, and RFC-0004 section 2's claim ("the same compiler, the
# same optimiser") is true of the IR path and NOT of the baseline.
#
# Left uncorrected, the honest reading of Gate 4 is only "FreeBASIC through clang
# beats C through gcc", which is not the question the spike exists to answer.
#
# WHAT IT BUILDS
#
# Only the members tiko-rt actually replaces. Everything else in both archives is
# the same gcc-built code, so rebuilding just these five isolates the compiler
# exactly -- and is minutes rather than a full rtlib build.
#
# This is D13's plan applied to the baseline: the runtime rebuilt with clang.
#
# PROVENANCE
#
# Compiling a file is not reading it. No .c body is opened here and none needs to
# be; the sources are named, handed to clang, and the objects are what is used.
# Warnings are suppressed with -w deliberately: a diagnostic would quote source
# lines, and there is no reason to put those on screen. See PROVENANCE.md.

set -eu

. "$(dirname "$0")/common.sh"
rt_check_tools

TARGET=${1:-win64}
rt_is_target "$TARGET" || rt_die "unsupported target '$TARGET'"

RTLIB="$FBC_TREE/src/src/rtlib"
[ -d "$RTLIB" ] || rt_die "fbc's rtlib sources not found at $RTLIB"

case "$TARGET" in
    win64)        TRIPLE=x86_64-w64-windows-gnu ;;
    win32)        TRIPLE=i686-w64-windows-gnu ;;
    linux-x86_64) TRIPLE=x86_64-pc-linux-gnu ;;
esac

# The members tiko-rt replaces, and the sources they come from.
MEMBERS="swap_mem mem_copyclear list listdyn str_core"

# fbc's own rtlib flags (src/makefile:179-181), minus the warning options: a
# diagnostic here would quote source text, which PROVENANCE.md has no reason to
# put in front of anyone.
CFL="-O2 -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -w"

OUT="$RT_ROOT/obj/cbase/$TARGET"
rm -rf "$OUT"; mkdir -p "$OUT/st" "$OUT/mt" "$OUT/lib"

echo "cbase: rebuilding fbc's own members with clang for $TRIPLE"
for m in $MEMBERS; do
    src="$RTLIB/$m.c"
    [ -f "$src" ] || rt_die "missing source $src"
    for thread in st mt; do
        case $thread in st) mtdef="" ;; mt) mtdef="-DENABLE_MT" ;; esac
        "$CLANG" --target="$TRIPLE" $CFL $mtdef -I "$RTLIB" \
            -c "$src" -o "$OUT/$thread/$m.o" \
            || rt_die "clang failed on $m.c ($thread) -- rerun by hand if the reason matters"
    done
done

# The baseline archive: fbc's own, with exactly those members swapped for the
# clang-built ones. Identical content, one compiler changed.
cp "$FBC_TREE/src/lib/$TARGET"/*.a "$OUT/lib/"
for pair in "libfb.a st" "libfbmt.a mt"; do
    set -- $pair
    archive=$1; thread=$2
    for m in $MEMBERS; do
        "$TKORT_AR" d "$OUT/lib/$archive" "$m.o" 2>/dev/null || true
    done
    for m in $MEMBERS; do
        "$TKORT_AR" r "$OUT/lib/$archive" "$OUT/$thread/$m.o"
    done
    n=$("$TKORT_NM" --defined-only "$OUT/lib/$archive" 2>/dev/null | grep -c ' T ' || true)
    echo "cbase: $archive -- $(echo $MEMBERS | wc -w) members rebuilt, $n text symbols"
done

echo "cbase: baseline at $OUT/lib"
echo "cbase: use it with   CBASE=$OUT/lib build/bench.sh $TARGET"
