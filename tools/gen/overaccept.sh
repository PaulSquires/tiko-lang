#!/bin/sh
# Every COMPILE_ONLY_FAIL file in the corpus is one fbc REFUSES. tiko-lang must refuse it
# too: a file that lowers with NO diagnostic is an OVER-ACCEPTANCE -- the divergence that
# loses nothing today and miscompiles tomorrow.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 1
# The packaged toolchain's headers -- the full set a user has -- not fbc-modern's.
export TKO_INCLUDE=${TKO_INCLUDE:-$(cd "$(dirname "$0")/../.." && pwd)/toolchains/tiko-windows/inc}
n=0; bad=0
for f in $(grep -rl "COMPILE_ONLY_FAIL" tests/vendor/fbc-tests --include='*.bas' | sort); do
    d=$(dirname "$f")
    out=$(./bin/tiko.exe -i tests/vendor/fbc-tests/fbcunit/inc -i "$d" --dump-ir "$f" 2>&1)
    n=$((n+1))
    if printf %s "$out" | grep -qE ": (error|fatal) TKO"; then continue; fi
    if printf %s "$out" | grep -qE "[1-9][0-9]* statements not lowered"; then continue; fi
    bad=$((bad+1))
    echo "OVER-ACCEPTED: $f"
done
echo "checked $n COMPILE_ONLY_FAIL files, $bad accepted with no diagnostic and no decline"
