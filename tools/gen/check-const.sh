#!/bin/sh
# check-const.sh -- tiko-lang's constant folding against fbc's, bit for bit.
#
#   tools/gen/check-const.sh
#
# Wrapper for tools/gen/check-const.py. Expectations come from tools/gen/const-truth.py.
# '#print' does NOT fold in fbc -- it echoes its tokens -- so there is no way to simply
# ask for a value. '#assert' does evaluate, which makes it a one-bit oracle, and 64 of
# those recover the whole number exactly rather than through a decimal rendering.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-const.py"
