#!/bin/bash
# derivetrace.sh [--linux] [--record <phase>] -- RFC 0019's probes: derive and the enum intrinsics.
#
#   bash build/derivetrace.sh                 build and run every tests/semantic/derive/*.bas
#                                             and *.tiko with bin/tiko.exe (windows-x86_64) and
#                                             diff each trace against its LATEST baseline, the
#                                             highest <name>.pN-trace there is
#   bash build/derivetrace.sh --linux         the same for linux-x86_64: tiko compiles with
#                                             -target linux-x86_64 -c, WSL's gcc links against
#                                             lib/rt/lib/linux-x86_64, WSL runs it
#   bash build/derivetrace.sh --record p1     write <name>.p1-trace from tiko for every probe
#   bash build/derivetrace.sh --record p0     ...and, for p0 only, <name>.fbc-trace from the
#                                             oracle fbc for every probe not marked TIKO-ONLY
#   bash build/derivetrace.sh --linux --record pN
#                                             write <name>.linux.pN-trace, but ONLY where the
#                                             Linux trace differs from <name>.pN-trace
#
# ONE BASELINE PER PHASE, KEPT, as build/movetrace.sh does for RFC 0018. The .p0-traces of
# eqorder, hashkey, text and enums are ORACLES: hand-written code doing what derive and the
# intrinsics will do, so the derived twins added at P1-P3 must print them exactly. hashes'
# trace must never change at all (R5). contextual's must never change at all (R1, R9).
# syntax.tiko is rejected at P0; its baseline is the diagnostics.
#
# A probe whose header says '' TWIN-OF <oracle> [SED <expr>] is the derived twin of a
# hand-written oracle: it gets no baseline of its own, and its output must equal the oracle's
# latest trace (after the sed expression, when one is given), in every mode.
#
# A Linux baseline exists only where Linux prints something else (a WSTRING is 4 bytes
# there). Without one, the Linux run is diffed against the Windows baseline.
#
# Exits 0 when every trace matches its baseline, 1 when any differs, 3 when a tool is
# missing, 77 when '--record p0' finds no oracle fbc.

set -u
cd "$(dirname "$0")/.."
. build/toolchain.sh

TIKO=${TIKO:-./bin/tiko.exe}
FBC=${FBC:-${TIKO_ORACLE_FBC:-}}
DIR=tests/semantic/derive
OUT=build/.derivetrace
LRT=${TIKO_LINUX_RT:-lib/rt/lib/linux-x86_64}
[ -x "$TIKO" ] || { echo "derivetrace: build $TIKO first" >&2; exit 3; }
mkdir -p "$OUT"

linux=0 phase=""
while [ $# -gt 0 ]; do
    case "$1" in
        --linux) linux=1 ;;
        --record)
            phase=${2:-}
            case "$phase" in p[0-9]*) ;; *) echo "derivetrace: --record wants p0, p1, ..." >&2; exit 2 ;; esac
            shift ;;
        *) echo "derivetrace: unknown argument '$1'" >&2; exit 2 ;;
    esac
    shift
done
if [ $linux -eq 1 ]; then
    command -v wsl > /dev/null 2>&1 || { echo "derivetrace: --linux needs WSL" >&2; exit 3; }
    [ -f "$LRT/libfb.a" ] || { echo "derivetrace: no Linux runtime at $LRT (set TIKO_LINUX_RT)" >&2; exit 3; }
fi
if [ "$phase" = "p0" ] && [ $linux -eq 0 ] && [ ! -x "$FBC" ]; then
    echo "derivetrace: no oracle fbc at '$FBC' -- set FBC= or TIKO_ORACLE_FBC=" >&2
    exit $TKO_SKIP
fi

# A Windows path as WSL sees it: /c/x -> /mnt/c/x.
mnt( ) { echo "$1" | sed 's#^/\([a-zA-Z]\)/#/mnt/\L\1/#'; }

# A build failure is recorded as the exit code and the diagnostics, so a phase that makes a
# probe compile shows up as a diff.
failed( ) {   # failed <rc> <diag> <trace>
    { echo "BUILD FAILED rc=$1"; tr -d '\r' < "$2"; } > "$3"
}

# probe <kind> <source> <name> -> $OUT/<name>.<kind>.trace; kind is tiko, fbc or linux
probe() {
    local kind=$1 src=$2 n=$3 trace diag exe d l rc
    trace="$OUT/$n.$kind.trace"
    diag="$OUT/$n.$kind.diag"
    case "$kind" in
    tiko|fbc)
        exe="$OUT/$n.$kind.exe"
        rm -f "$exe"
        if [ "$kind" = tiko ]; then "$TIKO" "$src" -x "$exe" > "$diag" 2>&1
        else "$FBC" -gen gas64 "$src" -x "$exe" > "$diag" 2>&1; fi
        rc=$?
        if [ $rc -ne 0 ] || [ ! -x "$exe" ]; then failed $rc "$diag" "$trace"; return; fi
        timeout 30 "$exe" < /dev/null 2>&1 | tr -d '\r' > "$trace"
        rc=$? ;;
    linux)
        d="$OUT/linux/$n"
        rm -rf "$d" && mkdir -p "$d"
        "$TIKO" -target linux-x86_64 -c -m "$n" "$src" -o "$d/$n.o" > "$diag" 2>&1
        rc=$?
        if [ $rc -ne 0 ]; then failed $rc "$diag" "$trace"; return; fi
        l=$(mnt "$PWD/$LRT")
        MSYS_NO_PATHCONV=1 timeout 120 wsl bash -c "cd '$(mnt "$PWD/$d")' && \
            gcc -no-pie '$l/fbrt0.o' *.o '$l/libfb.a' -lm -lpthread -ltinfo -o '$n' > link.log 2>&1 \
            || { echo LINK FAILED; cat link.log; exit 1; }; timeout 30 './$n' < /dev/null" 2>&1 \
            | tr -d '\r' > "$trace"
        rc=$? ;;
    esac
    [ $rc -ne 0 ] && echo "RUN rc=$rc" >> "$trace"
}

# The latest baseline of probe <name> for this lane: its highest .pN-trace, preferring the
# Linux one of the same phase on the Linux lane.
latest() {
    local b p
    b=$(ls "$DIR/$1".p[0-9]*-trace 2>/dev/null | sed 's/.*\.p\([0-9]*\)-trace$/\1 &/' | sort -n | tail -1 | cut -d' ' -f2)
    if [ $linux -eq 1 ] && [ -n "$b" ]; then
        p=$(echo "$b" | sed 's/.*\.\(p[0-9]*\)-trace$/\1/')
        [ -f "$DIR/$1.linux.$p-trace" ] && b="$DIR/$1.linux.$p-trace"
    fi
    echo "$b"
}

kind=tiko
[ $linux -eq 1 ] && kind=linux
same=0 diffs=0
for src in "$DIR"/*.bas "$DIR"/*.tiko; do
    [ -f "$src" ] || continue
    n=$(basename "$src"); n=${n%.*}
    probe $kind "$src" "$n"
    # A TWIN has no baseline of its own: its output must be its oracle's latest trace, after
    # the optional sed expression ('' TWIN-OF <oracle> [SED <expr>]).
    twin=$(sed -n "s/^'' TWIN-OF \([A-Za-z0-9_-]*\).*/\1/p" "$src" | head -1)
    if [ -n "$twin" ]; then
        tsed=$(sed -n "s/^'' TWIN-OF [A-Za-z0-9_-]* SED //p" "$src" | head -1)
        base=$(latest "$twin")
        if [ -z "$base" ]; then
            echo "NO BASE   $n  (its oracle $twin has no trace)"
            diffs=$((diffs + 1)); continue
        fi
        if [ -n "$tsed" ]; then sed "$tsed" "$base" > "$OUT/$n.oracle"; else cp "$base" "$OUT/$n.oracle"; fi
        if cmp -s "$OUT/$n.$kind.trace" "$OUT/$n.oracle"; then
            echo "same      $n  (twin of $(basename "$base"))"
            same=$((same + 1))
        else
            echo "DIFF      $n  (twin of $(basename "$base"))"
            diff "$OUT/$n.oracle" "$OUT/$n.$kind.trace" | head -20 | sed 's/^/          /'
            diffs=$((diffs + 1))
        fi
        continue
    fi
    if [ -n "$phase" ]; then
        if [ $linux -eq 1 ]; then
            if cmp -s "$OUT/$n.linux.trace" "$DIR/$n.$phase-trace"; then
                rm -f "$DIR/$n.linux.$phase-trace"
                echo "same      $n  (Linux = Windows, no Linux baseline)"
            else
                cp "$OUT/$n.linux.trace" "$DIR/$n.linux.$phase-trace"
                echo "recorded  $n.linux.$phase-trace  (Linux DIFFERS from Windows -- read the diff)"
            fi
            continue
        fi
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
    if cmp -s "$OUT/$n.$kind.trace" "$base"; then
        echo "same      $n  ($(basename "$base"))"
        same=$((same + 1))
    else
        echo "DIFF      $n  (against $(basename "$base"))"
        diff "$base" "$OUT/$n.$kind.trace" | head -20 | sed 's/^/          /'
        diffs=$((diffs + 1))
    fi
done

[ -n "$phase" ] && exit 0
echo "derivetrace: $same same, $diffs differ from their latest baseline ($kind)"
[ $diffs -eq 0 ]
