#!/bin/sh
# diff.sh -- the differential tests, mechanised.
#
#   build/diff.sh [Debug|Release|RelWithDebInfo]
#
# Every program in tests/abi/ is compiled and run TWICE on the host target: once
# against fbc's stock runtime, once with tiko-rt's objects linked ahead of it.
# The two outputs must be byte-identical.
#
# WHY THIS SCRIPT EXISTS. These programs were written from the start, but they
# were RUN BY HAND, and the project's status notes said "7 differentials
# IDENTICAL" on the strength of that. A check that depends on someone
# remembering to run it is a check that silently lapses -- and this project has
# already recorded two cases of a stale artefact producing a believable number
# rather than an error. Now it is one command, and it fails loudly.
#
# HOW THE OVERRIDE WORKS -- no archive surgery, unlike gate.sh. tiko-rt's .o
# files are named explicitly on the fbc command line, so ld resolves fb_TRIM (and
# the rest) from them and never pulls fbc's corresponding member, which stays
# undisturbed on disk. That only works because fbc gives each of these entry
# points a member of its own; where it does not -- fb_SPACE shares str_misc.o
# with four ustring entry points -- the member would be pulled for its OTHER
# symbols and the link would fail on a duplicate. A duplicate-symbol error here
# is therefore information: it means the batch was sized by symbol when it should
# have been sized by member.
#
# HOST TARGET ONLY. These are RUN tests; win32 and Linux behaviour is covered by
# gate.sh, which executes fbc's own suite on each target.

set -e

. "$(dirname "$0")/common.sh"
rt_check_tools

CFG=${1:-Debug}
rt_cfg_flags "$CFG" > /dev/null || rt_die "unknown configuration '$CFG'"

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TARGET=win64 ;;
    *)                    TARGET=linux-x86_64 ;;
esac

OBJDIR="$RT_ROOT/obj/$TARGET/$CFG/st"
[ -d "$OBJDIR" ] || rt_die "no objects in $OBJDIR -- run build/build.sh $CFG first"

OBJS=$(ls "$OBJDIR"/*.o 2>/dev/null) || rt_die "no objects in $OBJDIR"

WORK="$RT_ROOT/obj/diff"
rm -rf "$WORK"; mkdir -p "$WORK"

pass=0
fail=0
skip=0

for src in "$RT_ROOT"/tests/abi/*.bas; do
    [ -e "$src" ] || continue
    name=$(basename "$src" .bas)

    # --wrap flags, DERIVED FROM THE SOURCE rather than listed here.
    #
    # alloc-count.bas and entry-count.bas count calls by interposing on the
    # allocator and on the entry points, which only links with the matching
    # --wrap options; without them ld cannot resolve __real_malloc and the
    # program does not build. The first version of this script SKIPPED both for
    # exactly that reason -- two of the most valuable tests in the suite, quietly
    # not running behind a green summary line. Reading the __real_ references out
    # of the source keeps flag and test together, so a new wrapper cannot forget
    # to bring its flag.
    # Stock: fbc's runtime, untouched.
    WRAP=""
    for sym in $(grep -oE '__real_[A-Za-z0-9_]+' "$src" | sed 's/^__real_//' | sort -u); do
        WRAP="$WRAP -Wl --wrap=$sym"
    done

    if ! "$TKORT_FBC" "$src" -x "$WORK/$name-stock.exe" $(rt_incflags) $WRAP \
            > "$WORK/$name-stock.build" 2>&1; then
        echo "diff: SKIP $name -- does not build against fbc's runtime" >&2
        sed 's/^/    /' "$WORK/$name-stock.build" >&2
        skip=$((skip + 1))
        continue
    fi

    # Merged: the same program, tiko-rt's objects ahead of the archive.
    if ! "$TKORT_FBC" "$src" -x "$WORK/$name-rt.exe" $(rt_incflags) $WRAP $OBJS \
            > "$WORK/$name-rt.build" 2>&1; then
        echo "diff: FAIL $name -- does not link over tiko-rt" >&2
        sed 's/^/    /' "$WORK/$name-rt.build" >&2
        fail=$((fail + 1))
        continue
    fi

    # A crash is a failure, not an empty output to be diffed against another
    # empty output. Both exit codes are recorded so that two matching crashes
    # cannot pass as "identical".
    "$WORK/$name-stock.exe" > "$WORK/$name-stock.out" 2>&1; echo "exit=$?" >> "$WORK/$name-stock.out"
    "$WORK/$name-rt.exe"    > "$WORK/$name-rt.out"    2>&1; echo "exit=$?" >> "$WORK/$name-rt.out"

    if [ ! -s "$WORK/$name-stock.out" ]; then
        echo "diff: FAIL $name -- stock run produced no output at all" >&2
        fail=$((fail + 1))
        continue
    fi

    if diff -u "$WORK/$name-stock.out" "$WORK/$name-rt.out" > "$WORK/$name.diff"; then
        pass=$((pass + 1))
    else
        echo "diff: FAIL $name" >&2
        head -40 "$WORK/$name.diff" >&2
        fail=$((fail + 1))
    fi
done

if [ $((pass + fail + skip)) -eq 0 ]; then
    rt_die "no differential programs found in tests/abi -- an empty pass is not a pass"
fi

echo "diff: $TARGET [$CFG] -- $pass identical, $fail differing, $skip skipped"

# A SKIP IS A HARNESS FAILURE, not a neutral outcome. Every program in tests/abi
# is meant to run; one that will not build against fbc's own runtime means the
# driver is wrong, and a green line reading "2 skipped" is how a suite quietly
# shrinks. Counted separately from $fail so the message says which kind of wrong.
[ "$fail" -eq 0 ] && [ "$skip" -eq 0 ]
