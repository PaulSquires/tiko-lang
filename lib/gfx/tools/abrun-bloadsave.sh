#!/bin/sh
# abrun-bloadsave.sh -- compile abrun-bloadsave.bas with fbc-modern and with tiko,
# run both, and diff their output. Install the libtkogfx.a under test into
# toolchains/tiko-windows/lib/win64-msvc first.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception).
set -e
HERE=$( cd "$( dirname "$0" )" && pwd )
TL=$( cd "$HERE/../../.." && pwd )
: "${FBC:=/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}"
: "${TIKO:=$TL/bin/tiko.exe}"
OUT=$( mktemp -d )
cp "$HERE/abrun-bloadsave.bas" "$OUT/"
cd "$OUT"
"$FBC" abrun-bloadsave.bas -x ref.exe
"$TIKO" -i "$TL/toolchains/tiko-windows/inc" -p "$TL/toolchains/tiko-windows/lib/win64-msvc" \
    abrun-bloadsave.bas -o sub.exe
./ref.exe > ref.txt
./sub.exe > sub.txt
if diff ref.txt sub.txt; then
    echo "abrun-bloadsave: PASS -- $(wc -l < ref.txt) lines identical"
    cd / && rm -rf "$OUT"
else
    echo "abrun-bloadsave: FAIL -- outputs kept in $OUT"
    exit 1
fi
