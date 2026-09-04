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

# The members tiko-rt replaces, DERIVED from the objects rather than listed.
#
# This was a hand-maintained list of ten names. tiko-rt reached nineteen members
# and the list did not, so the "clang baseline" rebuilt ten of them and left nine
# gcc-built -- reintroducing, in exactly nine members, the gcc-versus-clang
# confound this script exists to remove. It reported "10 members rebuilt" every
# time, and nothing else looked wrong.
#
# The mapping is the one gate.sh already performs: every symbol tiko-rt defines,
# resolved to the fbc member that currently defines it. Same derivation, same
# answer, and it cannot drift from what the gate actually replaces.
#
# Release objects, because Release is what the gate merges.
CB_CFG=${CB_CFG:-Release}
CB_OBJDIR="$RT_ROOT/obj/$TARGET/$CB_CFG/st"
[ -d "$CB_OBJDIR" ] || rt_die "no tiko-rt objects at $CB_OBJDIR -- run build/build.sh $CB_CFG first"
CB_OBJS=$(find "$CB_OBJDIR" -name '*.o' | sort)
[ -n "$CB_OBJS" ] || rt_die "no objects in $CB_OBJDIR"

CB_REFLIB=$(rt_reflib "$TARGET") || rt_die "no reference libfb.a for $TARGET"

CB_SYMS=$("$TKORT_NM" --defined-only $CB_OBJS | awk '$2=="T"||$2=="D"||$2=="B"{print $3}' | sort -u)
MEMBERS=$("$TKORT_NM" --defined-only --print-file-name "$CB_REFLIB/libfb.a" 2>/dev/null \
    | awk -v syms="$CB_SYMS" '
        BEGIN { n=split(syms,a,"\\n"); for(i=1;i<=n;i++) if(a[i]!="") want[a[i]]=1 }
        {
            loc = $1; sub(/:$/, "", loc)
            k = index(loc, ".a:")
            m = (k > 0) ? substr(loc, k + 3) : loc
            if (($3=="T" || $3=="D" || $3=="B") && ($4 in want)) { sub(/\.o$/, "", m); print m }
        }' | sort -u | tr '\n' ' ')

[ -n "$MEMBERS" ] || rt_die "derived an empty member list -- the mapping is broken, and an
    empty baseline is fbc unchanged wearing the name of a baseline"

# fbc's own rtlib flags (src/makefile:179-181), minus the warning options: a
# diagnostic here would quote source text, which PROVENANCE.md has no reason to
# put in front of anyone.
CFL="-O2 -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -w"

OUT="$RT_ROOT/obj/cbase/$TARGET"
rm -rf "$OUT"; mkdir -p "$OUT/st" "$OUT/mt" "$OUT/lib"

echo "cbase: rebuilding fbc's own members with clang for $TRIPLE"
# THE SOURCE IS NOT ALWAYS AT THE RTLIB ROOT. Per-target members live under
# win32/ or unix/ or linux/, and the member NAME does not say which -- fbc's
# makefile knows the mapping and the archive does not. So the source is searched
# for, in the same order fbc's own build prefers: the target's own directory
# first, then the shared POSIX one, then the root.
#
# The first version of this loop looked only at the root and died on
# drv_intl_get.c, which is win32/drv_intl_get.c. Every per-target member tiko-rt
# has replaced since -- the whole locale layer, file_dir, the sys_* singletons --
# would have hit the same wall.
case "$TARGET" in
    win64|win32)  CB_DIRS="win32 ." ;;
    linux-x86_64) CB_DIRS="linux unix ." ;;
    *)            CB_DIRS="." ;;
esac

cb_find_src() {
    for d in $CB_DIRS; do
        if [ -f "$RTLIB/$d/$1.c" ]; then
            printf '%s
' "$RTLIB/$d/$1.c"
            return 0
        fi
    done
    return 1
}

for m in $MEMBERS; do
    src=$(cb_find_src "$m") || rt_die "no source for member $m.c under $RTLIB (searched: $CB_DIRS)"
    for thread in st mt; do
        case $thread in st) mtdef="" ;; mt) mtdef="-DENABLE_MT" ;; esac
        "$CLANG" --target="$TRIPLE" $CFL $mtdef -I "$RTLIB" \
            -c "$src" -o "$OUT/$thread/$m.o" \
            || rt_die "clang failed on $m.c ($thread) -- rerun by hand if the reason matters"
    done
done

# The baseline archive: fbc's own, with exactly those members swapped for the
# clang-built ones. Identical content, one compiler changed.
REFDIR=$(rt_reflib "$TARGET") || rt_die "no reference libfb.a for $TARGET"
cp "$REFDIR"/*.a "$OUT/lib/"
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
