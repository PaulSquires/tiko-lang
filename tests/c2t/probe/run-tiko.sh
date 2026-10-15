#!/usr/bin/env bash
# c2t P0 probes 4-11 (docs/tiko-c2t RFC-0001 §10): compile each tiko fixture for both targets and
# print its exit status and any #print / error lines. Not part of build/test.sh.
#
# usage: bash tests/c2t/probe/run-tiko.sh [tiko.exe]     (default: bin/tiko.exe of this tree)
# The two fixtures that must link and run (literals, cbool) need a packaged toolchain's tiko;
# see README.md.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
TIKO=${1:-$HERE/../../../bin/tiko.exe}
OUT=$(mktemp -d)
cd "$HERE/tiko"
for f in fwd-later fwd-never fwd-noalias fwd-byvalue fwd-ptralias fwd-fwdptr fwd-fbfrog \
         layout externc enumsize enumsize8 \
         contcomment contline contblank contblock contunder contbare ppexpr; do
    for t in windows-x86_64 linux-x86_64; do
        msg=$("$TIKO" -c -target "$t" "$f.tiko" -o "$OUT/$f-$t.o" 2>&1)
        rc=$?
        echo "[$f $t] rc=$rc"
        printf '%s\n' "$msg" | grep -a -E "error TKO|#print" | grep -a -v "^ *[0-9]* |" | sed 's/^/    /'
    done
done
rm -rf "$OUT"
