#!/bin/sh
# layout-truth.sh -- derive builtin sizes and alignments from fbc.
#
#   tools/gen/layout-truth.sh
#
# Writes tests/types/expected/fbc-layout.txt and fbc-layout-win32.txt. The win32 half
# comes from a different fbc, because fbc-modern has no 32-bit build; run
# tools/gen/control.py for what that costs.
#
# The output is the REFERENCE the type system is checked against: fbx's own
# --dump-types must agree with it. Re-run after a toolchain change; a diff in the
# result is a compatibility event, not a formatting one.

set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
FBC64=${FBX_STAGE0:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
FBC32=${FBX_FBC32:-/c/dev/tiko_editor/toolchains/FreeBASIC-1.10.1-winlibs-gcc-9.3.0/fbc32.exe}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

BUILTINS="byte ubyte short ushort long ulong integer uinteger longint ulongint single double boolean string"

{
    for b in $BUILTINS; do
        echo "type T_$b"
        echo "    as byte pad"
        echo "    as $b field"
        echo "end type"
    done
    echo ""
    for b in $BUILTINS; do
        echo "scope"
        echo "    dim as T_$b t"
        echo "    print \"$b \"; sizeof($b); \" \"; cast(integer,@t.field) - cast(integer,@t.pad)"
        echo "end scope"
    done
} > "$TMP/lay.bas"

one( ) {
    fbc=$1; out=$2; label=$3
    if [ ! -x "$fbc" ]; then
        echo "layout-truth: $label: no fbc at $fbc" >&2
        return 3
    fi
    "$fbc" "$TMP/lay.bas" -x "$TMP/lay-$label.exe" >/dev/null 2>&1
    # The probe is RUN, not read: sizeof and the field offset are what the produced
    # program prints, so this is the layout the target actually has rather than one
    # inferred from a declaration.
    "$TMP/lay-$label.exe" | sed 's/  */ /g;s/^ //;s/ $//' > "$out"
    echo "layout-truth: $label: $(grep -c . "$out") builtin types -> $(basename "$out")"
}

one "$FBC64" "$ROOT/tests/types/expected/fbc-layout.txt"       win64
one "$FBC32" "$ROOT/tests/types/expected/fbc-layout-win32.txt" win32
