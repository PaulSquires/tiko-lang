#!/bin/sh
# test.sh -- build everything and run the suite.
#
#   build/test.sh [suite...] [--accept] [--filter <pat>] [-v]
#
# --accept rewrites golden files. The resulting diff is reviewed like code; a commit
# that accepts goldens without saying why does not land (docs/plan/13 section 3).

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *)                    EXT="" ;;
esac

"$ROOT/build/build.sh" Debug --test-runner
cd "$ROOT"
exec "./bin/tiko-test$EXT" "$@"
