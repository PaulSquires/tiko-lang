#!/bin/sh
# aapcsig.sh -- the AAPCS64 (Apple) signature lane: tiko's lowering against clang's.
#
#   build/aapcsig.sh
#
# tests/abi/apple/sig.c and sig.tiko declare the same shapes -- integer aggregates of 1 to
# 17 bytes, HFAs of 1 to 5 floats and doubles (nested, arrayed, a union), mixed float and
# integer, and register-exhausting prefixes -- passed and returned by value, called in
# both directions. Both are compiled to LLVM IR for arm64-apple-macosx13.0, clang's by
# clang and tiko's by bin/tiko, and build/aapcsig.py compares every signature.
#
# WHY: no Mac is needed. The registers an argument travels in are decided by the IR
# signature, so matching clang's -- the platform's own C compiler -- is the static half
# of the ABI. The running half (a C library called and calling back) needs a Mac:
# build/aapcslane.sh.
#
# Needs clang (TKO_CLANG, else on PATH) and python. Exits 1 on any difference.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *) EXT="" ;;
esac
TKO="$ROOT/bin/tiko$EXT"
[ -x "$TKO" ] || { echo "aapcsig: build tiko first (build/build.sh)" >&2; exit 3; }
CLANG=${TKO_CLANG:-clang}
command -v "$CLANG" > /dev/null 2>&1 || { echo "aapcsig: no clang (set TKO_CLANG)" >&2; exit 3; }
PY=${PYTHON:-python}
command -v "$PY" > /dev/null 2>&1 || PY=python3

W="$ROOT/build/.aapcsig"
mkdir -p "$W"
T=arm64-apple-macosx13.0
"$CLANG" -target $T -O0 -S -emit-llvm "$ROOT/tests/abi/apple/sig.c" -o "$W/c.ll" || exit 2
"$TKO" -target macos-arm64 --emit-ir "$ROOT/tests/abi/apple/sig.tiko" > "$W/t.ll" || exit 2
# The IR must also be IR clang accepts for the target, or the comparison proves nothing.
"$CLANG" -target $T -Wno-override-module -c "$W/t.ll" -o "$W/t.o" || exit 2
"$PY" -I "$ROOT/build/aapcsig.py" "$W/c.ll" "$W/t.ll"
