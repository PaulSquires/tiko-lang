#!/bin/sh
# implibs.sh -- windows-x86_64's import libraries from COMMITTED .def files, not from fbc.
#
#   build/implibs.sh build  [--defs lib/implib] --out <lib dir>
#   build/implibs.sh export --from <dir of lib*.dll.a> [--to lib/implib]
#
# build/mkmsvcimplibs.sh used to regenerate all 843 .lib files at every package run
# from fbc's MinGW lib*.dll.a (a toolchain's lib/win64-fb, a copy of fbc-modern's
# lib/win64), through build/mkmsvcdef.py, and threw the .def files away. Since
# 2026-10-10 the .def files are KEPT, in lib/implib/, and package.sh builds from them:
# the default target's import libraries no longer need fbc's tree to exist.
#
# Why it matters, measured 2026-09-06: without them clang's msvc driver passes
# -libpath for an installed Visual Studio and Windows SDK, so windows-x86_64 linked only
# on a machine with both. Why the format: lld-link reads a GNU import archive, but an
# MSVC short import is a quarter the size (kernel32: 1.5 MB against 365 KB). Why the
# DATA split is the hard part, and how it was got wrong twice: build/mkmsvcdef.py.
#
# export -- ONCE. Runs the same mkmsvcdef.py over the same inputs and KEEPS each
#           <name>.def in --to; copies the GUID/data archives (no exports, R/D
#           symbols -- uuid, dxguid, ...) to --to/static/<name>.lib. Writes
#           --to/EXPORTED.txt with the inputs, the machine, and the counts: the
#           code/data split consults this machine's System32 (mkmsvcdef.py), so the
#           result is a snapshot and is recorded as one. Run it only to pick up a
#           NEW library, and read the .def diff it makes.
# build  -- EVERY package run. llvm-dlltool per .def, static/*.lib copied through.
#           Reads nothing outside --defs. Same command line as mkmsvcimplibs.sh.
#
# lib/implib/ is derived from mingw-w64's import libraries: ZPL 2.1, with parts in
# the public domain -- lib/implib/COPYING.MinGW-w64-runtime.txt, which ships with them.

set -e

MODE=${1:-}; [ $# -gt 0 ] && shift
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TREE="$ROOT"; FROM=""; TO="$ROOT/lib/implib"; DEFS="$ROOT/lib/implib"; OUTD=""
while [ $# -gt 0 ]; do
    case "$1" in
        --tree) shift; TREE="$1" ;;
        --from) shift; FROM="$1" ;;
        --to)   shift; TO="$1" ;;
        --defs) shift; DEFS="$1" ;;
        --out)  shift; OUTD="$1" ;;
        *) echo "implibs: unknown argument '$1'" >&2; exit 2 ;;
    esac
    shift
done
say( )  { echo "implibs: $*"; }
fail( ) { echo "implibs: FAILED -- $*" >&2; exit 1; }
LLVM=${LLVM_BIN:-"C:/Program Files/LLVM/bin"}
[ -x "$LLVM/llvm-dlltool.exe" ] || [ -x "$LLVM/llvm-dlltool" ] || fail "no llvm-dlltool in $LLVM (set LLVM_BIN)"
DLLTOOL="$LLVM/llvm-dlltool"; [ -x "$DLLTOOL.exe" ] && DLLTOOL="$DLLTOOL.exe"
NM="$LLVM/llvm-nm";           [ -x "$NM.exe" ] && NM="$NM.exe"

case "$MODE" in
export)
    [ -n "$TREE" ] && [ -n "$FROM" ] && [ -n "$TO" ] || fail "export needs --from"
    [ -f "$TREE/build/mkmsvcdef.py" ] || fail "no build/mkmsvcdef.py in $TREE"
    [ -d "$FROM" ] || fail "no directory $FROM"
    mkdir -p "$TO/static"
    export LLVM_BIN="$LLVM"
    made=0; stat=0; empty=0; codes=0; datas=0
    for f in "$FROM"/*.dll.a; do
        [ -f "$f" ] || continue
        name=$(basename "$f" .dll.a); name=${name#lib}
        [ -n "$name" ] || continue
        if counts=$(python "$TREE/build/mkmsvcdef.py" "$f" "$name.dll" "$TO/$name.def" 2>/dev/null); then
            made=$((made + 1))
            codes=$((codes + $(echo "$counts" | cut -d' ' -f1)))
            datas=$((datas + $(echo "$counts" | cut -d' ' -f2)))
        else
            rm -f "$TO/$name.def"
            if "$NM" "$f" 2>/dev/null | grep -qE '^[0-9a-f]+ [RrDd] '; then
                cp "$f" "$TO/static/$name.lib"; stat=$((stat + 1))
            else
                empty=$((empty + 1))
            fi
        fi
    done
    {
        echo "exported  $(date -u +%Y-%m-%dT%H:%M:%SZ) on $(uname -n 2>/dev/null || echo unknown)"
        echo "from      $FROM"
        echo "tool      $TREE/build/mkmsvcdef.py ($(git -C "$TREE" rev-parse --short=12 HEAD 2>/dev/null || echo '?'))"
        echo "windows   $(cmd.exe //c ver 2>/dev/null | tr -d '\r' | grep -i version || echo unknown)"
        echo "defs      $made ($codes code exports, $datas data exports)"
        echo "static    $stat GUID/data archives copied through, unconverted"
        echo "empty     $empty import archives with no exports, skipped"
        echo
        echo "The code/data split consulted this machine's System32 DLLs (mkmsvcdef.py)."
        echo "Re-export only to pick up a NEW library; review the .def diff by hand."
    } > "$TO/EXPORTED.txt"
    cat "$TO/EXPORTED.txt"
    ;;
build)
    [ -n "$DEFS" ] && [ -n "$OUTD" ] || fail "build needs --defs and --out"
    [ -d "$DEFS" ] || fail "no directory $DEFS"
    mkdir -p "$OUTD"
    made=0; failed=0
    for d in "$DEFS"/*.def; do
        [ -f "$d" ] || continue
        name=$(basename "$d" .def)
        if "$DLLTOOL" -m i386:x86-64 -d "$d" -l "$OUTD/$name.lib" 2>/dev/null; then made=$((made + 1))
        else failed=$((failed + 1)); echo "implibs: FAILED $name" >&2; fi
    done
    nstat=0
    for s in "$DEFS"/static/*.lib; do [ -f "$s" ] && cp "$s" "$OUTD/" && nstat=$((nstat + 1)); done
    say "$made import libraries from .def, $nstat static archives copied, $failed failed -> $OUTD"
    [ "$failed" = "0" ] || exit 1
    ;;
*)
    sed -n '2,23p' "$0"; exit 2 ;;
esac
