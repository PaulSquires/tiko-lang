#!/bin/sh
# check-escape.sh -- the BYTES fbx puts in a string literal, against fbc's.
#
#   tools/gen/check-escape.sh
#
# Wrapper for tools/gen/check-escape.py; expectations from escape-truth.py, which
# measured them by RUNNING a program fbc compiled. EXACT: every row must match.
#
# '\u' and '\U' are not in the table. They make a WSTRING literal, which fbx does not
# model, and they are the largest escape in the corpus -- 2120 occurrences. That is an
# open gap this gate deliberately does not pretend to cover.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python "$ROOT/tools/gen/check-escape.py"
