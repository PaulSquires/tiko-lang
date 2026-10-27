#!/bin/bash
# Build scintk: Scintilla 5.5.7 + Lexilla (LexTiko) + PlatTk + ScintillaTk, as ONE shared library
# with the C++ runtime linked in statically, so nothing of it reaches the tiko link.
#   bash build.sh            Windows (Git Bash, clang++ -> scintk.dll) or Linux (g++ -> libscintk.so)
# Incremental by timestamp. Output: bin/<os>/ beside this script.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
V=$HERE/vendor
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) OS=windows ;;
    Darwin) OS=macos ;;
    *) OS=linux ;;
esac
OBJ=$HERE/out/$OS
OUT=$HERE/bin/$OS
mkdir -p "$OBJ" "$OUT"
INC="-I$V/scintilla/include -I$V/scintilla/src -I$V/lexilla/include -I$V/lexilla/lexlib -I$HERE"
if [ "$OS" = windows ]; then
    CXX=${CXX:-clang++}
    FLAGS="-std=c++17 -O2 --target=x86_64-pc-windows-msvc -fms-runtime-lib=static -D_CRT_SECURE_NO_WARNINGS -DNOMINMAX"
    LIB=$OUT/scintk.dll
    O=obj
else
    CXX=${CXX:-g++}
    FLAGS="-std=c++17 -O2 -fPIC -fvisibility=hidden"
    LIB=$OUT/libscintk.so
    O=o
fi
srcs=( "$V"/scintilla/src/*.cxx "$V"/lexilla/src/Lexilla.cxx "$V"/lexilla/lexlib/*.cxx "$V"/lexilla/lexers/*.cxx \
       "$HERE"/PlatTk.cxx "$HERE"/ScintillaTk.cxx )
objs=()
n=0
for s in "${srcs[@]}"; do
    b=$(basename "$s" .cxx)
    [ "$(dirname "$s")" = "$V/lexilla/src" ] && b="lexilla_$b"
    o=$OBJ/$b.$O
    objs+=("$o")
    if [ ! -f "$o" ] || [ "$s" -nt "$o" ] || [ "$HERE/scintk.h" -nt "$o" ]; then
        # Vendor code compiles quiet (-w); ours must compile clean under -Wall.
        W=-w; case "$b" in PlatTk|ScintillaTk) W="-Wall -Wextra -Wno-unused-parameter" ;; esac
        "$CXX" $FLAGS $W $INC -c "$s" -o "$o"
        n=$((n+1))
    fi
done
if [ "$OS" = windows ]; then
    "$CXX" --target=x86_64-pc-windows-msvc -fms-runtime-lib=static -shared -fuse-ld=lld -o "$LIB" "${objs[@]}"
else
    "$CXX" -shared -o "$LIB" "${objs[@]}" -static-libstdc++ -static-libgcc -Wl,-z,noexecstack
fi
echo "scintk: $LIB ($n compiled)"
