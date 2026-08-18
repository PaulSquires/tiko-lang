#!/bin/sh
# vendor-corpus.sh -- snapshot fbc's own test suite at a pinned commit.
#
#   tools/vendor-corpus.sh [<sha>]
#
# The corpus is COMMITTED to this repository (docs/plan/13 section 5): CI must run
# without fbc-modern present, the pass-count ratchet needs a fixed denominator, and
# re-baselining must show up as a reviewable diff. Never copy the files by hand --
# git archive at a recorded sha is what makes the snapshot reproducible.

set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
UPSTREAM=${FBX_FBC_REPO:-/c/dev/fbc-modern}
DEST="$ROOT/tests/vendor/fbc-tests"
STAMP="$ROOT/tests/vendor/CORPUS-COMMIT"

SHA=${1:-$(git -C "$UPSTREAM" rev-parse HEAD)}

echo "vendor-corpus: $UPSTREAM @ $SHA -> tests/vendor/fbc-tests"
rm -rf "$DEST"
mkdir -p "$DEST"
git -C "$UPSTREAM" archive "$SHA" src/tests | tar -x -C "$DEST" --strip-components=2

{
    echo "$SHA"
    echo "source: $UPSTREAM  path: src/tests"
    echo "files:  $(find "$DEST" -type f | wc -l)"
} > "$STAMP"

echo "vendor-corpus: $(find "$DEST" -name '*.bas' | wc -l) .bas files, $(du -sh "$DEST" | cut -f1)"
