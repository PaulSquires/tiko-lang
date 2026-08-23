#!/bin/sh
# check-overload.sh -- tiko-lang's overload choice against fbc's, over every measured pair.
#
#   tools/gen/check-overload.sh
#
# Wrapper for tools/gen/check-overload.py. Expectations come from
# tools/gen/overload-truth.py, which gives each candidate a distinct RETURN type and
# asks fbc '#print typeof( f( arg ) )'. The return type takes no part in overload
# resolution, so it is a free marker for which candidate won -- and the whole thing is
# answered at compile time, with nothing run.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-overload.py"
