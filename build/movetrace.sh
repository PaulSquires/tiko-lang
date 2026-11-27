#!/bin/sh
# movetrace.sh [--record] -- RFC 0018's counting probes: copies and moves, per site.
#
#   bash build/movetrace.sh            build and run every tests/semantic/moves/*.bas with
#                                      bin/tiko.exe and diff each trace against its baseline
#   bash build/movetrace.sh --record   rewrite the baselines: <name>.p0-trace from tiko and
#                                      <name>.fbc-trace from the oracle fbc (fbc-modern 1.20)
#
# THE BASELINE IS TODAY'S TIKO, NOT FBC. RFC 0018 changes structor counts on purpose
# (V7), so after P1 the M* cases are SUPPOSED to differ from .p0-trace and the C* cases
# are not. A difference is therefore read case by case, never as a plain failure -- the
# probe's own header says which cases may move. The .fbc-trace files are the record of
# what fbc does; at P0 they are identical to .p0-trace.
#
# A probe that does not build (noncopyable.bas, today) records the compiler's exit code and
# its diagnostics in place of a trace, so V4's "now it compiles" shows up as a diff too.
#
# Exits 0 when every trace matches its baseline, 1 when any differs, 77 when no oracle fbc
# is found and --record was asked for.

set -u
cd "$(dirname "$0")/.."
. build/toolchain.sh

TIKO=${TIKO:-./bin/tiko.exe}
FBC=${FBC:-${TIKO_ORACLE_FBC:-}}
DIR=tests/semantic/moves
OUT=build/.movetrace
[ -x "$TIKO" ] || { echo "movetrace: build $TIKO first" >&2; exit 3; }
mkdir -p "$OUT"

record=0
[ "${1:-}" = "--record" ] && record=1
if [ $record -eq 1 ] && [ ! -x "$FBC" ]; then
    echo "movetrace: no oracle fbc at '$FBC' -- set FBC= or TIKO_ORACLE_FBC=" >&2
    exit $TKO_SKIP
fi

# probe <compiler-kind> <source> <name> -> writes $OUT/<name>.<kind>.trace
probe() {
    kind=$1 src=$2 n=$3
    exe="$OUT/$n.$kind.exe"
    trace="$OUT/$n.$kind.trace"
    rm -f "$exe"
    if [ "$kind" = tiko ]; then
        "$TIKO" "$src" -x "$exe" > "$OUT/$n.$kind.diag" 2>&1
    else
        "$FBC" -gen gas64 "$src" -x "$exe" > "$OUT/$n.$kind.diag" 2>&1
    fi
    rc=$?
    if [ $rc -ne 0 ] || [ ! -x "$exe" ]; then
        { echo "BUILD FAILED rc=$rc"; tr -d '\r' < "$OUT/$n.$kind.diag"; } > "$trace"
        return
    fi
    timeout 30 "$exe" < /dev/null 2>&1 | tr -d '\r' > "$trace"
    rc=$?
    [ $rc -ne 0 ] && echo "RUN rc=$rc" >> "$trace"
}

same=0 diffs=0
for src in "$DIR"/*.bas; do
    n=$(basename "$src" .bas)
    probe tiko "$src" "$n"
    if [ $record -eq 1 ]; then
        probe fbc "$src" "$n"
        cp "$OUT/$n.tiko.trace" "$DIR/$n.p0-trace"
        cp "$OUT/$n.fbc.trace"  "$DIR/$n.fbc-trace"
        if cmp -s "$DIR/$n.p0-trace" "$DIR/$n.fbc-trace"; then
            echo "recorded  $n  (tiko = fbc)"
        else
            echo "recorded  $n  (tiko DIFFERS from fbc -- read the diff before relying on it)"
        fi
        continue
    fi
    if cmp -s "$OUT/$n.tiko.trace" "$DIR/$n.p0-trace"; then
        echo "same      $n"
        same=$((same + 1))
    else
        echo "DIFF      $n"
        diff "$DIR/$n.p0-trace" "$OUT/$n.tiko.trace" | grep '^[<>] [A-Z][0-9]*:' | sed 's/^/          /'
        diffs=$((diffs + 1))
    fi
done

[ $record -eq 1 ] && exit 0
echo "movetrace: $same same, $diffs differ from the P0 baseline"
[ $diffs -eq 0 ]
