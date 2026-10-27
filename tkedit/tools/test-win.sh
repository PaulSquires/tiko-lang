#!/bin/bash
# The Windows battery: build every package, run every self-test.
#   bash tools/test-win.sh [core]       "core": only src/core's console suites
# A build that prints anything (a warning) counts as a failure: zero warnings is the bar.
# Prints one summary line per suite and exits with the number of suites that failed.
TIKO=${TIKO:-/c/dev/tiko-lang/toolchains/tiko-windows/tiko.exe}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
# One tiko module cache PER CHECKOUT: parallel sessions must not share the per-user default.
export TKO_MODCACHE=${TKO_MODCACHE:-$ROOT/out/modcache}
bad=0

build() {    # build <package dir>
    local out
    if ! out=$(cd "$ROOT/$1" && "$TIKO" build 2>&1); then
        echo "$1: BUILD FAILED"; echo "$out" | head -30; bad=$((bad+1)); return 1
    fi
    [ -n "$out" ] && { echo "$1: build printed output (warnings?)"; echo "$out" | head -30; bad=$((bad+1)); }
    return 0
}

run() {      # run <name> <dir> <command...>
    local name=$1 dir=$2; shift 2
    local res rc line
    res=$(cd "$dir" && timeout -k 10 300 "$@" 2>&1); rc=$?
    echo "$res" | grep -E '^FAIL' | head -20
    line=$(echo "$res" | grep -E ' selftest: ' | tail -1)
    echo "$name [windows]: ${line:-no summary line} (exit $rc)"
    [ $rc -eq 0 ] || bad=$((bad+1))
}

# the editor's Scintilla (tkControls' scintk, built by tkCodeEdit/scintk/build.sh) sits beside the exe
SCINTK=${SCINTK:-$ROOT/../../tkControls/tkCodeEdit/scintk/bin/windows/scintk.dll}

build src/core && run coreall "$ROOT/src/core" ./tests/bin/coreall.exe
if [ "${1:-}" != core ] && build src/app; then
    cp -f "$SCINTK" "$ROOT/bin/"
    # code intelligence (P5): tikoParser.dll (tiko-lang build/build.sh Release --dll)
    TKP=${TIKOPARSER:-/c/dev/tiko-editor-tiko/tikoParser.dll}
    [ -f "$TKP" ] && cp -f "$TKP" "$ROOT/bin/"
    # the self-test builds sample programs with this tiko (P4; a Windows path for the program)
    export TKEDIT_TIKO=$(cygpath -w "$TIKO")
    run tkEdit "$ROOT/bin" ./tkedit.exe --selftest
fi
echo "suites failed: $bad"
exit $bad
