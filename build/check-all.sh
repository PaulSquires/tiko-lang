#!/bin/sh
# check-all.sh -- the FULL gate, for a batch. Every configuration, every gate, the whole
# corpus, lint.
#
#   bash build/check-all.sh
#
# THE SWEEP AND THE GATES RUN CONCURRENTLY, which is safe and is most of the saving: the
# gates never rebuild -- they run bin/tiko.exe -- and they use their own scratch
# directories (build/.eol, build/.mg, build/.types), none of which the sweep touches. So
# the binary is built ONCE up front and the two long steps overlap, turning roughly
# seventeen minutes of waiting into about nine.
#
# TWO GATES EXIT NONZERO AT BASELINE -- check-ptr and check-intrin -- and that was
# established by rebuilding HEAD and re-running them, not assumed. Those two are named and
# allowed; ANY OTHER nonzero gate, a nonzero sweep, the rt lint or crosslink FAILS THE RUN.
# This script used to count and echo, and exit 0 whatever it found.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

bash build/build.sh Debug --test-runner
bash build/test.sh

bash build/mirsweep.sh > build/.sweep.log 2>&1 &
sweeppid=$!

fail=0
bad=0
for g in tools/gen/check-*.sh ; do
    grc=0
    sh "$g" >/dev/null 2>&1 || grc=$?
    if [ "$grc" = "77" ]; then
        echo "check-all: gate SKIPPED (no oracle fbc): $g"
    elif [ "$grc" != "0" ]; then
        echo "check-all: GATE NONZERO: $g"
        fail=$((fail + 1))
        case "$g" in
            */check-ptr.sh|*/check-intrin.sh) ;;
            *) bad=$((bad + 1)) ;;
        esac
    fi
done
echo "check-all: gates nonzero: $fail (baseline is 2 -- check-ptr and check-intrin)"

if ! wait $sweeppid ; then
    echo "check-all: FAILED: build/mirsweep.sh (build/.sweep.log)"
    bad=$((bad + 1))
fi
grep -E "statements not lowered|verify failures|scope imbalance" build/.sweep.log || true

bash build/build.sh Release
bash build/build.sh RelWithDebInfo
bash build/lint.sh
# THE RUNTIME'S OWN LINT, which nothing ran: it was red on master and nobody saw it.
if ! bash lib/rt/build/lint.sh ; then
    echo "check-all: FAILED: lib/rt/build/lint.sh"
    bad=$((bad + 1))
fi

# THE CROSSLINK SUITE. fbc's object and tiko-lang's, linked together and run --
# the one check here that is not tiko-lang talking to itself. It skips when the
# toolchain has not been packaged, because that is an environment gap rather than
# a regression, and a gate that fails for the wrong reason gets ignored.
crc=0
bash build/crosslink.sh || crc=$?
if [ "$crc" = "77" ]; then
    echo "check-all: crosslink SKIPPED -- that is not a pass"
elif [ "$crc" != "0" ]; then
    echo "check-all: FAILED: build/crosslink.sh"
    bad=$((bad + 1))
fi

# THE MICROSOFT-ABI GATE, and it was missing from here entirely -- windows-x86_64 is the
# DEFAULT Windows target, so the one configuration most users get was the one nothing
# ran fbc's suite against. It lives under lib/rt/build rather than tools/gen, so the
# glob above was never going to find it.
#
# OPTIONAL, exactly as crosslink.sh is: it needs an fbc built from source that
# understands '-z msvc' (the prebuilt toolchain predates it), clang, the generated
# import libraries and a windows-x86_64 archive of this configuration. Each of those is an
# environment gap rather than a regression, and TKORT_GATE_OPTIONAL turns the refusal
# into a SKIP that says which one is missing.
#
# It is the slowest thing here -- 726 modules, about seven minutes -- and it is worth
# it: 3.9 million assertions over the ABI that ships by default.
# OPT-IN, and it was not: running it here by default made check-all HANG.
#
# It builds 726 modules, and last in this script it forks them after mirsweep has
# already spawned one compilation per corpus file and the suite its own -- the MSYS
# process table is spent by then, and the child dies with 0xC0000142
# (STATUS_DLL_INIT_FAILED) while bash reports "fork: retry: Resource temporarily
# unavailable". Bash then RETRIES, so the failure presents as a hang rather than an
# error: forty-nine minutes with no output. Standalone the same gate passes in about
# seven minutes.
#
# Reordering it earlier would move the exhaustion to whatever ran last instead, so the
# honest fix is not to spend the fork table twice in one run. Set TIKO_GATE_MSVC=1 to
# include it, or run it directly -- which is the way it is actually used:
#
#     bash lib/rt/build/gatemsvc.sh Release
#
if [ "${TIKO_GATE_MSVC:-0}" = "1" ] ; then
    if ! TKORT_GATE_OPTIONAL=1 bash lib/rt/build/gatemsvc.sh Release ; then
        echo "check-all: GATE NONZERO: lib/rt/build/gatemsvc.sh"
        bad=$((bad + 1))
    fi
else
    echo "check-all: msvc gate not run (TIKO_GATE_MSVC=1 to include it)"
fi
if [ "$bad" -gt 0 ]; then
    echo "check-all: FAILED -- $bad step(s) beyond the baseline"
    exit 1
fi
echo "check-all: done"
