#!/bin/bash
# The macOS battery (cocoa), run ON THE MAC from its tiko-lang checkout:
#   bash examples/tkControls/tools/run-mac.sh                 all of them
#   bash examples/tkControls/tools/run-mac.sh tkHost tkButton only these
# From Windows, as a script file through a login shell (Homebrew is not on a non-login PATH):
#   ssh mac zsh -l <script that runs this>
# Builds in place (the Mac checkout is its own clone, so out/ is never shared with Windows).
# The compiler is $TIKO, else the tree's bin/tiko (build/build.sh), else the toolchain's; either
# reads THIS tree's pkg/, whose vendor/tkControls fonts and libscintk.dylib build/vendorfetch.sh
# puts in place. SDL3 + SDL3_ttf + SDL3_image are Homebrew's (brew install sdl3 sdl3_ttf sdl3_image).
# The windows open on the logged-in desktop, so the Mac must be awake and unlocked.
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TREE=$(cd "$ROOT/../.." && pwd)
if [ -z "${TIKO:-}" ]; then
    TIKO=$TREE/bin/tiko
    [ -x "$TIKO" ] || TIKO=$TREE/toolchains/tiko-macos/bin/tiko
fi
export TKO_PKG=${TKO_PKG:-$TREE/pkg}
# a tree-built compiler links against the toolchain's libraries, which it does not find alone
if [ -z "${TKO_LIBPATH:-}" ] && [ -d "$TREE/toolchains/tiko-macos/lib/macos-arm64" ]; then
    export TKO_LIBPATH=$TREE/toolchains/tiko-macos/lib/macos-arm64
fi
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
    # Homebrew's bottles are built for a newer macOS than tiko's 13.0 minimum: ld64 warns once per dylib
    out=$(echo "$out" | grep -v -E "building for macOS-13\.0, but linking with dylib")
    [ -n "$out" ] && { echo "$n: build output (warnings?)"; echo "$out" | head -20; }
    # macOS has no timeout(1): perl's alarm ends a hung selftest
    res=$(cd "$d" && perl -e 'alarm 300; exec @ARGV' ./selftest.exe 2>&1); rc=$?
    echo "$res" | grep -E '^FAIL' | head -20
    line=$(echo "$res" | grep -E ' selftest: ' | tail -1)
    echo "$n [macos]: ${line:-no summary line} (exit $rc)"
    [ $rc -eq 0 ] || bad=$((bad+1))
done
echo "suites failed: $bad"
exit $bad
