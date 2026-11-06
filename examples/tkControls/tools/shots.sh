#!/bin/bash
# One screenshot per control demo at a pinned scale, into out/shots/<Name>-<platform>.bmp.
#   bash tools/shots.sh                      Windows: the demos built in examples/tkControls/<Name>/
#   MSYS_NO_PATHCONV=1 wsl.exe -e bash /mnt/c/dev/tiko-lang/examples/tkControls/tools/shots.sh
#                                            Linux: the demos run-linux.sh built (Wayland)
# Then compare:  python tools/bmpdiff.py out/shots/X-windows.bmp out/shots/X-wayland.bmp
# Never run it while the other platform's battery runs: WSLg windows take the Windows focus.
SCALE=${SCALE:-1.75}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=$ROOT/out/shots
mkdir -p "$OUT"
if [ "$(uname -s)" = "Linux" ]; then
    W=$HOME/tkbuild/$(echo "$ROOT" | md5sum | cut -c1-10)
    [ -d "$W/examples/tkControls" ] || { echo "no Linux build in $W: run tools/run-linux.sh first"; exit 1; }
    LIB=${TK_LINUX_LIB:-}
    [ -d "$ROOT/linux-lib" ] && LIB=$ROOT/linux-lib
    export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir EGL_LOG_LEVEL=fatal TIKO_PKG=$W/pkg
    [ -n "$LIB" ] && export LD_LIBRARY_PATH=$LIB
    export SDL_VIDEO_DRIVER=${SDL_VIDEO_DRIVER:-wayland}
    TESTS=$W/examples/tkControls ; PLAT=$SDL_VIDEO_DRIVER
    # run-linux.sh may have built only some suites: build any missing demo (no selftests)
    TIKO=${TIKO:-/mnt/c/dev/tiko-lang/toolchains/tiko-linux/bin/tiko}
    export TIKO_MODCACHE=$W/modcache
    for d in "$TESTS"/*/; do
        [ -f "$d/demo.tiko" ] || continue
        [ -x "$d/demo.exe" ] && continue
        ( cd "$d" && "$TIKO" build demo ${LIB:+--options "-p $LIB"} >/dev/null 2>&1 ) || echo "$(basename "$d"): demo build failed"
    done
else
    TESTS=$ROOT ; PLAT=windows
fi
for d in "$TESTS"/*/; do
    n=$(basename "$d")
    [ -x "$d/demo.exe" ] || continue
    ( cd "$d" && timeout 60 ./demo.exe --shot "$OUT/$n-$PLAT.bmp" --scale "$SCALE" 2>&1 | grep -v ZINK | grep -E '^shot' ) \
        || echo "$n: no shot"
done
