#!/bin/sh
# genbind.sh -- regenerate tiko-rt's C library binding for this host's target.
#
#   lib/rt/build/genbind.sh            on Windows: src/inc/sysbind/win64.bi
#                                      on Linux:   src/inc/sysbind/linux-x86_64.bi
#
# tiko's own C importer (-cimport, decision 0016) reads lib/rt/build/sysbind.h against the
# host's C headers -- MinGW-w64's on Windows, the system's glibc on Linux -- and genbind.py
# keeps the declarations tiko-rt's sources name and what those need. Each target's binding
# is made on its own host, because that is where its headers are native.
#
# RUN IT AFTER THE RUNTIME STARTS USING ANOTHER C FUNCTION, and commit the result: the
# binding is generated but CHECKED IN, so a build needs no libclang and a review sees every
# declaration the runtime depends on. windows-x86_64 builds from win64.bi (fbc compiles it AS
# win64); inc/sysbind.bi holds the streams, errno and jmp_buf no importer can carry.
#
# PROVED EQUIVALENT to fbc's crt/*.bi when it replaced them (2026-09-24): every runtime
# object built from it was byte-identical to the one built from crt/ on win64, and on
# windows-x86_64 and linux-x86_64 differed only in fbc's local label numbers, the COFF
# timestamp and alignment padding.
set -eu
cd "$(dirname "$0")/.."
RT=$(pwd)
ROOT=$(cd ../.. && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TARGET=win64; TKO=${TKO:-$ROOT/bin/tiko.exe}; PY=${PYTHON:-python} ;;
    *) TARGET=linux-x86_64; TKO=${TKO:-$ROOT/bin/tiko}; PY=${PYTHON:-python3} ;;
esac
WK=${TMPDIR:-/tmp}/genbind.$$
mkdir -p "$WK"
trap 'rm -rf "$WK"' EXIT
"$TKO" -target "$TARGET" -cimport build/sysbind.h -cimport-out "$WK/full.bi"
"$PY" build/genbind.py "$WK/full.bi" src "$TARGET" "src/inc/sysbind/$TARGET.bi"
