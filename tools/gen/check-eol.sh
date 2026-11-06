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
# never exercised. tiko-lang targets Linux, where source is LF, and it has never been built
# there -- so this class of bug had nothing at all standing in its way.
#
# BATCHED, and that is the whole reason it is usable. Run file-by-file it took 5m16s for
# 400 files -- four processes each, and process launch under Git Bash on Windows costs far
# more than the 24ms tiko-lang itself needs. tiko-lang takes many inputs per run and prints one
# 'lowered:' summary per file, so the same 400 files are two invocations.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "check-eol: corpus not vendored" >&2; exit 3; }
N=${TIKO_EOL_SAMPLE:-400}

find "$CORPUS" -name '*.bas' | sort | head -"$N" > build/.eol.lst
rm -rf build/.eolwork && mkdir -p build/.eolwork

# One awk pass strips the CR from every file at once, writing each to its own numbered
# copy. The numbering keeps the two runs in the same order so results pair by ordinal.
awk 'FNR==1{ n++; out=sprintf("build/.eolwork/%05d.bas", n) }
     { sub(/\r$/, ""); print > out }' $(cat build/.eol.lst)

# The N_ERROR count per file, in input order: tiko-lang prints the breakdown before each
# file's 'lowered:' line, and omits the line entirely when the count is zero.
counts() {
    ./bin/tiko.exe --dump-ir "$@" 2>/dev/null | awk '
        /unlowered N_ERROR/ { cur = $3 }
        /^lowered:/         { print cur + 0; cur = 0 }'
}

counts $(cat build/.eol.lst) > build/.eol.crlf
counts $(ls build/.eolwork/*.bas) > build/.eol.lf

i=$(wc -l < build/.eol.crlf)
j=$(wc -l < build/.eol.lf)
if [ "$i" != "$j" ]; then
    echo "check-eol: $i CRLF results against $j LF -- the runs did not pair up" >&2
    exit 1
fi

bad=$(paste build/.eol.crlf build/.eol.lf | awk '$1 != $2 { n++ } END { print n + 0 }')
if [ "$bad" != "0" ]; then
    echo "check-eol: $bad/$i files parse DIFFERENTLY as LF and CRLF"
    paste build/.eol.lst build/.eol.crlf build/.eol.lf |
        awk '$2 != $3 { print "  " $1 ": CRLF=" $2 " LF=" $3 }'
    exit 1
fi
echo "check-eol: $i/$i files parse identically as LF and CRLF"
