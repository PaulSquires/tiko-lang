#!/bin/sh
# check-str.sh -- tiko-lang's float rendering against the text fbc's STR( ) produces.
#
#   tools/gen/check-str.sh
#
# Wrapper for tools/gen/check-str.py. Expectations come from tools/gen/str-truth.py,
# which compiles and RUNS two probes: one that formats bit patterns with STR( ), and one
# that proves fbc's compile-time DATA folding renders a float the same way. `data 1.5`
# is stored as the TEXT "1.5", so this is what stands between a READ of a float datum
# and a silently different number.
#
# EXACT on every supported target, and a single mismatch fails. win32 used to be
# measured and deliberately NOT matched -- fbc32 folds through the legacy msvcrt
# renderer, part of which is not a rule that could be reimplemented -- and it went
# with the 32-bit target on 2026-09-04 (D14).
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-str.py"
