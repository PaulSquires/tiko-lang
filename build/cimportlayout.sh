#!/bin/sh
# cimportlayout.sh -- every imported record's layout, as a clang-COMPILED program sees it.
#
#   bash build/cimportlayout.sh
#
# The importer asks libclang for each record's size, alignment and member offsets and
# writes them to the manifest; -cimport then checks tiko's own layout against that. This
# asks the other question: is the manifest what clang's CODE GENERATION does? For each
# header and each target this host can run, build/cimportlayout.py writes a C program that
# prints sizeof, _Alignof and offsetof for every record the manifest names, clang compiles
# and runs it, and the output must equal the manifest's own numbers.
#
# For windows-x86_64 it is the only oracle there is: fbc-modern cannot import for that target.
# Bit-fields are not here -- C has no offsetof for one -- and neither is a record C cannot
# spell; the manifest check covers both.
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TARGETS="windows-x86_64 win64"; TKO=${TKO:-$ROOT/bin/tiko.exe}; PY=${PYTHON:-python}; EXE=.exe ;;
    *) TARGETS="linux-x86_64"; TKO=${TKO:-$ROOT/bin/tiko}; PY=${PYTHON:-python3}; EXE= ;;
esac
case "$TKO" in /*) ;; *) TKO=$ROOT/$TKO ;; esac   # the script changes directory
CLANG=${CLANG:-clang}
WK=${TMPDIR:-/tmp}/cimportlayout.$$
mkdir -p "$WK"
trap 'rm -rf "$WK"' EXIT

triple() {
    case "$1" in
        windows-x86_64) echo x86_64-pc-windows-msvc ;;
        win64) echo x86_64-w64-windows-gnu ;;
        linux-x86_64) echo x86_64-pc-linux-gnu ;;
    esac
}

HEADERS="tests/cimport/src/probe.h tests/cimport/src/shapes.h tests/cimport/src/layout.h tests/cimport/src/msext.h tests/cimport/src/ci/a.h"
[ -n "$EXE" ] && HEADERS="$HEADERS windows.h"

nrun=0; nok=0; nbad=0
for t in $TARGETS; do
    for h in $HEADERS; do
        tag=$(basename "$h" .h).$t
        nrun=$((nrun + 1))
        if ! "$TKO" -target "$t" -cimport "$h" -cimport-out "$WK/$tag.bi" -cimport-manifest "$WK/$tag.man" > "$WK/$tag.log" 2>&1; then
            echo "$tag: tiko could not import"; sed -n 1,3p "$WK/$tag.log"; nbad=$((nbad + 1)); continue
        fi
        # A quoted header resolves against the working directory, as #cinclude's does.
        hinc=$h
        case "$h" in tests/*) hinc=$ROOT/$h ;; esac
        "$PY" build/cimportlayout.py gen "$WK/$tag.man" "$hinc" "$WK/$tag.c"
        "$PY" build/cimportlayout.py want "$WK/$tag.man" "$WK/$tag.want"
        if ! "$CLANG" --target="$(triple "$t")" -w -o "$WK/$tag$EXE" "$WK/$tag.c" > "$WK/$tag.cc.log" 2>&1; then
            echo "$tag: clang could not build the oracle"; sed -n 1,5p "$WK/$tag.cc.log"; nbad=$((nbad + 1)); continue
        fi
        "$WK/$tag$EXE" | tr -d '\r' > "$WK/$tag.got"
        if diff "$WK/$tag.want" "$WK/$tag.got" > "$WK/$tag.diff"; then
            echo "$tag: $(grep -c '^record' "$WK/$tag.want") records, every size, alignment and offset as clang compiles them"
            nok=$((nok + 1))
        else
            echo "$tag: DIFFERS from the compiled program"; head -20 "$WK/$tag.diff"; nbad=$((nbad + 1))
        fi
    done
done
echo "cimportlayout: $nrun imports -- $nok agree, $nbad do not"
[ $nbad -eq 0 ]
