#!/bin/sh
# mkmsvcimplibs.sh -- MSVC-format import libraries from fbc's MinGW ones.
#
#   build/mkmsvcimplibs.sh [<from-dir> <to-dir>]
#
# Default: toolchains/tiko-windows/lib/win64-fb -> .../lib/win64-msvc
#
# WHY THIS EXISTS. win64-msvc is the default Windows target, and it resolves its
# system libraries -- kernel32, gdi32, winmm and the rest -- from whatever the
# machine happens to have installed. Measured 2026-09-06: clang's msvc driver
# passes -libpath for Visual Studio 2022 Community and Windows SDK 10.0.26100.
# So the "self-contained" toolchain quietly depends on a Visual Studio install.
# These libraries remove that dependency for the DLLs fbc's tree already covers.
#
# WHAT IS CONVERTED, AND WHAT IS NOT. Only lib<name>.dll.a -- the import
# libraries. The static archives beside them (libfb.a, libgcc.a, libmingwex.a,
# libstdc++.a, libsqlite3.a ...) and the CRT objects are MinGW builds: they carry
# MinGW CRT dependencies and belong to the win64 target, which is exactly why
# win64-msvc has no -fb directory of its own. Copying them into an MSVC directory
# would put the wrong runtime within reach of a -l.
#
# THE FORMAT IS GENUINELY DIFFERENT, not a rename. lld-link DOES read a GNU
# import archive -- measured, and it links and produces a correct import table --
# so renaming would have worked. What it would not have produced is an MSVC
# short-import library: kernel32 is 1.5 MB as a GNU archive and 365 KB as a short
# import.
#
# THE ONE THING THAT HAD TO BE MEASURED is which exports are DATA. Getting it
# wrong is silent: a function marked DATA links, and the caller loads a pointer
# where it should have called a thunk. The GNU archive encodes it structurally --
# an import member defines __imp_X, and a CODE import additionally defines the
# thunk X in the same member, where a DATA import does not.
#
# It took two attempts to get right, and build/mkmsvcdef.py carries the record.
# The first collected every __imp_ symbol in the archive and called msvcrt's
# GetProcAddress a data export -- undefined REFERENCES from real objects inside
# the archive were being counted as exports of it. The second asked whether the
# member also defined a thunk, which is right for most of fbc's libraries and
# wrong for ucrtbase, where 63 thunk-less exports are functions: floor and
# floorf among them, which is how it was caught. The answer now comes from the
# DLL, where an export whose RVA lands in an executable section is code.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
FROM=${1:-"$ROOT/toolchains/tiko-windows/lib/win64-fb"}
TO=${2:-"$ROOT/toolchains/tiko-windows/lib/win64-msvc"}
LLVM=${LLVM_BIN:-"C:/Program Files/LLVM/bin"}

die( ) { echo "mkmsvcimplibs: $*" >&2; exit 1; }
[ -d "$FROM" ] || die "no source directory $FROM"
[ -d "$TO" ]   || die "no target directory $TO"
[ -x "$LLVM/llvm-nm.exe" ] || die "no llvm-nm at $LLVM (set LLVM_BIN)"
[ -x "$LLVM/llvm-dlltool.exe" ] || die "no llvm-dlltool at $LLVM (set LLVM_BIN)"

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT


export LLVM_BIN="$LLVM"
made=0; empty=0; failed=0; codes=0; datas=0
for f in "$FROM"/*.dll.a; do
    [ -f "$f" ] || continue
    base=$(basename "$f" .dll.a)          # libkernel32
    name=${base#lib}                      # kernel32
    [ -n "$name" ] || continue
    if counts=$( python "$ROOT/build/mkmsvcdef.py" "$f" "$name.dll" "$WORK/$name.def" 2>/dev/null ); then
        if "$LLVM/llvm-dlltool.exe" -m i386:x86-64 -d "$WORK/$name.def" \
             -l "$TO/$name.lib" 2>/dev/null; then
            made=$(( made + 1 ))
            codes=$(( codes + $(echo "$counts" | cut -d' ' -f1) ))
            datas=$(( datas + $(echo "$counts" | cut -d' ' -f2) ))
        else
            failed=$(( failed + 1 ))
            echo "mkmsvcimplibs: FAILED $name" >&2
        fi
    else
        # An import library with no exports at all. Real: fbc's tree carries a
        # few placeholder archives. Nothing to generate, and a .lib with no
        # members would only be a file that resolves nothing.
        empty=$(( empty + 1 ))
    fi
done

echo "mkmsvcimplibs: $made libraries, $codes code exports, $datas data exports"
echo "mkmsvcimplibs: $empty with no exports (skipped), $failed failed"
[ "$failed" = "0" ] || die "$failed conversions failed"
