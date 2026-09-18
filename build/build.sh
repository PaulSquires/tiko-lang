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
    # -O 2 like everything else in this tree. Release passed no optimization flag at
    # all, so the shipped compiler was built at fbc's default -- which is -O 0 --
    # while lib/rt's Release is "-O 2 -w all" and lib/gfx's is OPT=2. The compiler
    # was the only piece not optimized in its own release build.
    #
    # NOT "-O s". fbc ACCEPTS it and silently does nothing: measured on a 3600-line
    # program, "-O s" produced 132,608 bytes, byte for byte what no flag at all
    # produces, while "-O 2" gave 99,328. Real size optimization needs the gcc
    # backend ("-gen gcc -Wc -Os", 84,480), which is a backend change, not a flag.
    Release)        FLAGS="-O 2 -w all" ;;
    # SIZE, AND IT IS A BACKEND CHANGE. '-O s' is not the answer -- measured on
    # this compiler, 2026-09-17: '-O 2' gives 1,781,760 bytes, '-O s' gives
    # 10,202,624, and passing NO optimization flag at all gives 10,202,624 as
    # well, byte for byte. fbc accepts '-O s' and drops it on the floor: on
    # '-gen llvm' it reaches clang as '-O0', measured the same day. So asking for
    # size with it does not merely fail to shrink the binary, it makes it 5.7
    # times bigger than Release.
    #
    # The gcc backend takes '-Wc -Os' and means it: 1,532,416 bytes, 14.0% under
    # Release, in the same 31 seconds. It is the same source through a different
    # code generator, so it is verified like any other configuration -- the suite
    # is what says the two agree, not the flag.
    MinSizeRel)     FLAGS="-gen gcc -Wc -Os -w all" ;;
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
