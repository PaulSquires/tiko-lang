#!/bin/sh
# mirsweep.sh -- lower the whole corpus and aggregate the MIR statistics.
#
# Separate from sweep.sh (which stops after parsing) because lowering every file takes
# minutes rather than seconds.
#
# The numbers that matter are the ones that must be ZERO: verifier failures, scope
# imbalance, and label-depth mismatches.
#
# READ THE "not lowered" COUNT CAREFULLY. It counts statements that REACHED lowering and
# were declined; a statement dropped before that never reaches the counter at all.
#
# The breakdown at the end is what says WHICH thing to implement next. A single total
# invites guessing. Note it accounts for only about half the count: the rest is work
# declined INSIDE a statement, at a skip site other than the statement dispatch.
#
# Do not rebuild while this runs: the link will fail on a locked bin/fbx.exe, and a
# half-replaced binary mid-sweep would report numbers from two different compilers.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "mirsweep: corpus not vendored" >&2; exit 3; }
find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
: > build/.mir.out
while IFS= read -r f; do
    ./bin/fbx.exe --dump-ir "$f" 2>/dev/null | grep -E '^(lowered|verify):|^  unlowered ' >> build/.mir.out || true
done < build/.corpus.lst
awk '
/^lowered:/ {
  n++
  if (match($0,/ ([0-9]+) functions/,m))               { if (m[1]==0) empty++; else withfn++ }
  if (match($0,/ ([0-9]+) blocks/,m))                  blk += m[1]
  if (match($0,/ ([0-9]+) insts/,m))                   ins += m[1]
  if (match($0,/ ([0-9]+) statements not lowered/,m))  sk  += m[1]
  if (match($0,/ ([0-9]+) scope imbalance/,m))         si  += m[1]
  if (/LABEL DEPTH MISMATCH/)                          mm++
}
/^verify: fail/          { vf++ }
/^  unlowered N_/        { kind[$2] += $3 }
/^  unlowered intrinsic/ { intr[$3] += $4 }
END {
  printf "mirsweep: %d files, %d blocks, %d insts\n", n, blk, ins
  printf "mirsweep: %d files emit code, %d emit nothing\n", withfn+0, empty+0
  printf "mirsweep: %d statements not lowered, of those that reached lowering\n", sk+0
  printf "mirsweep: %d scope imbalance, %d verify failures, %d label depth mismatches\n", si+0, vf+0, mm+0
  printf "mirsweep: --- what did not lower (statement dispatch only) ---\n"
  n1 = asorti(kind, ks, "@val_num_desc")
  for (i = 1; i <= n1 && i <= 8; i++) printf "mirsweep:  %8d  %s\n", kind[ks[i]], ks[i]
  n2 = asorti(intr, is2, "@val_num_desc")
  for (i = 1; i <= n2 && i <= 8; i++) printf "mirsweep:  %8d  intrinsic %s\n", intr[is2[i]], is2[i]
}
' build/.mir.out
