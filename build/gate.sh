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
SRCLIB="$FBC_TREE/src/lib/$TARGET"
[ -d "$SRCLIB" ] || rt_die "no reference libs at $SRCLIB"

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
    win32)
        TC="$FBC_TREE/toolchains/fbc-modern-windows"
        export AS="$TC/bin/win32/as.exe" LD="$TC/bin/win32/ld.exe"
        export AR="$TC/bin/win32/ar.exe" GCC="$TC/bin/win32/gcc.exe"
        export DLLTOOL="$TC/bin/win32/dlltool.exe"
        TARGETOPT="-target win32"
        TARGETVAR="TARGET=win32"
        ;;
    linux-x86_64)
        rt_die "linux-x86_64 must run inside WSL, and needs libfbgfx*.a and
  libfbcunit.a built for Linux first. See fbc-modern/docs/tests/llvm/gate-linux.sh
  for the prerequisites. Not yet wired -- tracked in docs/tiko-rt/status/spike.md."
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
"$MAKE" -f unit-tests.mk clean > /dev/null 2>&1 || true
rm -f unit-tests.inc unit-tests-obj.lst
find . -name '*.o' -delete

echo "gate: $TARGET running fbc's unit-tests (this takes a while)"
"$MAKE" unit-tests $TARGETVAR \
    FBC="$GATE_FBC -i $FBC_TREE/src/inc $TARGETOPT $LIBOPT -gen gcc" \
    > "$LOG" 2>&1 || true

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
