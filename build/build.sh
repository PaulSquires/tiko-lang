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
    REFLIB=""
    _refdir=$(rt_reflib "$target" 2>/dev/null || true)
    if [ -n "$_refdir" ] && [ -f "$_refdir/libfb.a" ]; then
        REFLIB="$_refdir/libfb.a"
    fi

    objs=""
    for src in $SOURCES; do
        obj="$objdir/$(echo "$src" | tr '/' '_' | sed 's/\.bas$/.o/')"

        if ! "$TKORT_FBC" -c "$RT_ROOT/src/$src"                 -target "$target" -gen llvm $(rt_incflags)                 $FLAGS $mtdef -o "$obj"; then
            rt_die "$target/$thread: $src failed to compile"
        fi
        [ -f "$obj" ] || rt_die "$target/$thread: $src produced no object"

        # A NAME COLLISION WITH AN fbc MEMBER MUST NOT LOSE SYMBOLS.
        #
        # Objects are named after their source path -- io/input.bas became
        # io_input.o -- and gate.sh merges them INTO fbc's archive, so llvm-ar
        # REPLACES any member of the same name. fbc has an io_input.o of its own,
        # and the merge dropped fb_hConsoleGetKey, fb_ConsoleHasFocus and five
        # more that this project does not define.
        #
        # IT WAS SILENT ON ALL THREE TARGETS. win64 and win32 passed the whole
        # 2,715-file suite with that member gone; only linux-x86_64 failed, and
        # only because time_sleep.c happens to reference one of the lost symbols
        # there.
        #
        # Replacing a member IS the point of the port -- str/core.bas becomes
        # str_core.o and supplies all ten of its symbols. What must never happen
        # is replacing one by NAME while leaving some of its symbols undefined.
        # So the test is not "does the name collide" but "does the collision lose
        # anything".
        objname=$(basename "$obj")
        if [ -n "$REFLIB" ] && "$TKORT_AR" t "$REFLIB" 2>/dev/null | grep -qx "$objname"; then
            "$TKORT_NM" --defined-only "$obj" 2>/dev/null                 | awk '$2=="T"||$2=="D"||$2=="B"{print $3}' | sort -u > "$objdir/.ours.tmp"
            "$TKORT_NM" --defined-only "$REFLIB" 2>/dev/null                 | awk -v m="$objname" '/:$/{c=$0; sub(":","",c)} c==m && ($2=="T"||$2=="D"||$2=="B"){print $3}'                 | sort -u > "$objdir/.theirs.tmp"
            missing=$(comm -23 "$objdir/.theirs.tmp" "$objdir/.ours.tmp" | head -5)
            rm -f "$objdir/.ours.tmp" "$objdir/.theirs.tmp"
            if [ -n "$missing" ]; then
                echo "build: $src compiles to $objname, an fbc member name," >&2
                echo "build: so the gate's merge would REPLACE it -- losing:" >&2
                echo "$missing" | sed 's/^/    /' >&2
                rt_die "rename the source, or define those symbols too"
            fi
        fi

        objs="$objs $obj"
    done

    if [ -z "$objs" ]; then
        # S0: no modules yet. An archive with no members is still a valid
        # archive and still proves the whole toolchain path works.
        "$TKORT_AR" rcs "$libdir/$archive"
    else
        "$TKORT_AR" rcs "$libdir/$archive" $objs
    fi

    # ONE SYMBOL, ONE MEMBER. ar will happily archive two objects that define
    # the same symbol; nothing complains until a LINK, and by then the message
    # names .ll files rather than the two sources. This caught a whole family
    # reimplemented in a second file when it already existed in a first -- the
    # archive built clean, the symbol count went UP by the duplicate count, and
    # it looked like progress.
    #
    # Names beginning with '.' are excluded: .refptr.__fb_ctx and friends are
    # COMDAT thunks the backend emits ONCE PER OBJECT THAT REFERENCES THE
    # SYMBOL, so they are duplicated by design and the linker folds them.
    "$TKORT_NM" --defined-only "$libdir/$archive" 2>/dev/null         | awk '($2=="T"||$2=="D"||$2=="B"||$2=="R") && $3 !~ /^\./{print $3}'         | sort | uniq -d > "$objdir/.dup.tmp"
    if [ -s "$objdir/.dup.tmp" ]; then
        echo "build: $target/$archive defines these symbols TWICE:" >&2
        sed 's/^/    /' "$objdir/.dup.tmp" >&2
        echo "tiko-rt: a second module reimplements something already present" >&2
        rm -f "$objdir/.dup.tmp" "$libdir/$archive"
        exit 1
    fi
    rm -f "$objdir/.dup.tmp"

    n=$("$TKORT_NM" --defined-only "$libdir/$archive" 2>/dev/null | grep -c ' T ' || true)
    echo "build: $target/$archive [$CFG] -- $(echo $objs | wc -w) objects, $n text symbols"
}

echo "build: tiko-rt [$CFG] with $TKORT_FBC"
for target in $TARGETS; do
    build_one "$target" st
    build_one "$target" mt
done
echo "build: ok"
