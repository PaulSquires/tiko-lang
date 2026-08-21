#!/bin/sh
# check-str.sh -- fbx's float rendering against the text fbc's STR( ) produces.
#
#   tools/gen/check-str.sh
#
# Wrapper for tools/gen/check-str.py. Expectations come from tools/gen/str-truth.py,
# which compiles and RUNS two probes: one that formats bit patterns with STR( ), and one
# that proves fbc's compile-time DATA folding renders a float the same way. `data 1.5`
# is stored as the TEXT "1.5", so this is what stands between a READ of a float datum
# and a silently different number.
#
# win64 is exact and a single mismatch fails. win32 is NOT matched and the gate says so
# on its own line: fbc32 folds through the legacy msvcrt renderer, and part of that
# behaviour is not a rule that could be reimplemented.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-str.py"
