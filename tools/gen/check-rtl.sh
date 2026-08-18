#!/bin/sh
# check-rtl.sh -- fbx's runtime inventory against the signatures fbc emits.
#
#   tools/gen/check-rtl.sh
#
# Wrapper for tools/gen/check-rtl.py. Expectations come from tools/gen/rtl-truth.py,
# which reads the C intermediate 'fbc -r' leaves behind -- that file DECLARES every
# runtime function fbc calls -- and cross-checks each name against libfb.a.
#
# Measured rather than transcribed on purpose: fbc's own rtl-*.bas tables are GPL
# compiler source, and docs/plan/11 already flags the runtime licence as a
# prerequisite for release. What fbc emits is both licence-clean and better evidence.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-rtl.py"
