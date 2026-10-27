#!/bin/bash
# The Linux battery, under WSLg, on BOTH SDL video drivers (X11 via XWayland, and Wayland).
# Run from Windows Git Bash:
#   MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tiko-lang/tkedit/tools/test-linux.sh [core]
# "core": only src/core's console suites (no app build, no window).
# Copies this checkout AND tkControls (the app's path dependency, ../../tkControls) into
# $HOME/tebuild/<hash of the checkout>/, keeping their relative layout: /mnt/c is slow, and the
# Linux and Windows builds must not share out/ or bin/. Never run it while the Windows battery
# runs: WSLg windows take the Windows focus (tkControls FINDINGS).
SRC=$(cd "$(dirname "$0")/.." && pwd)
TK=${TK_SRC:-$(cd "$SRC/../../tkControls" && pwd)}
TIKO=${TIKO:-/mnt/c/dev/tiko-lang/toolchains/tiko-linux/bin/tiko}
# SDL3 for Linux: Ubuntu ships none; tkControls' tools/build-linux-libs.sh builds linux-lib/.
LIB=${TK_LINUX_LIB:-/mnt/c/dev/tkControls/linux-lib}
W=$HOME/tebuild/$(echo "$SRC" | md5sum | cut -c1-10)
E=$W/tiko-lang/tkedit   # tkControls is two levels up from here, as on Windows
rm -rf "$W"; mkdir -p "$E" "$W/tkControls"
echo "source: $SRC + $TK  build: $W"
copy() {     # copy <from> <to>
    ( cd "$1" && tar --exclude='./out' --exclude='*/out' --exclude='*.exe' --exclude='*.dll' \
          --exclude='*.bmp' --exclude='./linux-lib*' --exclude='./.git' --exclude='./bin' -cf - . ) \
        | ( cd "$2" && tar -xf - )
}
copy "$SRC" "$E"
copy "$TK" "$W/tkControls"
mkdir -p "$E/bin"
export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir EGL_LOG_LEVEL=fatal LD_LIBRARY_PATH=$LIB
export TKO_MODCACHE=$W/modcache
bad=0

build() {    # build <package dir>
    local out
    if ! out=$(cd "$E/$1" && "$TIKO" build --options "-p $LIB" 2>&1); then
        echo "$1: BUILD FAILED"; echo "$out" | head -30; bad=$((bad+1)); return 1
    fi
    [ -n "$out" ] && { echo "$1: build printed output (warnings?)"; echo "$out" | head -30; bad=$((bad+1)); }
    return 0
}

run() {      # run <name> <dir> <driver> <command...>
    local name=$1 dir=$2 drv=$3; shift 3
    local res rc line
    res=$(cd "$dir" && SDL_VIDEO_DRIVER=$drv timeout -k 10 300 "$@" 2>&1 | grep -v ZINK); rc=${PIPESTATUS[0]}
    echo "$res" | grep -E '^FAIL' | head -20
    line=$(echo "$res" | grep -E ' selftest: ' | tail -1)
    echo "$name [$drv]: ${line:-no summary line} (exit $rc)"
    echo "$line" | grep -q ' 0 failed' || bad=$((bad+1))
}

if build src/core; then
    run coreall "$E/src/core" none ./tests/bin/coreall.exe
fi
if [ "${1:-}" != core ] && build src/app; then
    # the editor's Scintilla (tkCodeEdit/scintk/build.sh, under WSL) sits beside the program
    cp -f "$W/tkControls/tkCodeEdit/scintk/bin/linux/libscintk.so" "$E/bin/"
    # the self-test builds sample programs with this tiko (P4)
    export TKEDIT_TIKO=$TIKO
    # code intelligence (P5): tikoParser.so (tiko-lang build/build.sh --dll under Linux)
    TKP=${TIKOPARSER:-$HOME/tkpbuild/bin/tikoParser.so}
    [ -f "$TKP" ] && cp -f "$TKP" "$E/bin/"
    for drv in x11 wayland; do
        run tkEdit "$E/bin" $drv ./tkedit --selftest
    done
fi
echo "suite runs failed: $bad"
exit $bad
