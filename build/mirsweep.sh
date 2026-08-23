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

# fbx ships no headers, so its default include directory does not exist in a source
# tree. 144 corpus files include a real FreeBASIC runtime header; without a header set
# they fail at their first line and every number after that is measured against files
# that could not open their own dependencies. FBX_INCLUDE is the driver's own override,
# so this is the same shape as the -i above: a HARNESS fact, not a compiler one.
FBXINC=${FBX_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$FBXINC" ]; then
    FBX_INCLUDE="$FBXINC"
    export FBX_INCLUDE
else
    echo "mirsweep: no runtime headers at $FBXINC -- 144 files will fail on #include" >&2
fi

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst

# One fbx per file, N at a time. Each writes its OWN part file rather than appending to
# a shared one: concurrent appends interleave once a file's output passes the pipe
# buffer, and a torn 'lowered:' line would be counted as something else rather than
# reported as an error. The parts are concatenated afterwards, so the aggregate is
# identical to the serial run -- and that equality was verified, not assumed.
# JOBS was one per core, and that cost two runs: once the fork table was exhausted and
# a worker died with its output redirected at a directory, once a run hung for an hour.
# Six leaves headroom for the shell's own processes. Raise it with MIRSWEEP_JOBS.
JOBS=${MIRSWEEP_JOBS:-6}
rm -rf build/.mirparts build/.diagparts build/.skipparts
mkdir -p build/.mirparts build/.diagparts build/.skipparts

# ONE fbx per file, producing BOTH outputs. The diagnostics used to be collected by a
# SECOND sweep running the identical command, which doubled the wall time and the fork
# pressure for nothing -- and left two measurements that could disagree with each other
# if the binary changed between them.
#
# stderr is merged now, because diagnostics go there. The statistics greps are anchored,
# so they match what they did when stderr was discarded -- checked against the previous
# run rather than assumed.
xargs -a build/.corpus.lst -d '
' -P "$JOBS" -I{} sh -c '
    key=$(printf %s "$1" | tr -c "A-Za-z0-9._-" "_")
    raw=build/.mirparts/$key.raw
    FBX_TRACE_SKIP=1 ./bin/fbx.exe --dump-ir '"$FBCUNIT"' "$1" > "$raw" 2>&1 || true
    grep -E "^(lowered|verify):|^  unlowered |^  inside |^  skip-site |^  amb|^  var " \
        "$raw" > "build/.mirparts/$key" || true
    grep -E "^SKIP " "$raw" | sed "s/.* at //" > "build/.skipparts/$key" || true
    grep -E ": (error|fatal) FBX" "$raw" > "build/.diagparts/$key" || true
    rm -f "$raw"
' _ {}

# A part per corpus file, or the run was short and every total below is understated.
# A partial sweep says nothing about being partial, so it is checked, not read.
want=$(wc -l < build/.corpus.lst)
got=$(ls build/.mirparts | wc -l)
if [ "$got" -ne "$want" ]; then
    echo "mirsweep: INCOMPLETE -- $got parts for $want files; totals below are wrong" >&2
    exit 4
fi
cat build/.mirparts/* > build/.mir.out
# THE SOURCE LINES THE CORPUS DECLINES ON MOST, which is the work list. A
# compiler line says which branch gave up; only the source line says what it gave
# up ON, and two of the largest items ever found here were invisible without it.
cat build/.skipparts/* 2>/dev/null | sort | uniq -c | sort -rn | head -12 | sed 's/^/mirsweep:  /' > build/.skiplines.out || true
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
# The line fbx actually prints is "verify: N FAILURES". The pattern here was
# "^verify: FAIL", which matches NONE of them -- so this sweep reported "0 verify
# failures" on every run while 3,035 of them stood in 406 files. A gate can be
# green because it does not cover the thing; this one was green because it could
# not see it.
/^verify: [0-9]+ FAILURES/ { vf += $2; vfiles++ }
/^  unlowered N_/          { kind[$2] += $3 }
/^  unlowered intrinsic/   { intr[$3] += $4 }
/^  inside N_/             { inner[$2] += $3 }
/^  skip-site /            { site[$2] += $3 }
/^  amb /                  { amb[$2] += $3 }
/^  var /                  { amb["var " $2] += $3 }
/^  amb-other-/            { oth[$1 " " $2] += $3 }
/^  amb-unbound-shape /    { ushape[$2] += $3 }
/^  amb-unbound-name /     { uname[$2]++ }
/^  amb-member-name /      { mname[$2]++ }
END {
  printf "mirsweep: %d files, %d blocks, %d insts\n", files, blk, ins
  printf "mirsweep: %d files emit code, %d emit nothing\n", files - empty, empty
  printf "mirsweep: %d statements not lowered, of those that reached lowering\n", sk
  printf "mirsweep: %d scope imbalance, %d verify failures in %d files, %d label depth mismatches\n", si, vf, vfiles, ld
  printf "mirsweep: --- never STARTED (statement dispatch) ---\n"
  n1 = asorti(kind, ks, "@val_num_desc")
  for (i = 1; i <= n1 && i <= 6; i++) printf "mirsweep:  %8d  %s\n", kind[ks[i]], ks[i]
  n2 = asorti(intr, is2, "@val_num_desc")
  for (i = 1; i <= n2 && i <= 6; i++) printf "mirsweep:  %8d  intrinsic %s\n", intr[is2[i]], is2[i]
  printf "mirsweep: --- started and not FINISHED, by the statement it was inside ---\n"
  n3 = asorti(inner, is3, "@val_num_desc")
  for (i = 1; i <= n3 && i <= 6; i++) printf "mirsweep:  %8d  inside %s\n", inner[is3[i]], is3[i]
  printf "mirsweep: --- the LINE that gave up ---\n"
  n4 = asorti(site, is4, "@val_num_desc")
  for (i = 1; i <= n4 && i <= 8; i++) printf "mirsweep:  %8d  %s\n", site[is4[i]], is4[i]
  printf "mirsweep: --- why an N_AMBIGUOUS statement emitted NOTHING ---\n"
  n5 = asorti(amb, is5, "@val_num_desc")
  for (i = 1; i <= n5; i++) printf "mirsweep:  %8d  amb %s\n", amb[is5[i]], is5[i]
  n6 = asorti(oth, is6, "@val_num_desc")
  for (i = 1; i <= n6 && i <= 4; i++) printf "mirsweep:  %8d  %s\n", oth[is6[i]], is6[i]
  printf "mirsweep: --- the UNBOUND callee, by shape then by name ---\n"
  n7 = asorti(ushape, is7, "@val_num_desc")
  for (i = 1; i <= n7 && i <= 5; i++) printf "mirsweep:  %8d  callee %s\n", ushape[is7[i]], is7[i]
  n8 = asorti(uname, is8, "@val_num_desc")
  for (i = 1; i <= n8 && i <= 10; i++) printf "mirsweep:  %8d  name %s\n", uname[is8[i]], is8[i]
  n9 = asorti(mname, is9, "@val_num_desc")
  for (i = 1; i <= n9 && i <= 6; i++) printf "mirsweep:  %8d  member %s\n", mname[is9[i]], is9[i]
}
' build/.mir.out

# The parse gap, from the same pass: how many files report a diagnostic at all, and the
# first one of each bucketed by shape. Keyed on the FIRST diagnostic per file -- keyed on
# all of them, one lost parser repeating itself dominates the table.
dirty=$(grep -l . build/.diagparts/* 2>/dev/null | wc -l)
echo "mirsweep: $dirty files report a diagnostic, of $want"
for f in build/.diagparts/*; do head -1 "$f"; done 2>/dev/null \
    | grep -oE 'FBX[0-9]+: .*' | sed -E "s/'[^']*'/'X'/g; s/[0-9]+/N/g" \
    | sort | uniq -c | sort -rn | head -8 | sed 's/^/mirsweep:  /'


echo "mirsweep: --- the SOURCE LINE that declined, corpus-wide ---"
cat build/.skiplines.out 2>/dev/null
