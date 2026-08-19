#!/bin/sh
# check-callconv.sh -- fbx's DECLARE/definition calling-convention rule against fbc's.
#
#   tools/gen/check-callconv.sh
#
# Wrapper for tools/gen/check-callconv.py, expectations from callconv-truth.py. Sixteen
# pairings, and the rule behind them is asymmetric: absence on the DEFINITION inherits,
# absence on the DECLARATION means stdcall. fbc reports the mismatch on win64 too, where
# the convention changes no emitted name at all, which is what makes it a syntactic rule
# rather than a target one.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-callconv.py"
