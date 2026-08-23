#!/bin/sh
# check-conv.sh -- tiko-lang's conversion-intrinsic result types against fbc's.
#
#   tools/gen/check-conv.sh
#
# Wrapper for tools/gen/check-conv.py. The expectations come from tools/gen/conv-truth.py,
# which asks fbc '#print typeof( cbyte( v ) )' for every (intrinsic, argument type) pair.
# Most of the family is named after its result and could have been guessed; CSIGN and
# CUNSG could not -- their result depends on the ARGUMENT, and a fixed-length string
# gives them an asymmetric answer.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-conv.py"
