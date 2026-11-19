#!/bin/sh
# abilane.sh -- the SysV ABI lane: tiko-compiled code against a gcc-built C library.
#
#   build/abilane.sh
#
# tests/abi/fabi*.bas call into, and are called back from, tests/abi/cabi*.c: UDTs of
# 1..24 bytes by value, mixed float/int eightbytes, odd sizes 3/5/13, variadics, and
# many-scalar prefixes that exhaust the argument registers ('regx( 7 doubles, struct{
# double, double }, double )'). Each .bas is compiled by bin/tiko for linux-x86_64, the
# C side by gcc in WSL, linked there against the Linux tiko-rt, run, and the output
# compared with tests/abi/expected/ -- fbc's output for the same program, or the
# expectation the program prints beside each value.
#
# WHY: every Windows test passed while SysV register classification was wrong (audit
# F-02, F-19): a 3-byte argument was loaded past its slot, and an aggregate split across
# xmm7 and the stack. Only a real System V caller and callee find that.
#
# fabi3/cabi3 is int128 against C's __int128, and runs TWICE: the SysV lane as above, then
# windows-x86_64 with the C side built by clang for x86_64-pc-windows-msvc -- win64 passes
# __int128 by address and returns it in XMM0 (src/codegen/abiint128.tiko), which only a real
# MSVC-ABI callee checks.
# Needs WSL with gcc, and a Linux tiko-rt: TIKO_LINUX_LIB, else the tree's own
# toolchains/tiko-linux/lib, else C:\dev\tiko-lang's. Exits 1 on any difference.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *) echo "abilane: run from Windows (it drives WSL)" >&2; exit 3 ;;
esac
TKO="$ROOT/bin/tiko$EXT"
[ -x "$TKO" ] || { echo "abilane: build tiko first (build/build.sh)" >&2; exit 3; }
command -v wsl > /dev/null 2>&1 || { echo "abilane: needs WSL" >&2; exit 3; }

L=${TIKO_LINUX_LIB:-}
[ -n "$L" ] || { [ -d "$ROOT/toolchains/tiko-linux/lib" ] && L="$ROOT/toolchains/tiko-linux/lib"; }
[ -n "$L" ] || L=/c/dev/tiko-lang/toolchains/tiko-linux/lib
[ -f "$L/linux-x86_64/libfb.a" ] || { echo "abilane: no Linux tiko-rt under $L (set TIKO_LINUX_LIB)" >&2; exit 3; }

W="$ROOT/build/.abilane"
mkdir -p "$W"
# A Windows path as WSL sees it: /c/x -> /mnt/c/x.
mnt( ) { echo "$1" | sed 's#^/\([a-zA-Z]\)/#/mnt/\L\1/#'; }

fail=0
for b in fabi fabi2 fabi3; do
    c=$(echo $b | sed 's/^f/c/')
    if ! "$TKO" -target linux-x86_64 -c -m $b "$ROOT/tests/abi/$b.bas" -o "$W/$b.o" > "$W/$b.tiko.log" 2>&1; then
        echo "FAIL $b: tiko did not compile it"; head -5 "$W/$b.tiko.log"; fail=1; continue
    fi
    MSYS_NO_PATHCONV=1 wsl bash -c "cd '$(mnt "$W")' && gcc -O1 -c '$(mnt "$ROOT/tests/abi/$c.c")' -o $c.o && \
        gcc -no-pie '$(mnt "$L")/linux-x86_64/fbrt0.o' $b.o $c.o '$(mnt "$L")/linux-x86_64/libfb.a' \
            -lm -lpthread -ltinfo -o $b && ./$b" > "$W/$b.out" 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
        echo "FAIL $b: link or run exited $rc"; tail -5 "$W/$b.out"; fail=1; continue
    fi
    if tr -d '\r' < "$W/$b.out" | cmp -s - "$ROOT/tests/abi/expected/$b.txt"; then
        echo "PASS $b"
    else
        echo "FAIL $b: output differs (< expected  > tiko)"
        tr -d '\r' < "$W/$b.out" | diff "$ROOT/tests/abi/expected/$b.txt" - | head -20
        fail=1
    fi
done
# THE WIN64 HALF, int128 only: clang compiles the C, tiko links it for windows-x86_64.
CLANG=${TIKO_CLANG:-"/c/Program Files/LLVM/bin/clang.exe"}
WRT="$ROOT/build/obj/rtlib/windows-x86_64"
if [ ! -x "$CLANG" ]; then
    echo "FAIL fabi3-win64: no clang at $CLANG (set TIKO_CLANG)"; fail=1
elif [ ! -d "$WRT" ]; then
    echo "FAIL fabi3-win64: no $WRT (build/test.sh builds it)"; fail=1
elif ! "$CLANG" --target=x86_64-pc-windows-msvc -O1 -c "$ROOT/tests/abi/cabi3.c" -o "$W/cabi3-win.o" > "$W/cabi3-win.log" 2>&1; then
    echo "FAIL fabi3-win64: clang did not compile cabi3.c"; head -5 "$W/cabi3-win.log"; fail=1
elif ! TIKO_LIBPATH="$WRT" "$TKO" -target windows-x86_64 "$ROOT/tests/abi/fabi3.bas" "$W/cabi3-win.o"         -o "$W/fabi3-win.exe" > "$W/fabi3-win.tiko.log" 2>&1; then
    echo "FAIL fabi3-win64: tiko did not build it"; head -5 "$W/fabi3-win.tiko.log"; fail=1
else
    "$W/fabi3-win.exe" > "$W/fabi3-win.out" 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
        echo "FAIL fabi3-win64: run exited $rc"; tail -5 "$W/fabi3-win.out"; fail=1
    elif tr -d '\r' < "$W/fabi3-win.out" | cmp -s - "$ROOT/tests/abi/expected/fabi3.txt"; then
        echo "PASS fabi3-win64"
    else
        echo "FAIL fabi3-win64: output differs (< expected  > tiko)"
        tr -d '\r' < "$W/fabi3-win.out" | diff "$ROOT/tests/abi/expected/fabi3.txt" - | head -20
        fail=1
    fi
fi
[ $fail -eq 0 ] && echo "abilane: ok"
exit $fail
