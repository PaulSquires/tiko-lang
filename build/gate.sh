#!/bin/bash
# gate.sh [--accept] -- THE COMMIT GATE for a batch of front-end or lowering fixes.
#
#   bash build/gate.sh            run it over this tree
#   bash build/gate.sh --accept   after the batch is COMMITTED: snap-new.json -> snap-head.json
#
# MOVED INTO THE TREE from ~/.claude/tiko-gate (review BLD-03, 2026-10-24), where it piped
# every step through 'grep | head' and so could not fail: a missing runner printed nothing
# and read as green. Here every step's EXIT CODE counts and the suite must print its summary
# line; the script exits 1 when anything is red.
#
#   1. Debug build of this tree, IN PARALLEL with a Release build from a mirror (relbuild.sh).
#   2. Corpus: every diagnostic of build/gate-corpus.txt (plus $TKO_GATE_EXTRA, a list of
#      absolute paths) from the Release binary, diffed against snap-head.json.
#   3. Suite (--no-build), then lint.
#   4. Self-host lowering of tiko's own units with the Release binary.
#
# STATE lives in $TKO_GATE_DIR (default build/.gate, ignored): the snapshots, the mirror and
# the Release binary. With no snap-head.json the first run SAVES one and says so -- a corpus
# baseline must come from HEAD's binary, so run it once on an unmodified tree.
#
# Nothing here runs beside anything else: the corpus and the suite together slow each other
# past 600s.
set -o pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
G=${TKO_GATE_DIR:-$ROOT/build/.gate}
mkdir -p "$G"
if [ "$1" = "--accept" ]; then
    cp "$G/snap-new.json" "$G/snap-head.json" && echo "gate: snap-head.json <- snap-new.json"
    exit $?
fi
cd "$ROOT" || exit 2
t0=$(date +%s)
bad=0
red( ) { echo "gate: RED -- $*"; bad=$((bad + 1)); }

s=$(date +%s)
( TKO_EDITOR_DIR=/c/nonexistent bash build/build.sh Debug --test-runner > "$G/debug.log" 2>&1 ) &
dpid=$!
bash build/relbuild.sh "$ROOT" "$G/tiko-rel.exe" "$G/relmirror" || red "Release build (relbuild.sh)"
wait $dpid || { grep -E " error |error [0-9]+:|FAILED" "$G/debug.log" | head -5; red "Debug build ($G/debug.log)"; }
echo "gate: builds $(( $(date +%s)-s ))s"
[ -x "$G/tiko-rel.exe" ] || { echo "gate: no Release binary, stopping"; exit 1; }

if [ -f "$G/snap-head.json" ]; then
    python build/fastcorpus.py "$ROOT" "$G/tiko-rel.exe" --list build/gate-corpus.txt \
        ${TKO_GATE_EXTRA:+--list "$TKO_GATE_EXTRA"} \
        --against "$G/snap-head.json" --save "$G/snap-new.json" || red "corpus differs from snap-head.json"
else
    python build/fastcorpus.py "$ROOT" "$G/tiko-rel.exe" --list build/gate-corpus.txt \
        ${TKO_GATE_EXTRA:+--list "$TKO_GATE_EXTRA"} --save "$G/snap-head.json" \
        && echo "gate: corpus BASELINE SAVED to snap-head.json -- not a comparison"
fi

s=$(date +%s)
env -u TKO_INCLUDE -u TKO_LIBPATH bash build/test.sh --no-build > "$G/suite.log" 2>&1
src=$?
grep -E "^FAIL|passed" "$G/suite.log" | tail -8
grep -q "passed, .* failed" "$G/suite.log" || red "suite printed no summary line ($G/suite.log)"
[ "$src" = "0" ] || red "suite exit $src"
echo "gate: suite $(( $(date +%s)-s ))s"
bash build/lint.sh > "$G/lint.log" 2>&1 || { tail -3 "$G/lint.log"; red "lint"; }

SOURCES=$(grep -v '^#' build/sources.txt | tr '\n' ' ')
TKO_INCLUDE="$ROOT/inc" TKO_PKG="$ROOT/pkg" TKO_MODCACHE="$G/selfhost.modcache" \
    "$G/tiko-rel.exe" --dump-ir -target windows-x86_64 -i src $SOURCES > "$G/selfhost.txt" 2>&1
shrc=$?
echo "gate: selfhost rc=$shrc diagnostics=$(grep -cE '(error|warning) TKO' "$G/selfhost.txt") modules-clean=$(grep -c ', 0 statements not lowered' "$G/selfhost.txt")"
[ "$shrc" = "0" ] || red "self-host lowering rc=$shrc"

echo "gate: total $(( $(date +%s)-t0 ))s"
if [ "$bad" -gt 0 ]; then
    echo "gate: FAILED -- $bad step(s)"
    exit 1
fi
echo "gate: ok"
