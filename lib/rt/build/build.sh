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
    rt_is_buildable "$t" || rt_die "unsupported target '$t' (R3: $RT_TARGETS $RT_BUILD_ONLY_TARGETS)"
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

        # THE ASSEMBLE STEP IS OURS WHEN THE TRIPLE IS NOT fbc's.
        #
        # fbc cannot be asked for the Microsoft ABI: llvmTriple( ) is a two-way
        # switch on the target with no MSVC branch, and -Wc does not reach the
        # -gen llvm clang call at all (hCompileStage2ModuleLlvm builds its own
        # option string and never appends extopt.gcc). Measured 2026-09-04.
        #
        # So -r stops fbc at the .ll -- it emits no object then, verified -- and
        # clang is called here with the triple we want. The .ll is NOT edited:
        # clang's --target overrides the module's own 'target triple' line, and
        # the resulting object is symbol-for-symbol identical to one built from a
        # rewritten .ll. RFC-0006 section 12.
        #
        # The clang line mirrors fbc's own, which is visible with -v:
        #   clang --target=<t> -march=x86-64 -O<n> -Wno-override-module x.ll -c -o x.o
        __ct=$(rt_clang_triple "$target")
        if [ -n "$__ct" ]; then
            __ll="${obj%.o}.ll"
            rm -f "$__ll"
            if ! "$TKORT_FBC" -c "$RT_ROOT/src/$src"                     -target "$(rt_fbc_target "$target")" -gen llvm -r $(rt_incflags)                     $FLAGS $mtdef $(rt_abi_define "$target") -o "$obj"; then
                rt_die "$target/$thread: $src failed to compile"
            fi
            [ -f "$__ll" ] || rt_die "$target/$thread: $src produced no .ll"
            if ! "$CLANG" --target="$__ct" -march=x86-64 "-O$(rt_opt_level "$CFG")"                     -Wno-override-module "$__ll" -c -o "$obj"; then
                rt_die "$target/$thread: $src failed to assemble for $__ct"
            fi
            rm -f "$__ll"
        elif ! "$TKORT_FBC" -c "$RT_ROOT/src/$src"                 -target "$target" -gen llvm $(rt_incflags)                 $FLAGS $mtdef -o "$obj"; then
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

        # A SOURCE THAT CONTRIBUTES NO GLOBAL SYMBOL SHIPPED NOTHING.
        #
        # src/error/errmsg.bas defined __fb_errmsg as a bare "dim shared" inside
        # an EXTERN "c" block, which FreeBASIC emits as a FILE-LOCAL symbol --
        # nm shows lowercase b, not B. tiko-rt's archive therefore still carried
        # an UNDEFINED reference to the name and fbc's own error_message.o kept
        # supplying it.
        #
        # ALL THREE EXISTING CHECKS PASSED. symbols.sh compares the names
        # tiko-rt DOES define, and an absent symbol is not a mismatch. gate.sh
        # deletes fbc's members BY SYMBOL, and there was none to delete. The
        # differential was reading fbc's buffer.
        #
        # A check that compares what was emitted cannot see what was not. This
        # one asks a different question: did this file put anything in the
        # archive at all.
        #
        # A MODULE THAT IS DELIBERATELY EMPTY ON SOME TARGETS MUST SAY SO, with
        # a marker naming them -- io/conprint.bas is the POSIX console writer and
        # is #ifdef-ed to nothing on Windows. The marker is what separates that
        # from a module that meant to define something and did not.
        ngl=$("$TKORT_NM" --defined-only "$obj" 2>/dev/null | awk '$2=="T"||$2=="D"||$2=="B"||$2=="R"' | wc -l)
        if [ "$ngl" -eq 0 ]; then
            # THE PLATFORM, NOT THE ABI. win64-msvc is win64 with a different
            # calling-convention-free ABI: the same files are empty on it for
            # the same reasons, and hinitposix.bas is empty on both because
            # neither is POSIX. Matching the full target name instead would
            # mean adding "win64-msvc" to every EMPTY-ON line in the tree, and
            # again to each one for any later ABI variant.
            __base=${target%-msvc}
            if grep -qE "EMPTY-ON:.*($target|$__base)" "$RT_ROOT/src/$src" 2>/dev/null; then
                : # declared empty for this target
            else
                echo "build: $src compiles to an object with NO GLOBAL SYMBOLS on $target." >&2
                echo "build: it is in build/sources.txt but contributes nothing to the archive." >&2
                echo "build: a data definition needs the EXTERN ... ALIAS declaration inside" >&2
                echo "build: an extern block AND the DIM SHARED outside it -- a bare" >&2
                echo "build: dim shared inside the block is file-local. See src/utf/core.bas." >&2
                echo "build: if the file is empty on this target BY DESIGN, add a comment" >&2
                echo "build: line naming them, e.g.   '' EMPTY-ON: win64" >&2
                rt_die "define something, mark it EMPTY-ON, or take it out of sources.txt"
            fi
        fi

        objs="$objs $obj"
    done

    # ------------------------------------------------------------ the C residue
    #
    # src/c/ is the closed list of files that stay C, each listed in its README
    # with a reason (RFC-0003 section 4, enforced by lint.sh). It was empty until
    # 2026-09-05 and so there was no C path here at all; the six members the gate
    # still takes from fbc are what made one necessary.
    #
    # CLANG, WITH THE SAME TRIPLE THE FreeBASIC MODULES GOT. For win64-msvc that
    # is the whole point: the FB half is retargeted at its assemble step above,
    # and a C object built for the gnu triple beside it would be the one thing in
    # the archive with the wrong ABI.
    #
    # NO fbc HEADERS ON THE INCLUDE PATH, deliberately. Anything here is tiko-rt's
    # own C written against a documented signature, not a transliteration of a
    # body (PROVENANCE.md), and reaching for fb.h is how the second kind starts.
    #
    # -O2 EVEN IN Debug. These are primitives -- an atomic wrapper compiled at -O0
    # is a call around a call -- and there is no tiko-rt source to step through in
    # them. -g is still passed so a backtrace names the file.
    for csrc in $(ls "$RT_ROOT"/src/c/*.c 2>/dev/null); do
        cobj="$objdir/$(basename "$csrc" .c).o"
        ctgt=$(rt_clang_triple "$target")
        [ -n "$ctgt" ] || ctgt=$(rt_target_triple "$target")
        # THE SAME ABI DEFINE THE FreeBASIC MODULES GET, spelled -D rather than -d.
        # A C file has no more way than a .bas one to tell win64 from win64-msvc:
        # fbc compiles both AS win64 and clang defines _MSC_VER for the msvc
        # triple only by accident of which headers it reaches for.
        cabi=""
        case "$target" in *-msvc) cabi="-D TKORT_MSVC" ;; esac
        if ! "$CLANG" --target="$ctgt" -O2 -g -std=c99 -Wall -Wextra $cabi \
                -c "$csrc" -o "$cobj"; then
            rt_die "$target/$thread: $(basename "$csrc") failed to compile"
        fi
        objs="$objs $cobj"
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
    #
    # __real@... and __xmm@... are excluded for exactly the same reason on the
    # MSVC ABI. Under the gnu triple a float constant is an anonymous .rdata
    # label; under msvc clang gives it a NAME derived from its bit pattern and
    # puts it in a COMDAT, so every module using 1.0 defines __real@3ff00...0
    # and the linker folds them. Anything else that collides is still a real
    # duplicate, which is the whole point of this check.
    "$TKORT_NM" --defined-only "$libdir/$archive" 2>/dev/null         | awk '($2=="T"||$2=="D"||$2=="B"||$2=="R") && $3 !~ /^\./ && $3 !~ /^__(real|xmm|ymm|zmm)@/{print $3}'         | sort | uniq -d > "$objdir/.dup.tmp"
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
