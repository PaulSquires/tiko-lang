#!/bin/sh
# check-eol.sh -- LF and CRLF input must parse IDENTICALLY.
#
# This exists because of a bug it would have caught. ':' and a newline are both TK_EOL and
# both one byte, so the parser told them apart by LENGTH -- which made every
# parenthesis-less zero-argument call ('Bar' on a line of its own) parse as a LABEL on LF
# input, and looked perfectly correct on CRLF.
#
# It was invisible to every measurement in the repo: core.autocrlf=true converts the
# vendored corpus to CRLF on checkout, so the entire sweep runs on CRLF and the LF path is
# never exercised. fbx targets Linux, where source is LF, and it has never been built
# there -- so this class of bug had nothing at all standing in its way.
#
# A sample rather than the whole corpus: the point is a cheap invariant that runs often.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "check-eol: corpus not vendored" >&2; exit 3; }
N=${FBX_EOL_SAMPLE:-400}

find "$CORPUS" -name '*.bas' | sort | head -"$N" > build/.eol.lst
rm -rf build/.eolwork && mkdir -p build/.eolwork

i=0
bad=0
while IFS= read -r f; do
    i=$((i + 1))
    d="build/.eolwork/$(printf '%05d' $i).bas"
    tr -d '\r' < "$f" > "$d"
    a=$(./bin/fbx.exe --dump-ir "$f" 2>/dev/null | awk '/unlowered N_ERROR/{print $3}')
    b=$(./bin/fbx.exe --dump-ir "$d" 2>/dev/null | awk '/unlowered N_ERROR/{print $3}')
    if [ "${a:-0}" != "${b:-0}" ]; then
        bad=$((bad + 1))
        echo "  $f: CRLF=${a:-0} LF=${b:-0}"
    fi
done < build/.eol.lst

if [ "$bad" != "0" ]; then
    echo "check-eol: $bad/$i files parse DIFFERENTLY as LF and CRLF"
    exit 1
fi
echo "check-eol: $i/$i files parse identically as LF and CRLF"
