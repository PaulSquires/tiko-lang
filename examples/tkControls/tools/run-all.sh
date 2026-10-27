#!/bin/bash
# The Windows battery: build every examples/tkControls/<Name> suite and run its selftest.
#   bash tools/run-all.sh                 all of them
#   bash tools/run-all.sh tkHost tkButton only these
# Prints one summary line per suite and exits with the number of suites that failed.
# The compiler is $TIKO, else the tree's bin/tiko.exe when built, else the toolchain's; either reads THIS
# tree's pkg/ (vendor/tkControls), whose vendor binaries build/vendorfetch.sh puts in place.
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TREE=$(cd "$ROOT/../.." && pwd)
if [ -z "$TIKO" ]; then
    TIKO=$TREE/bin/tiko.exe
    [ -x "$TIKO" ] || TIKO=$TREE/toolchains/tiko-windows/tiko.exe
    [ -x "$TIKO" ] || TIKO=tiko.exe     # a worktree has neither: set TIKO, or have it on PATH
fi
export TKO_PKG=${TKO_PKG:-$TREE/pkg}
# One tiko module cache PER CHECKOUT: parallel sessions must not share the per-user default.
export TKO_MODCACHE=${TKO_MODCACHE:-$ROOT/out/modcache}
names=("$@")
if [ ${#names[@]} -eq 0 ]; then
    for d in "$ROOT"/*/; do [ -f "$d/selftest.tiko" ] && names+=("$(basename "$d")"); done
fi
bad=0
for n in "${names[@]}"; do
    d="$ROOT/$n"
    [ -f "$d/tiko.toml" ] || { echo "$n: no examples/tkControls/$n/tiko.toml"; bad=$((bad+1)); continue; }
    if ! out=$(cd "$d" && "$TIKO" build 2>&1); then
        echo "$n: BUILD FAILED"; echo "$out" | head -20; bad=$((bad+1)); continue
    fi
    [ -n "$out" ] && { echo "$n: build output (warnings?)"; echo "$out" | head -20; }
    res=$(cd "$d" && timeout 300 ./selftest.exe 2>&1); rc=$?
    echo "$res" | grep -E '^FAIL' | head -20
    line=$(echo "$res" | grep -E ' selftest: ' | tail -1)
    echo "$n [windows]: ${line:-no summary line} (exit $rc)"
    [ $rc -eq 0 ] || bad=$((bad+1))
done
echo "suites failed: $bad"
exit $bad
