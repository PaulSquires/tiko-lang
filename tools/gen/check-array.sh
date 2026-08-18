#!/bin/sh
# check-array.sh -- fbx's array slot sizes against fbc's reserved storage.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
python3 tools/gen/array-truth.py >/dev/null
exec python3 tools/gen/check-array.py
