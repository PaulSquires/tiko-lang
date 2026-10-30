#!/bin/bash
# Build scintk: Scintilla 5.5.7 + Lexilla (LexTiko) + PlatTk + ScintillaTk, as ONE shared library
# with the C++ runtime linked in statically, so nothing of it reaches the tiko link.
#   bash build.sh            Windows (Git Bash, clang++ -> scintk.dll), Linux (g++ -> libscintk.so)
#                            or macOS (clang++ -> libscintk.dylib)
# Incremental by timestamp. Output: bin/<os>/ beside this script.
# Also a STATIC archive, bin/<os>/scintk_<os>_<arch>.a, for tkCodeEdit's 'link static': the same
# objects, PlatTk and ScintillaTk compiled again with SCITK_STATIC. Its C++ runtime is the program's
# to link (tkCodeEdit names it): Visual Studio's static one on Windows, libstdc++ on Linux, libc++
# on macOS.
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
elif [ "$OS" = macos ]; then
    CXX=${CXX:-clang++}
    FLAGS="-std=c++17 -O2 -fPIC -fvisibility=hidden -mmacosx-version-min=13.0"
    LIB=$OUT/libscintk.dylib
    O=o
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
elif [ "$OS" = macos ]; then
    # libc++ is the system's on macOS (no static one ships), so only the install name is ours.
    "$CXX" -mmacosx-version-min=13.0 -dynamiclib -Wl,-install_name,@rpath/libscintk.dylib -o "$LIB" "${objs[@]}"
else
    "$CXX" -shared -o "$LIB" "${objs[@]}" -static-libstdc++ -static-libgcc -Wl,-z,noexecstack
fi

case $OS in windows) ARCH=x86_64 ;; macos) ARCH=arm64 ;; *) ARCH=x86_64 ;; esac
ST=$OUT/scintk_${OS}_$ARCH.a
# PlatTk and ScintillaTk define the exported entry points: compiled again with SCITK_STATIC,
# which on Windows exports nothing (scintk.h) and initialises the C++ runtime (ScintillaTk.cxx).
sobjs=()
for o in "${objs[@]}"; do
    case "$o" in "$OBJ/PlatTk.$O"|"$OBJ/ScintillaTk.$O") ;; *) sobjs+=("$o") ;; esac
done
for b in PlatTk ScintillaTk; do
    so=$OBJ/${b}_static.$O
    if [ ! -f "$so" ] || [ "$HERE/$b.cxx" -nt "$so" ] || [ "$HERE/scintk.h" -nt "$so" ]; then
        "$CXX" $FLAGS -DSCITK_STATIC -Wall -Wextra -Wno-unused-parameter $INC -c "$HERE/$b.cxx" -o "$so"
        n=$((n+1))
    fi
    sobjs+=("$so")
done
stale=0
[ -f "$ST" ] || stale=1
for o in "${sobjs[@]}"; do [ "$o" -nt "$ST" ] && stale=1; done
if [ "$stale" = 1 ]; then
    rm -f "$ST"
    if [ "$OS" = windows ]; then
        "$(dirname "$(command -v "$CXX")")/llvm-lib.exe" -out:"$(cygpath -m "$ST")" $(for o in "${sobjs[@]}"; do cygpath -m "$o"; done)
    else
        ar rcs "$ST" "${sobjs[@]}"
    fi
fi
echo "scintk: $LIB, $ST ($n compiled)"
