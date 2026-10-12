#!/bin/sh
# test.sh -- build everything and run the suite.
#
#   build/test.sh [suite...] [--accept] [--filter <pat>] [-j N] [-v] [--no-build]
#
# --accept rewrites golden files. The resulting diff is reviewed like code; a commit
# that accepts goldens without saying why does not land (docs/plan/13 section 3).
#
# THE BUILD IS SKIPPED WHEN NOTHING IT DEPENDS ON HAS CHANGED. Building tiko-lang is
# one fbc invocation over every module and takes about 80 seconds -- more than three
# times the suite itself -- and it ran unconditionally, so re-running one --filter,
# accepting a golden, or re-reading a failure each paid it for nothing.
#
# What counts as a dependency is deliberately COARSE: for the compiler, anything under
# src/ plus the source list and build.sh; for the runner, anything under tools/. A .ti
# is included by whatever includes it and 23 of the .tiko files under src/ are #included
# rather than compiled, so per-file dependency tracking is not something a timestamp
# can do honestly -- and being wrong in that direction means NOT rebuilding, which is
# the expensive kind of wrong.
#
# TIMESTAMPS ALONE ARE NOT ENOUGH, because they cannot tell a Debug binary from a
# Release one: 'build/build.sh Release' leaves bin/tiko newer than every source, and
# the Debug suite would then run the Release binary and report nothing about it. So
# build.sh -- either peer -- records what it built in build/obj/.build-stamp, and this
# rebuilds whenever that is missing, is for another configuration, or names another
# compiler. The compiler ITSELF is a dependency too: a rebuilt stage0 changes what
# every one of these binaries is.
#
# TKO_TEST_REBUILD=1 forces the build; --no-build skips it even when stale.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *)                    EXT="" ;;
esac

CFG=Debug
TIKO="$ROOT/bin/tiko$EXT"
RUNNER="$ROOT/bin/tiko-test$EXT"
STAMP="$ROOT/build/obj/.build-stamp"

# --no-build is ours, not the runner's: strip it before the arguments are passed on.
ARGS=""
NOBUILD=0
for a in "$@"; do
    if [ "$a" = "--no-build" ]; then
        NOBUILD=1
    else
        ARGS="$ARGS $a"
    fi
done

# Any FILE newer than the reference, in any of these? '-print -quit' stops at the
# first hit rather than walking the whole tree to build a list nothing reads.
#
# '-type f' IS LOAD-BEARING, not tidiness. fbc writes its objects beside the sources
# and deletes them after linking, so every directory under src/ ends the build with an
# mtime NEWER THAN THE EXECUTABLE it just produced -- and a directory-inclusive test
# therefore says 'stale' immediately after a successful build, every time, which is
# exactly the bug this guard exists to remove. The '*.o' exclusion is the same hazard
# from the other side: one left behind by an interrupted build would do it too.
newer_than( ) {
    ref=$1
    shift
    for inp in "$@"; do
        [ -e "$inp" ] || continue
        if [ -n "$(find "$inp" -type f ! -name '*.o' -newer "$ref" -print -quit 2>/dev/null)" ]; then
            return 0
        fi
    done
    return 1
}

# The stage0 build.sh would use now: TKO_SEED, else the default seed.
. "$ROOT/build/defaultseed.sh"
WANTCC=${TKO_SEED:-}
if [ -z "$WANTCC" ]; then
    case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) _hw=1 ;; *) _hw=0 ;; esac
    WANTCC=$(default_seed "$ROOT" "$_hw" || true)
fi
STALE=0
if [ "${TKO_TEST_REBUILD:-0}" = "1" ]; then
    STALE=1
elif [ ! -x "$TIKO" ] || [ ! -x "$RUNNER" ] || [ ! -f "$STAMP" ]; then
    STALE=1
else
    STAMPED=$(cat "$STAMP")
    STAMPCFG=${STAMPED%%|*}
    STAMPCC=${STAMPED#*|}
    if [ "$STAMPCFG" != "$CFG" ]; then
        STALE=1
    elif [ -n "$WANTCC" ] && [ "$STAMPCC" != "$WANTCC" ]; then
        # A DIFFERENT STAGE0 than the one bin/ was built with, chosen as build.sh chooses
        # it -- so a bin/ an fbc built is rebuilt once the seed is the default.
        STALE=1
    elif newer_than "$TIKO" "$ROOT/src" "$ROOT/build/sources.txt" \
                    "$ROOT/build/build.sh" "$STAMPCC"; then
        STALE=1
    elif newer_than "$RUNNER" "$ROOT/tools" "$STAMPCC"; then
        STALE=1
    fi
fi

if [ "$NOBUILD" = "1" ]; then
    if [ ! -x "$TIKO" ] || [ ! -x "$RUNNER" ]; then
        echo "test: --no-build, but bin/tiko$EXT or bin/tiko-test$EXT is missing" >&2
        exit 3
    fi
    STALE=0
fi

if [ "$STALE" = "1" ]; then
    "$ROOT/build/build.sh" "$CFG" --test-runner --no-dll
else
    echo "build: tiko-lang [$CFG] up to date"
fi

cd "$ROOT"
exec "./bin/tiko-test$EXT" $ARGS
