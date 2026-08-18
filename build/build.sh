#!/bin/sh
# build.sh -- build fbx with the stage0 compiler (FBC-Modern).
#
#   build/build.sh [Debug|Release|RelWithDebInfo] [--test-runner]
#
# The Windows peer is build/build.bat and is kept line-for-line analogous.
# Configuration flags live here and nowhere else (docs/plan/02 section 3).

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
CFG=${1:-Debug}

# Executable suffix. Without this the script writes bin/fbx on Windows while
# everything else looks for bin/fbx.exe, and the stale .exe keeps being tested.
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOSTWIN=1; EXT=".exe" ;;
    *)                    HOSTWIN=0; EXT="" ;;
esac

# stage0: overridable, because the pinned commit moves at phase boundaries only.
if [ -z "$FBX_STAGE0" ]; then
    if [ "$HOSTWIN" = "1" ]; then
        FBX_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe"
    else
        FBX_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-linux/bin/fbc"
    fi
fi

if [ ! -x "$FBX_STAGE0" ]; then
    echo "build: stage0 compiler not found at $FBX_STAGE0" >&2
    echo "build: set FBX_STAGE0 to an FBC-Modern fbc" >&2
    exit 3
fi

case "$CFG" in
    Debug)          FLAGS="-g -exx -w all" ;;
    RelWithDebInfo) FLAGS="-g -w all" ;;
    Release)        FLAGS="-w all" ;;
    *) echo "build: unknown configuration '$CFG'" >&2; exit 2 ;;
esac

# The first entry of sources.txt is the main module; -m makes that explicit so the
# runtime initialises the command line before any module constructor runs.
SOURCES=$(grep -v '^[[:space:]]*#' "$ROOT/build/sources.txt" | grep -v '^[[:space:]]*$')
MAIN=$(echo "$SOURCES" | head -1)
MAINMOD=$(basename "$MAIN" .bas)

mkdir -p "$ROOT/bin" "$ROOT/build/obj/$CFG"

echo "build: fbx [$CFG] with $FBX_STAGE0"
( cd "$ROOT" && "$FBX_STAGE0" $SOURCES -m "$MAINMOD" -i src $FLAGS -x "bin/fbx$EXT" )

if [ "$2" = "--test-runner" ] || [ "$1" = "--test-runner" ]; then
    echo "build: fbx-test [$CFG]"
    ( cd "$ROOT" && "$FBX_STAGE0" tools/fbx-test/fbxtest.bas -i src $FLAGS -x "bin/fbx-test$EXT" )
fi

echo "build: ok"
