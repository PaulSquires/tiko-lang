#!/bin/sh
# mirsweep.sh -- lower the whole corpus and aggregate the MIR statistics.
#
# Separate from sweep.sh (which stops after parsing) because lowering every file takes
# minutes rather than seconds.
#
# The numbers that matter are the ones that must be ZERO: verifier failures, scope
# imbalance, and label-depth mismatches.
#
# The two breakdowns say WHICH thing to implement next; a single total invites guessing.
# They divide the declines into statements never STARTED (the dispatch) and statements
# started and not FINISHED (inside), and the second is larger by more than an order of
# magnitude.
#
# Do not rebuild while this runs: the link will fail on a locked bin/fbx.exe, and a
# half-replaced binary mid-sweep would report numbers from two different compilers.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "mirsweep: corpus not vendored" >&2; exit 3; }

# 761 of the 2,709 corpus files -- 28% -- '#include "fbcunit.bi"', the suite's own test
# framework, which lives in a subdirectory none of them name. Without this a quarter of
# the corpus fails at its first line, and every number is measured against files that
# cannot resolve their own harness. See docs/internals/corpus-include-path.md.
FBCUNIT=""
[ -d "$CORPUS/fbcunit/inc" ] && FBCUNIT="-i $CORPUS/fbcunit/inc"

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
: > build/.mir.out
while IFS= read -r f; do
    ./bin/fbx.exe --dump-ir $FBCUNIT "$f" 2>/dev/null \
        | grep -E '^(lowered|verify):|^  unlowered |^  inside |^  skip-site |^  amb ' >> build/.mir.out || true
done < build/.corpus.lst

awk '
/^lowered:/ {
  files++
  if (match($0,/ ([0-9]+) functions/,m))               fn  += m[1]
  if (match($0,/ ([0-9]+) blocks/,m))                  blk += m[1]
  if (match($0,/ ([0-9]+) insts/,m))                   ins += m[1]
  if (match($0,/ ([0-9]+) statements not lowered/,m))  sk  += m[1]
  if (match($0,/ ([0-9]+) scope imbalance/,m))         si  += m[1]
  if (match($0,/ ([0-9]+) label depth/,m))             ld  += m[1]
  if (ins_prev == ins) empty++
  ins_prev = ins
}
/^verify: FAIL/          { vf++ }
/^  unlowered N_/        { kind[$2] += $3 }
/^  unlowered intrinsic/ { intr[$3] += $4 }
/^  inside N_/           { inner[$2] += $3 }
/^  skip-site /          { site[$2] += $3 }
/^  amb /                { amb[$2] += $3 }
END {
  printf "mirsweep: %d files, %d blocks, %d insts\n", files, blk, ins
  printf "mirsweep: %d files emit code, %d emit nothing\n", files - empty, empty
  printf "mirsweep: %d statements not lowered, of those that reached lowering\n", sk
  printf "mirsweep: %d scope imbalance, %d verify failures, %d label depth mismatches\n", si, vf, ld
  printf "mirsweep: --- never STARTED (statement dispatch) ---\n"
  n1 = asorti(kind, ks, "@val_num_desc")
  for (i = 1; i <= n1 && i <= 6; i++) printf "mirsweep:  %8d  %s\n", kind[ks[i]], ks[i]
  n2 = asorti(intr, is2, "@val_num_desc")
  for (i = 1; i <= n2 && i <= 6; i++) printf "mirsweep:  %8d  intrinsic %s\n", intr[is2[i]], is2[i]
  printf "mirsweep: --- started and not FINISHED, by the statement it was inside ---\n"
  n3 = asorti(inner, is3, "@val_num_desc")
  for (i = 1; i <= n3 && i <= 8; i++) printf "mirsweep:  %8d  inside %s\n", inner[is3[i]], is3[i]
  printf "mirsweep: --- the LINE that gave up ---\n"
  n4 = asorti(site, is4, "@val_num_desc")
  for (i = 1; i <= n4 && i <= 12; i++) printf "mirsweep:  %8d  %s\n", site[is4[i]], is4[i]
  printf "mirsweep: --- why an N_AMBIGUOUS statement emitted NOTHING ---\n"
  n5 = asorti(amb, is5, "@val_num_desc")
  for (i = 1; i <= n5; i++) printf "mirsweep:  %8d  amb %s\n", amb[is5[i]], is5[i]
}
' build/.mir.out
