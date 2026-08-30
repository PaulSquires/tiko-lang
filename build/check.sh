#!/bin/sh
# check.sh -- the FAST gate, for one change. Debug build, the test suite, lint.
#
#   bash build/check.sh
#   MIRSWEEP_CORPUS=tests/vendor/fbc-tests/structs bash build/check.sh   # + a scoped sweep
#
# WHY THIS EXISTS. The full validation -- three configurations, all seventeen gates and
# the whole-corpus sweep -- is about twenty minutes, and running it per change bought
# almost nothing: over one session's nine full sweeps, eight printed an identical count
# and the ninth caught a real regression that the SUITE had already caught in three
# minutes. The suite is where the signal is per minute; the sweep and the gates are
# batch checks.
#
# So: this before every commit, build/check-all.sh before the batch lands. This does NOT
# replace check-all.sh -- a clean run here is not evidence the corpus or the gates are
# unmoved, and it does not build Release or RelWithDebInfo.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

bash build/build.sh Debug --test-runner
bash build/test.sh

# A SCOPED SWEEP ONLY WHEN ASKED. Its count is the SUBSET's and is not comparable to the
# whole-corpus baseline -- it answers 'did this change do what I meant in this corner',
# nothing wider.
if [ -n "$MIRSWEEP_CORPUS" ] ; then
    echo "check: scoped sweep over $MIRSWEEP_CORPUS"
    bash build/mirsweep.sh 2>&1 | grep -E "statements not lowered|verify failures|scope imbalance"
fi

bash build/lint.sh
echo "check: ok"
