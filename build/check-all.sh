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
echo "check-all: done"
