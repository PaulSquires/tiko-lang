#!/bin/sh
# gate.sh -- run fbc's own unit-test suite against a tiko-rt runtime.
#
#   build/gate.sh <target> [--baseline] [logfile]
#
#   build/gate.sh win64 --baseline        S0a: the harness against the C runtime
#   build/gate.sh win64                   the real gate
#
# This is Gate 2 of docs/tiko-rt/RFC-0004 section 4, and it is the most valuable
# thing tiko-rt has: 2,715 test files and ~1.6M assertions, written by someone
# else, available on day one, long before tiko has a backend.
#
# NON-INVASIVE BY CONSTRUCTION
#
# fbc's -p searches a user library path BEFORE its own. Measured 2026-08-28: a
# deliberately corrupt libfb.a in a -p directory is what the linker picks up. So
# the gate builds its runtime into obj/gate/<target>/lib and points -p there.
# fbc-modern's lib/ tree is never written to. (The only thing this does touch is
# fbc's own tests/ directory, which is a build tree and is meant to be built in
# -- fbc-modern's gate-win.sh does the same.)
#
# THE PARTIAL-SLICE MERGE
#
# While tiko-rt implements only part of libfb, a bare tiko-rt archive cannot
# link: -l fb resolves to the FIRST libfb.a found, so the unimplemented symbols
# would simply be missing. The gate therefore builds a MERGED archive -- fbc's,
# with every member that defines a symbol tiko-rt also defines deleted, and
# tiko-rt's objects added. Deleting by member is what avoids duplicate-symbol
# errors, since our module names do not match the C ones.
#
# --baseline skips the merge entirely and runs a verbatim copy of fbc's archive
# through the identical path. If the baseline does not reproduce fbc's published
# numbers, the harness is wrong and nothing measured with it means anything.

set -eu

. "$(dirname "$0")/common.sh"
rt_check_tools

TARGET=${1:?usage: gate.sh <target> [--baseline] [logfile]}
rt_is_target "$TARGET" || rt_die "unsupported target '$TARGET' (R3: $RT_TARGETS)"
shift

BASELINE=0
if [ "${1:-}" = "--baseline" ]; then BASELINE=1; shift; fi
LOG=${1:-"$RT_ROOT/obj/gate/$TARGET/gate.log"}

MAKE=${MAKE:-$(command -v make || echo /c/dev/utils/mingw64/bin/make)}
[ -x "$MAKE" ] || rt_die "make not found (set MAKE)"

# The build-tree fbc, not the toolchain one: it is the only install that has
# libfb.a for all three targets. Standalone layout, so lib/<target>/.
GATE_FBC=${GATE_FBC:-"$FBC_TREE/src/fbc.exe"}
[ -x "$GATE_FBC" ] || rt_die "gate compiler not found at $GATE_FBC (set GATE_FBC)"
SRCLIB=$(rt_reflib "$TARGET") || rt_die "no reference libfb.a for $TARGET"

WORK="$RT_ROOT/obj/gate/$TARGET"
GATELIB="$WORK/lib"
rm -rf "$WORK"; mkdir -p "$GATELIB"
mkdir -p "$(dirname "$LOG")"

# ------------------------------------------------------ assemble the runtime

cp "$SRCLIB"/*.a "$GATELIB/"

if [ "$BASELINE" = "1" ]; then
    echo "gate: $TARGET BASELINE -- verbatim copy of fbc's runtime"
else
    for pair in "libfb.a st" "libfbmt.a mt"; do
        set -- $pair
        archive=$1; thread=$2
        objdir="$RT_ROOT/obj/$TARGET/${GATE_CFG:-Release}/$thread"
        [ -d "$objdir" ] || rt_die "no tiko-rt objects at $objdir -- run build/build.sh first"
        # STALENESS GUARD. gate.sh merges the ${GATE_CFG:-Release} objects; build.sh
        # and diff.sh default to Debug. Building Debug and then running the gate
        # therefore tests the PREVIOUS batch and reports a clean PASS for code that
        # was never linked -- which is exactly what happened on the run that
        # produced this check: two targets passed with "34 tiko-rt symbols, 15
        # members" while the tree held 38 and 19.
        #
        # A stale artefact never errors. It answers, plausibly, about something
        # else.
        newest_src=$(find "$RT_ROOT/src" -name '*.ba[si]' -newer "$objdir" -print -quit 2>/dev/null || true)
        if [ -n "$newest_src" ]; then
            rt_die "objects in $objdir are older than $newest_src
    the gate would merge the PREVIOUS batch and pass. Run:
        build/build.sh ${GATE_CFG:-Release}"
        fi

        objs=$(find "$objdir" -name '*.o' | sort)
        [ -n "$objs" ] || { echo "gate: no $thread objects yet, using fbc's $archive unchanged"; continue; }

        # Every symbol tiko-rt defines, and the fbc member that currently
        # defines it. Deleting those members is what makes the merge legal.
        #
        # NOTE THE FIELD NUMBERS. With --print-file-name, llvm-nm prints
        #     C:/path/libfb.a:swap_mem.o: 00000000 T fb_MemSwap
        # so the type is $3 and the NAME is $4 -- not $2/$3 as in plain output.
        # Getting that wrong finds no members to delete, llvm-ar then ADDS our
        # object alongside fbc's, and the archive ends up defining the symbol
        # TWICE. That does not error: ld takes the first member that satisfies
        # the reference, so the gate would run fbc's implementation and report a
        # clean pass for code that was never linked. Hence the check below.
        #
        # The member name is taken after ".a:" rather than by splitting on ":",
        # because a Windows path starts with a drive letter and a colon.
        ours=$("$TKORT_NM" --defined-only $objs | awk '$2=="T"||$2=="D"||$2=="B"{print $3}' | sort -u)
        victims=$("$TKORT_NM" --defined-only --print-file-name "$GATELIB/$archive" 2>/dev/null \
            | awk -v syms="$ours" '
                BEGIN { n=split(syms,a,"\n"); for(i=1;i<=n;i++) if(a[i]!="") want[a[i]]=1 }
                {
                    loc = $1; sub(/:$/, "", loc)
                    k = index(loc, ".a:")
                    m = (k > 0) ? substr(loc, k + 3) : loc
                    if (($3=="T" || $3=="D" || $3=="B") && ($4 in want)) print m
                }
              ' | sort -u)

        if [ -n "$victims" ]; then
            echo "$victims" | while read -r m; do
                [ -n "$m" ] && "$TKORT_AR" d "$GATELIB/$archive" "$m"
            done
        fi
        "$TKORT_AR" r "$GATELIB/$archive" $objs

        nsym=$(echo "$ours" | grep -c . || true)
        nvic=$(echo "$victims" | grep -c . || true)
        echo "gate: $TARGET $archive -- $nsym tiko-rt symbols, $nvic fbc members replaced"

        # THE CHECK THAT MAKES THE MERGE TRUSTWORTHY. Every symbol tiko-rt
        # defines must be defined EXACTLY ONCE in the merged archive. More than
        # once means the old implementation is still in there and may be the one
        # that links; a silent pass is the worst possible outcome here.
        dups=$("$TKORT_NM" --defined-only --print-file-name "$GATELIB/$archive" 2>/dev/null \
            | awk -v syms="$ours" '
                BEGIN { n=split(syms,a,"\n"); for(i=1;i<=n;i++) if(a[i]!="") want[a[i]]=1 }
                ($3=="T" || $3=="D" || $3=="B") && ($4 in want) { seen[$4]++ }
                END { for (s in seen) if (seen[s] != 1) printf "%s defined %d times\n", s, seen[s] }
              ')
        if [ -n "$dups" ]; then
            echo "gate: MERGE BROKEN -- the archive does not define tiko-rt's symbols exactly once:" >&2
            echo "$dups" | sed 's/^/    /' >&2
            exit 1
        fi
    done
fi

# ------------------------------------------------------------ target plumbing

TARGETOPT=""
LIBOPT="-p $GATELIB"
TARGETVAR=""
case "$TARGET" in
    linux-x86_64)
        # Runs inside WSL: the suite has to EXECUTE, and these are ELF binaries.
        # The merge above already produced ELF archives -- llvm-ar handles them
        # regardless of which host it runs on.
        #
        # libfbgfx*.a for Linux is present in fbc's tree. libfbcunit.a is NOT
        # per-target-safe: it is one file, rebuilt by whichever gate ran last, so
        # it may hold objects of the wrong architecture -- it used to be win32's,
        # and is now win64's.
        # `make` rebuilds it for whatever FBC it is handed, so the only thing
        # needed is to delete it first and let the Linux run regenerate it --
        # otherwise make sees an up-to-date archive of the wrong architecture and
        # the link fails with something that looks nothing like the cause.
        command -v wsl >/dev/null 2>&1 || rt_die "linux-x86_64 needs WSL"
        LINUX_FBC=${LINUX_FBC:-"$FBC_TREE/toolchains/fbc-modern-linux/bin/fbc"}
        # -f, not -x. The Linux fbc is an ELF binary that WSL runs; from Git Bash
        # on Windows it is a file with no execute bit, so -x rejects a perfectly
        # good compiler and blames the path.
        [ -f "$LINUX_FBC" ] || rt_die "no Linux fbc at $LINUX_FBC (set LINUX_FBC)"
        USE_WSL=1
        ;;
esac

# ------------------------------------------------------------------- run

cd "$FBC_TREE/src/tests"

# ---------------------------------------------------------------------- lock
#
# fbc's tests/ directory is a SHARED, MUTABLE resource: the gate compiles ~1,500
# objects into it. Two gates in it at once corrupt each other, and the way that
# surfaced was not a clash but a MISSING object -- an interrupted run's orphaned
# make and fbc processes kept writing .o files while the next run was deleting
# them, so make then judged half the tree up to date, skipped it, and the link
# died on "cannot find ./functions/array_recursion_str.o". Half the suite never
# compiled and no number was produced.
#
# Also worth stating because it applies to bench.sh too: nothing else may be
# running while a gate is. A run that shares the machine is not comparable to
# one that did not.
LOCK="$FBC_TREE/src/tests/.tiko-rt-gate.lock"
if ! ( set -o noclobber; echo "$$ $TARGET $(date)" > "$LOCK" ) 2>/dev/null; then
    rt_die "another gate is running (or died holding the lock):
  $(cat "$LOCK" 2>/dev/null)
  If no gate is running, remove $LOCK"
fi
trap 'rm -f "$LOCK"' EXIT INT TERM

# Clean FIRST, then drop the generated lists -- clean reads unit-tests.inc to
# know which objects to delete. Then delete any .o that survived anyway: a run
# whose numbers get compared to a published baseline may not link one stale
# object. A stale object yields a plausible NUMBER, never an error.
# ACTIVE-WRITER GUARD. Cleaning at startup cannot stop a writer that is already
# running, and the lock above only covers gates that reach it. A gate killed
# mid-run leaves an orphaned make/fbc behind, and if that orphan is the WSL one
# its processes carry Linux names -- `tasklist` shows nothing, so "the tree is
# quiet" looks true from Windows while ELF objects are still landing in it.
#
# That is not hypothetical: a win64 gate once linked ELF `tui/*.o` written by a
# killed Linux gate and died on undefined references to tcsetattr, ioctl and
# poll -- POSIX symbols, in a Windows link, from a project that had touched none
# of it. 740 objects and 132 executables had to be deleted by hand.
#
# So ask the TREE, not the process table: any object touched in the last half
# minute means something is still writing here.
recent=$(find . -name '*.o' -newermt '-30 seconds' -print -quit 2>/dev/null || true)
if [ -n "$recent" ]; then
    rt_die "something is still writing to $FBC_TREE/src/tests ($recent changed in the last 30s)
    a previous gate was probably killed and its make/fbc is still running.
    wait for it (WSL processes do not appear in tasklist), then re-run."
fi

"$MAKE" -f unit-tests.mk clean > /dev/null 2>&1 || true
rm -f unit-tests.inc unit-tests-obj.lst
find . -name '*.o' -delete

# AND THE EXECUTABLES. Deleting only the objects leaves fbc-tests / fbc-tests.exe
# behind, and a binary built for ANOTHER TARGET can then satisfy make. A win64
# gate run straight after a Linux one came out 22 compiles short of the usual
# 1,477 and died mid-summary with no message; re-run from a clean tree it passed
# with 1,477 and matched the baseline exactly. The failure was never diagnosed
# because it was never reproducible -- which is the point: it was discarded, not
# explained, and this is what stops the next one being born.
rm -f fbc-tests fbc-tests.exe

# THE TEST TREE MUST STILL BE COMPLETE.
#
# Something in the clean path -- make's own clean_tests does
# `cat unit-tests-obj.lst | xargs rm`, and this script deletes objects and
# executables besides -- removed two TRACKED SOURCE FILES during a run:
# quirk/inline-asm.bas and quirk/inline-asm-syntax.bas. The suite then built and
# ran happily with 5 fewer assertions and 2 fewer cases, on all three targets,
# and the only symptom was a summary differing from the baseline in a place with
# nothing to do with the code under test.
#
# A MISSING TEST CANNOT FAIL. Check the tree against git and restore anything
# that went missing, loudly: a silent restore would hide a recurring bug, and a
# silent absence is worse than either.
if git -C "$FBC_TREE" rev-parse --git-dir > /dev/null 2>&1; then
    missing=$(git -C "$FBC_TREE" ls-files --deleted -- src/tests 2>/dev/null || true)
    if [ -n "$missing" ]; then
        echo "gate: WARNING -- tracked files missing from the test tree, restoring:" >&2
        echo "$missing" | sed 's/^/    /' >&2
        if ! git -C "$FBC_TREE" checkout -- src/tests 2>/dev/null; then
            rt_die "could not restore them -- the suite would run short and the
    summary would differ for reasons unrelated to tiko-rt"
        fi
    fi
fi

echo "gate: $TARGET running fbc's unit-tests (this takes a while)"

if [ "${USE_WSL:-0}" = "1" ]; then
    # Windows paths become /mnt/c/... inside WSL. Everything else is the same
    # command; the suite is built and run by the Linux fbc against the merged
    # ELF archives.
    wpath( ) { echo "$1" | sed 's|^/\([a-zA-Z]\)/|/mnt/\1/|'; }
    W_TESTS=$(wpath "$FBC_TREE/src/tests")
    W_FBC=$(wpath "$LINUX_FBC")
    W_INC=$(wpath "$FBC_TREE/src/inc")
    W_LIB=$(wpath "$GATELIB")
    W_FBCBIN=$(wpath "$(dirname "$LINUX_FBC")")
    wsl -e bash -c "
        export PATH='$W_FBCBIN':\$PATH
        cd '$W_TESTS' || exit 1
        rm -f fbcunit/lib/libfbcunit.a
        make -f unit-tests.mk clean >/dev/null 2>&1 || true
        rm -f unit-tests.inc unit-tests-obj.lst
        find . -name '*.o' -delete
        rm -f fbc-tests fbc-tests.exe
        make unit-tests FBC='$W_FBC -i $W_INC -p $W_LIB -gen gcc'
    " > "$LOG" 2>&1 || true
else
    "$MAKE" unit-tests $TARGETVAR \
        FBC="$GATE_FBC -i $FBC_TREE/src/inc $TARGETOPT $LIBOPT -gen gcc" \
        > "$LOG" 2>&1 || true
fi

echo "gate: log $LOG"
echo "gate: fbc invocations: $(grep -ac 'fbc' "$LOG" || true)"

SUMMARY="$WORK/summary.txt"
sed -n '/SUMMARY/,$p' "$LOG" > "$SUMMARY"
REF="$RT_ROOT/tests/abi/baseline/$TARGET-gcc.summary"

if ! grep -q ' Total' "$SUMMARY"; then
    echo "gate: NO SUMMARY -- the run did not finish." >&2
    # Name the cause rather than leaving a 700-line log to read. A short
    # invocation count is the tell: the baseline run makes ~1,477 of them.
    echo "gate: fbc invocations: $(grep -ac 'fbc' "$LOG" || true) (a full run makes ~1,477)" >&2
    grep -iE 'cannot find|No such file|linking failed|\*\*\*' "$LOG" | head -8 | sed 's/^/    /' >&2
    echo "gate: full log $LOG" >&2
    exit 1
fi

echo "gate: $(grep ' Total' "$SUMMARY")"
echo "gate: failing suites:"
awk '$3+0>0 && $4!="Total"' "$SUMMARY" | sed 's/^/    /'

# --baseline writes the reference; every other run is judged against it.
#
# The reference is measured HERE rather than quoted from fbc-modern's
# BASELINE.md, which records 1,596,109 assertions for win64 as of 2026-08-11 and
# says outright that the totals move as the tree does. They have: this tree
# (2026-08-24) gives 4,890,432. What has NOT moved, and what the gate actually
# asserts, is the failure list -- 11, all threadcall, libffi absent.
if [ "$BASELINE" = "1" ]; then
    mkdir -p "$(dirname "$REF")"
    cp "$SUMMARY" "$REF"
    echo "gate: baseline written to $REF"
    exit 0
fi

[ -f "$REF" ] || rt_die "no baseline for $TARGET -- run: build/gate.sh $TARGET --baseline"

if diff -u "$REF" "$SUMMARY" > "$WORK/summary.diff"; then
    echo "gate: PASS -- identical to the baseline"
else
    echo "gate: DIFFERS from the baseline:" >&2
    head -60 "$WORK/summary.diff" >&2
    echo "gate: full diff in $WORK/summary.diff" >&2
    exit 1
fi
