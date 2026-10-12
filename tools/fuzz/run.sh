#!/bin/sh
# run.sh <first-seed> <count> [tiko flags...] -- a DIFFERENTIAL FUZZ CAMPAIGN.
#
# Each seed's program (tools/fuzz/gen.py) is built by fbc and by tiko, both are run with
# a timeout and a closed stdin, and the outputs are compared byte for byte. fbc is the
# ground truth, as it is for every compatibility fact in this project.
#
#   MATCH        identical output and exit code
#   DIFF         both ran, the output differs              -- a finding
#   TIKO-CRASH   the exit codes differ                     -- a finding
#   TIKO-BUILD   fbc built it and tiko did not             -- a finding
#   FBC-FAIL     fbc itself refused it                     -- a GENERATOR bug, not tiko's
#
# The flags after the count go to tiko only -- '-O2', '-O3', '-g' -- so one generator
# covers every optimisation level. fbc is always built at its default.
#
#   TKO          the compiler            (default bin/tiko.exe)
#   FBC          the reference           (default fbc-modern's toolchain fbc64.exe)
#   FUZZ_WORK    the work directory      (default build/obj/fuzz/<first-seed><flags>)
#
# A matching seed's executables and logs are deleted; a finding keeps everything, so
# the program, both binaries and both outputs are there to reduce.
#
# Phase 14 (docs/plan/15) sets the budget: 2,000 seeds with 0 crashes and 0 tiko-only
# build failures, every DIFF fixed or shown by a probe to be fbc's own behaviour.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
FIRST=$1; COUNT=$2
[ -n "$FIRST" ] && [ -n "$COUNT" ] || { echo "usage: tools/fuzz/run.sh <first-seed> <count> [tiko flags]" >&2; exit 2; }
shift 2; FLAGS="$*"
TKO=${TKO:-$ROOT/bin/tiko.exe}
FBC=${FBC:-${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}}
export TKO_INCLUDE=${TKO_INCLUDE:-$ROOT/toolchains/tiko-windows/inc}
export TKO_LIBPATH=${TKO_LIBPATH:-$ROOT/toolchains/tiko-windows/lib/windows-x86_64}
TAG=$(printf %s "$FLAGS" | tr -c 'A-Za-z0-9' '_')
W=${FUZZ_WORK:-$ROOT/build/obj/fuzz/$FIRST$TAG}
rm -rf "$W"; mkdir -p "$W"; cd "$W" || exit 3
m=0; ff=0; tb=0; tc=0; df=0
i=$FIRST; last=$((FIRST + COUNT - 1))
while [ $i -le $last ]; do
  python "$ROOT/tools/fuzz/gen.py" $i p$i.bas
  if ! "$FBC" p$i.bas -x f$i.exe > f$i.log 2>&1; then ff=$((ff+1)); echo "FBC-FAIL $i: $(grep -m1 -i error f$i.log)"; i=$((i+1)); continue; fi
  if ! "$TKO" $FLAGS p$i.bas -o t$i.exe > t$i.log 2>&1; then tb=$((tb+1)); echo "TIKO-BUILD $i: $(grep -m1 -E 'error|ICE' t$i.log)"; i=$((i+1)); continue; fi
  timeout 20 ./f$i.exe < /dev/null > f$i.txt 2>&1; fr=$?
  timeout 20 ./t$i.exe < /dev/null > t$i.txt 2>&1; tr_=$?
  if [ $tr_ -ne $fr ]; then tc=$((tc+1)); echo "TIKO-CRASH $i: fbc exit $fr, tiko exit $tr_"; i=$((i+1)); continue; fi
  if cmp -s f$i.txt t$i.txt; then
    m=$((m+1)); rm -f f$i.exe t$i.exe f$i.log t$i.log f$i.txt t$i.txt p$i.bas
  else
    df=$((df+1)); echo "DIFF $i: $(diff f$i.txt t$i.txt | head -3 | tr '\n' ' ')"
  fi
  i=$((i+1))
done
echo "fuzz seeds $FIRST..$last flags=[$FLAGS]: $m match, $df diff, $tc crash, $tb tiko-build, $ff fbc-fail"
