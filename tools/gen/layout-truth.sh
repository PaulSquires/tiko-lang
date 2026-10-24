#!/bin/sh
# layout-truth.sh -- derive builtin sizes and alignments from fbc.
#
#   tools/gen/layout-truth.sh
#
# Writes tests/types/expected/fbc-layout.txt (win64) and
# tests/types/expected/fbc-layout-linux-x86_64.txt.
#
# THE PROBE IS RUN, NOT READ, so each half needs a host that can EXECUTE what fbc
# produced. On Windows the Linux half goes through WSL, which is how the runtime
# gate already builds for that target; on Linux the win64 half is skipped. Neither
# half is silently omitted -- a skip says so and the file it would have written is
# left exactly as it was.
#
# The output is the REFERENCE the type system is checked against: tiko-lang's own
# --dump-types must agree with it. Re-run after a toolchain change; a diff in the
# result is a compatibility event, not a formatting one.

set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
. "$(dirname "$0")/../../build/toolchain.sh"    # TKO_ORACLE_FBC, TKO_ORACLE_ROOT, TKO_CLANG (BLD-12)
FBC64=$TKO_ORACLE_FBC
FBC32=${TKO_FBC32:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc32.exe}
# IN THE REPO, not mktemp -d. Git Bash puts /tmp under the user's AppData, which
# is not on the C: mount WSL sees -- so the Linux half below was handed a path
# that did not exist inside WSL, fbc failed with its output discarded, and
# 'set -e' killed the script before it could say so.
TMP="$ROOT/build/.lay"
rm -rf "$TMP"; mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

BUILTINS="byte ubyte short ushort long ulong integer uinteger longint ulongint single double boolean string cva_list"

# WSTRING IS THE ONE THAT WILL NOT FIT THE TEMPLATE. 'as wstring field' is fbc's
# error 28 -- a var-len wstring may only be a POINTER in a type -- so its alignment
# is probed through a FIXED-LENGTH one, whose alignment is the code unit's. sizeof
# still answers for the type itself: 2 on win64, 4 on linux-x86_64, and that is the
# whole reason this file is now generated per target instead of once.
#
# cva_list rides the ordinary template and is the other one that moves: 8 bytes on
# win64, 24 on linux-x86_64, where SysV's va_list is __va_list_tag[1].

{
    for b in $BUILTINS; do
        echo "type T_$b"
        echo "    as byte pad"
        echo "    as $b field"
        echo "end type"
    done
    echo "type T_wstring"
    echo "    as byte pad"
    echo "    as wstring * 2 field"
    echo "end type"
    echo ""
    for b in $BUILTINS; do
        echo "scope"
        echo "    dim as T_$b t"
        echo "    print \"$b \"; sizeof($b); \" \"; cast(integer,@t.field) - cast(integer,@t.pad)"
        echo "end scope"
    done
    echo "scope"
    echo "    dim as T_wstring t"
    echo "    print \"wstring \"; sizeof(wstring); \" \"; cast(integer,@t.field) - cast(integer,@t.pad)"
    echo "end scope"
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

case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) HOSTWIN=1 ;; *) HOSTWIN=0 ;; esac

if [ "$HOSTWIN" = "1" ]; then
    one "$FBC64" "$ROOT/tests/types/expected/fbc-layout.txt" win64
else
    echo "layout-truth: win64: skipped -- needs a Windows host to run the probe" >&2
fi

# ---------------------------------------------------------------- linux-x86_64
LINUX_FBC=${TKO_LINUX_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-linux/bin/fbc}
LINUX_OUT="$ROOT/tests/types/expected/fbc-layout-linux-x86_64.txt"

if [ "$HOSTWIN" = "0" ]; then
    one "$LINUX_FBC" "$LINUX_OUT" linux-x86_64
elif ! command -v wsl >/dev/null 2>&1; then
    echo "layout-truth: linux-x86_64: skipped -- no WSL" >&2
elif [ ! -f "$LINUX_FBC" ]; then
    # -f, not -x: an ELF binary on an NTFS mount is not executable to Git Bash.
    echo "layout-truth: linux-x86_64: skipped -- no Linux fbc at $LINUX_FBC" >&2
else
    wpath( ) { echo "$1" | sed 's|^/\([a-zA-Z]\)/|/mnt/\1/|'; }
    W_FBC=$(wpath "$LINUX_FBC")
    W_SRC=$(wpath "$TMP/lay.bas")
    W_OUT=$(wpath "$LINUX_OUT")
    if ! wsl -e bash -c "
        set -e
        '$W_FBC' '$W_SRC' -x /tmp/lay-linux
        /tmp/lay-linux | sed 's/  */ /g;s/^ //;s/ \$//' > '$W_OUT'
        rm -f /tmp/lay-linux
    "; then
        echo "layout-truth: linux-x86_64: FAILED -- see the error above" >&2
        exit 1
    fi
    echo "layout-truth: linux-x86_64: $(grep -c . "$LINUX_OUT") builtin types -> $(basename "$LINUX_OUT")"
fi
