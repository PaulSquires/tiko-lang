#!/bin/sh
# gate-x11layout.sh -- do tiko's X11 bindings lay out what driver/x11 uses as the C
# headers do? Run ON LINUX with the X11 development headers, gcc and a tiko.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception).
#
# driver/x11 reads Xlib's structs through inc/X11's bindings: a wrong offset reads a
# plausible wrong field rather than failing. probe-x11layout.c prints 39 sizes and
# offsets from the C headers, probe-x11layout.bas the same 39 from the bindings,
# and any difference fails the gate. Measured equal on x86-64 Linux, 2026-11-06.
#
# Usage: tools/gate-x11layout.sh        TIKO=<tiko> to choose the compiler
HERE=$( cd "$( dirname "$0" )" && pwd )
ROOT=$( cd "$HERE/../../.." && pwd )
: "${TIKO:=$ROOT/bin/tiko}"
[ -x "$TIKO" ] || { echo "gate-x11layout: no tiko at $TIKO (set TIKO)" >&2; exit 3; }
TMP=$( mktemp -d ); trap 'rm -rf "$TMP"' EXIT
gcc -o "$TMP/c" "$HERE/probe-x11layout.c" || { echo "gate-x11layout: the C probe does not build" >&2; exit 1; }
"$TIKO" "$HERE/probe-x11layout.bas" -i "$ROOT/inc" -o "$TMP/t" > "$TMP/t.log" 2>&1 || { sed -n 1,10p "$TMP/t.log" >&2; exit 1; }
"$TMP/c" > "$TMP/c.out"; "$TMP/t" > "$TMP/t.out"
if diff "$TMP/c.out" "$TMP/t.out"; then
    echo "gate-x11layout: PASS -- $( wc -l < "$TMP/c.out" ) sizes and offsets agree"
else
    echo "gate-x11layout: FAIL -- the bindings and the C headers disagree (above)" >&2
    exit 1
fi
