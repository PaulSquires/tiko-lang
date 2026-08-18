#!/bin/sh
# layout-truth.sh -- derive builtin sizes and alignments from fbc.
#
#   tools/gen/layout-truth.sh > tests/types/expected/fbc-layout.txt
#
# The output is the REFERENCE the type system is checked against: fbx's own
# --dump-types must agree with it. Re-run after a toolchain change; a diff in the
# result is a compatibility event, not a formatting one.

set -e
FBC=${FBX_STAGE0:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
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

"$FBC" "$TMP/lay.bas" -x "$TMP/lay.exe" >/dev/null 2>&1
"$TMP/lay.exe" | sed 's/  */ /g;s/^ //;s/ $//'
