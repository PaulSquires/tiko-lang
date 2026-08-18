#!/bin/sh
# mirsweep.sh -- lower the whole corpus and aggregate the MIR statistics.
#
# Separate from sweep.sh (which stops after parsing) because lowering every file takes
# minutes rather than seconds.
#
# The numbers that matter are the ones that must be ZERO: verifier failures, scope
# imbalance, and label-depth mismatches.
#
# READ THE "not lowered" COUNT CAREFULLY. Lowering runs per PROCEDURE, and there is no
# implicit main yet, so a file of module-level code lowers nothing and contributes
# nothing to that count -- which is most of this corpus. It measures coverage inside
# procedures, not coverage of the corpus.
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
    ./bin/fbx.exe --dump-ir "$f" 2>/dev/null | grep -E '^(lowered|verify):' >> build/.mir.out || true
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
/^verify: fail/ { vf++ }
END {
  printf "mirsweep: %d files, %d blocks, %d insts\n", n, blk, ins
  printf "mirsweep: %d files have a procedure, %d lower NOTHING (module-level only)\n", withfn+0, empty+0
  printf "mirsweep: %d statements not lowered -- WITHIN PROCEDURES ONLY\n", sk+0
  printf "mirsweep: module-level code has no implicit main and is not lowered at all,\n"
  printf "mirsweep: so that count is not a measure of coverage over the corpus.\n"
  printf "mirsweep: %d scope imbalance, %d verify failures, %d label depth mismatches\n", si+0, vf+0, mm+0
}
' build/.mir.out
