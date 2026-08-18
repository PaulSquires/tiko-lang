#!/bin/sh
# check-assign.sh -- fbx's assignment legality against fbc's, over every measured pair.
#
#   tools/gen/check-assign.sh
#
# Wrapper for tools/gen/check-assign.py. Expectations come from
# tools/gen/assign-truth.py, which compiles every 'target = source' pair with fbc at
# '-w all' and records error, warning, or silence. The three are kept distinct: fbc
# accepts a pointer/integer assignment but says something about it, and collapsing
# 'warn' into 'ok' would hide a real difference in behaviour.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-assign.py"
