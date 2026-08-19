#!/bin/sh
# check-intrin.sh -- fbx's EXPRESSION-intrinsic result types against fbc's.
#
#   tools/gen/check-intrin.sh
#
# Wrapper for tools/gen/check-intrin.py, expectations from intrin-truth.py. The 48
# IFORM_EXPR keywords over thirteen argument shapes. NOT exact: fbc constant-folds
# several of them, and those rows are reported rather than fitted.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-intrin.py"
