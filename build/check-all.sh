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
# established by rebuilding HEAD and re-running them, not assumed. The count is reported
# rather than the run failed, so a THIRD one is visible immediately.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

bash build/build.sh Debug --test-runner
bash build/test.sh

bash build/mirsweep.sh > build/.sweep.log 2>&1 &
sweeppid=$!

fail=0
for g in tools/gen/check-*.sh ; do
    if ! sh "$g" >/dev/null 2>&1 ; then
        echo "check-all: GATE NONZERO: $g"
        fail=$((fail + 1))
    fi
done
echo "check-all: gates nonzero: $fail (baseline is 2 -- check-ptr and check-intrin)"

wait $sweeppid || true
grep -E "statements not lowered|verify failures|scope imbalance" build/.sweep.log || true

bash build/build.sh Release
bash build/build.sh RelWithDebInfo
bash build/lint.sh

# THE CROSSLINK SUITE. fbc's object and tiko-lang's, linked together and run --
# the one check here that is not tiko-lang talking to itself. It skips when the
# toolchain has not been packaged, because that is an environment gap rather than
# a regression, and a gate that fails for the wrong reason gets ignored.
bash build/crosslink.sh

# THE MICROSOFT-ABI GATE, and it was missing from here entirely -- win64-msvc is the
# DEFAULT Windows target, so the one configuration most users get was the one nothing
# ran fbc's suite against. It lives under lib/rt/build rather than tools/gen, so the
# glob above was never going to find it.
#
# OPTIONAL, exactly as crosslink.sh is: it needs an fbc built from source that
# understands '-z msvc' (the prebuilt toolchain predates it), clang, the generated
# import libraries and a win64-msvc archive of this configuration. Each of those is an
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
# honest fix is not to spend the fork table twice in one run. Set TKO_GATE_MSVC=1 to
# include it, or run it directly -- which is the way it is actually used:
#
#     bash lib/rt/build/gatemsvc.sh Release
#
if [ "${TKO_GATE_MSVC:-0}" = "1" ] ; then
    if ! TKORT_GATE_OPTIONAL=1 bash lib/rt/build/gatemsvc.sh Release ; then
        echo "check-all: GATE NONZERO: lib/rt/build/gatemsvc.sh"
    fi
else
    echo "check-all: msvc gate not run (TKO_GATE_MSVC=1 to include it)"
fi
echo "check-all: done"
