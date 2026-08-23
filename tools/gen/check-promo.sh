#!/bin/sh
# check-promo.sh -- tiko-lang's expression typing against fbc's, over every combination.
#
#   tools/gen/check-promo.sh
#
# Wrapper for tools/gen/check-promo.py. The expectations come from
# tools/gen/promo-truth.py, which asks fbc '#print typeof( a op b )' for all 3,920
# (lhs, op, rhs) combinations -- the frontend's own answer, not one inferred from
# generated code. Regenerate them only when fbc itself changes.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-promo.py"
