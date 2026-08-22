#!/bin/sh
# check-vtable.sh -- fbx's virtual method tables against fbc's, slot by slot.
#
#   tools/gen/check-vtable.sh
#
# Wrapper for tools/gen/check-vtable.py. Expectations come from
# tools/gen/vtable-truth.py, which reads the '_ZTV' initialisers straight out of the C
# fbc generates.
#
# A slot at the wrong index does not fail loudly. It calls the WRONG METHOD, with the
# right number of arguments and a plausible answer, so a table either matches completely
# or the disagreeing slots are named.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-vtable.py"
