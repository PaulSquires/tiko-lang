#!/bin/sh
# build.sh -- build tiko-lang with the stage0 compiler (FBC-Modern).
#
#   build/build.sh [Debug|Release|RelWithDebInfo] [--test-runner]
#
# The Windows peer is build/build.bat and is kept line-for-line analogous.
# Configuration flags live here and nowhere else (docs/plan/02 section 3).

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
CFG=${1:-Debug}

# Executable suffix. Without this the script writes bin/tiko on Windows while
# everything else looks for bin/tiko.exe, and the stale .exe keeps being tested.
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOSTWIN=1; EXT=".exe" ;;
    *)                    HOSTWIN=0; EXT="" ;;
esac

# stage0: overridable, because the pinned commit moves at phase boundaries only.
if [ -z "$TKO_STAGE0" ]; then
    if [ "$HOSTWIN" = "1" ]; then
        TKO_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe"
    else
        TKO_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-linux/bin/fbc"
    fi
fi

if [ ! -x "$TKO_STAGE0" ]; then
    echo "build: stage0 compiler not found at $TKO_STAGE0" >&2
    echo "build: set TKO_STAGE0 to an FBC-Modern fbc" >&2
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

echo "build: tiko-lang [$CFG] with $TKO_STAGE0"
( cd "$ROOT" && "$TKO_STAGE0" $SOURCES -m "$MAINMOD" -i src $FLAGS -x "bin/tiko$EXT" )

if [ "$2" = "--test-runner" ] || [ "$1" = "--test-runner" ]; then
    echo "build: tiko-test [$CFG]"
    ( cd "$ROOT" && "$TKO_STAGE0" tools/tiko-test/tikotest.bas -i src $FLAGS -mt -x "bin/tiko-test$EXT" )
fi

# WHAT bin/ NOW HOLDS, for anything that needs to know whether it is the right thing.
# build/test.sh skips the build when nothing changed, and a timestamp alone cannot tell
# a Debug binary from a Release one: 'build.sh Release' leaves bin/tiko newer than every
# source, so the Debug suite would have run the Release binary and said nothing about it.
mkdir -p "$ROOT/build/obj"
printf '%s' "$CFG|$TKO_STAGE0" > "$ROOT/build/obj/.build-stamp"

echo "build: ok"
