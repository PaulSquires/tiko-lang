#!/bin/sh
# movetrace.sh [--record <phase>] -- RFC 0018's counting probes: copies and moves, per site.
#
#   bash build/movetrace.sh               build and run every tests/semantic/moves/*.bas with
#                                         bin/tiko.exe and diff each trace against its LATEST
#                                         baseline: the highest <name>.pN-trace there is
#   bash build/movetrace.sh --record p1   write <name>.p1-trace from tiko for every probe
#   bash build/movetrace.sh --record p0   ...and, for p0 only, <name>.fbc-trace from the
#                                         oracle fbc (fbc-modern 1.20)
#
# ONE BASELINE PER PHASE, KEPT. RFC 0018 changes structor counts on purpose (V7), so each
# phase records what tiko printed once that phase was accepted, and the earlier ones stay
# beside it: diffing .p0-trace against .p1-trace shows exactly what P1 moved. A difference
# from the latest baseline is read case by case -- each probe's header says which cases may
# move -- never as a plain failure. The .fbc-trace files are the record of what fbc does.
#
# A probe that does not build (noncopyable.bas, today) records the compiler's exit code and
# its diagnostics in place of a trace, so V4's "now it compiles" shows up as a diff too. A
# probe whose header carries "'' TIKO-ONLY" uses a tiko extension and gets no .fbc-trace.
#
# Exits 0 when every trace matches its baseline, 1 when any differs, 77 when no oracle fbc
# is found and '--record p0' was asked for.

set -u
cd "$(dirname "$0")/.."
. build/toolchain.sh

TIKO=${TIKO:-./bin/tiko.exe}
FBC=${FBC:-${TIKO_ORACLE_FBC:-}}
DIR=tests/semantic/moves
OUT=build/.movetrace
[ -x "$TIKO" ] || { echo "movetrace: build $TIKO first" >&2; exit 3; }
mkdir -p "$OUT"

phase=""
if [ "${1:-}" = "--record" ]; then
    phase=${2:-}
    case "$phase" in
        p[0-9]*) ;;
        *) echo "movetrace: --record wants a phase, p0, p1, ..." >&2; exit 2 ;;
    esac
fi
if [ "$phase" = "p0" ] && [ ! -x "$FBC" ]; then
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

# The latest baseline of probe <name>: its highest-numbered .pN-trace, or nothing.
latest() {
    ls "$DIR/$1".p[0-9]*-trace 2>/dev/null | sed 's/.*\.p\([0-9]*\)-trace$/\1 &/' | sort -n | tail -1 | cut -d' ' -f2
}

same=0 diffs=0
for src in "$DIR"/*.bas; do
    n=$(basename "$src" .bas)
    probe tiko "$src" "$n"
    if [ -n "$phase" ]; then
        cp "$OUT/$n.tiko.trace" "$DIR/$n.$phase-trace"
        note=""
        if [ "$phase" = "p0" ] && ! grep -q "^'' TIKO-ONLY" "$src"; then
            probe fbc "$src" "$n"
            cp "$OUT/$n.fbc.trace" "$DIR/$n.fbc-trace"
            if cmp -s "$DIR/$n.p0-trace" "$DIR/$n.fbc-trace"; then note="  (tiko = fbc)"
            else note="  (tiko DIFFERS from fbc -- read the diff before relying on it)"; fi
        fi
        echo "recorded  $n.$phase-trace$note"
        continue
    fi
    base=$(latest "$n")
    if [ -z "$base" ]; then
        echo "NO BASE   $n  (record one with --record pN)"
        diffs=$((diffs + 1))
        continue
    fi
    if cmp -s "$OUT/$n.tiko.trace" "$base"; then
        echo "same      $n  ($(basename "$base"))"
        same=$((same + 1))
    else
        echo "DIFF      $n  (against $(basename "$base"))"
        diff "$base" "$OUT/$n.tiko.trace" | grep '^[<>] [A-Z][0-9]*:' | sed 's/^/          /'
        diffs=$((diffs + 1))
    fi
done

[ -n "$phase" ] && exit 0
echo "movetrace: $same same, $diffs differ from their latest baseline"
[ $diffs -eq 0 ]
