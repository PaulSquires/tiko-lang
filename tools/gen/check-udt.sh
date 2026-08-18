#!/bin/sh
# check-udt.sh -- fbx's UDT layout against fbc's, shape by shape.
#
#   tools/gen/check-udt.sh
#
# Wrapper for tools/gen/check-udt.py. Expectations come from tools/gen/udt-truth.py,
# which compiles and RUNS a probe under fbc: 'sizeof' and 'offsetof' are compile-time
# constants but '#print' does not fold, so the numbers have to be printed at run time.
#
# A struct's layout is ABI. A field at the wrong offset does not fail -- it reads the
# neighbouring field's bytes -- so a shape either matches completely or it is named.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-udt.py"
