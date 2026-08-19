#!/bin/sh
# check-ptr.sh -- fbx's POINTER conversions against fbc's.
#
#   tools/gen/check-ptr.sh
#
# Wrapper for tools/gen/check-ptr.py. The expectations come from tools/gen/ptr-truth.py,
# which asks fbc itself two questions per combination: does a lone candidate take this
# argument, and which of two candidates wins. They are DIFFERENT questions -- a
# warning-3 pointer conversion is accepted by the first and unviable to the second --
# and conflating them is what the truth file exists to prevent.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-ptr.py"
