#!/bin/sh
# check-layout.sh -- fbx's builtin layout must agree with fbc's, field by field.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;; *) EXT="" ;; esac

TRUTH=tests/types/expected/fbc-layout.txt
[ -f "$TRUTH" ] || { echo "check-layout: run tools/gen/layout-truth.sh first" >&2; exit 3; }

./bin/fbx$EXT --dump-types tests/lexer/src/basics.bas 2>/dev/null > build/.types.out
bad=0
while read -r name size align; do
    [ -z "$name" ] && continue
    line=$(grep -E "^ *[0-9]+ $name +size=" build/.types.out || true)
    got_size=$(echo "$line" | sed -n 's/.*size= *\([0-9]*\).*/\1/p')
    got_align=$(echo "$line" | sed -n 's/.*align= *\([0-9]*\).*/\1/p')
    if [ "$got_size" != "$size" ] || [ "$got_align" != "$align" ]; then
        echo "check-layout: $name fbc=$size/$align fbx=$got_size/$got_align" >&2
        bad=$((bad + 1))
    fi
done < "$TRUTH"

if [ "$bad" -gt 0 ]; then
    echo "check-layout: $bad mismatch(es)" >&2
    exit 1
fi
echo "check-layout: ok ($(grep -c . "$TRUTH") builtin types agree with fbc)"
