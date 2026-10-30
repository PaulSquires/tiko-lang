#!/bin/bash
# Build vendor/SDL3's STATIC libraries -- SDL3, SDL3_ttf (with FreeType and HarfBuzz folded into
# its archive) and SDL3_image (stb backend) -- for '#import "vendor/SDL3" link static' and its
# satellites. Run by build/vendorfetch.sh ('script' entries in ../fetch.toml), which downloads
# and verifies the pinned sources and passes them as TKO_VENDOR_INPUTS, in this order:
#
#   SDL3  SDL3_ttf  SDL3_image  freetype  harfbuzz
#
# SDL publishes no static library, so each host builds its own, with CMake and Ninja:
#   windows  clang/clang++ for x86_64-pc-windows-msvc, the static C runtime (/MT) -- a program
#            linking these needs Visual Studio's libvcruntime.lib and oldnames.lib, as any
#            static C++ on that target does
#   linux    gcc/g++, position-independent; X11, Wayland, GL and audio stay dlopen'd by SDL
#   macos    Apple clang, arm64, macOS 13.0
# Output: bin/<host>/{SDL3,SDL3_ttf,SDL3_image}_<host>_<arch>.a beside this script. The build
# trees live under TKO_VENDOR_CACHE. Incremental: a stamp of the inputs and this script.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TKO_VENDOR_INPUTS
[ $# -eq 5 ] || { echo "SDL3 static: expected 5 inputs, got $#" >&2; exit 1; }
SRC_SDL=$1; SRC_TTF=$2; SRC_IMG=$3; SRC_FT=$4; SRC_HB=$5

case $HOST in
    windows) ARCH=x86_64 ;;
    linux)   ARCH=x86_64 ;;
    macos)   ARCH=arm64 ;;
    *) echo "SDL3 static: unknown host '$HOST'" >&2; exit 1 ;;
esac
OUT=$HERE/bin/$HOST
OUTS="$OUT/SDL3_${HOST}_$ARCH.a $OUT/SDL3_ttf_${HOST}_$ARCH.a $OUT/SDL3_image_${HOST}_$ARCH.a"

# macOS has no sha256sum; its shasum is the same digest.
digest() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi; }
STAMP=$( { for f in "$@"; do basename "$f"; done; cat "$0"; echo "$HOST"; } | digest | cut -c1-16 )
fresh=1
for o in $OUTS; do [ -f "$o" ] || fresh=0; done
[ "$fresh" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
# A FINISHED BUILD IN THE CACHE is copied, not redone: a fresh tree (a test copy, a package
# worktree) finds the archives the last identical build left there.
W=$CACHE/sdl3-static-$HOST
if [ "$(cat "$W/done/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"
    for o in $OUTS; do cp -f "$W/done/$(basename "$o")" "$o" || exit 1; done
    echo "$STAMP" > "$OUT/.stamp"
    exit 0
fi

command -v cmake >/dev/null || { echo "SDL3 static: cmake is not on PATH" >&2; exit 1; }
command -v ninja >/dev/null || { echo "SDL3 static: ninja is not on PATH" >&2; exit 1; }

rm -rf "$W"; mkdir -p "$W/src" "$OUT"
LOG=$W/build.log
for f in "$@"; do tar -xf "$f" -C "$W/src"; done
dir_of() { find "$W/src" -maxdepth 1 -type d -name "$1" | head -1; }

C=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
   -DCMAKE_INSTALL_PREFIX="$W/inst" -DCMAKE_PREFIX_PATH="$W/inst" -DCMAKE_INSTALL_LIBDIR=lib
   -DCMAKE_POLICY_VERSION_MINIMUM=3.5)
case $HOST in
windows)
    CL=${TKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}
    C+=(-DCMAKE_C_COMPILER="$CL" -DCMAKE_CXX_COMPILER="$(dirname "$CL")/clang++.exe"
        -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded -DCMAKE_POLICY_DEFAULT_CMP0091=NEW) ;;
    # CMP0091 NEW, or a project with an old cmake_minimum_required (HarfBuzz) ignores the runtime
    # library and builds /MD -- which lld-link then refuses beside /MT objects (failifmismatch).
linux)
    C+=(-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_POSITION_INDEPENDENT_CODE=ON) ;;
macos)
    C+=(-DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++
        -DCMAKE_OSX_DEPLOYMENT_TARGET=13.0 -DCMAKE_OSX_ARCHITECTURES=arm64
        -DCMAKE_FIND_USE_CMAKE_SYSTEM_PATH=OFF) ;;
esac

step() {     # step <name> <source dir> <cmake args...>
    local n=$1 s=$2; shift 2
    echo "== $n" >> "$LOG"
    if ! { cmake -S "$s" -B "$W/b-$n" "${C[@]}" "$@" && cmake --build "$W/b-$n" && cmake --install "$W/b-$n"; } >> "$LOG" 2>&1; then
        echo "SDL3 static: $n failed ($LOG)" >&2; tail -20 "$LOG" >&2; exit 1
    fi
}

# X11 screensaver and XTest need development packages a build host may lack; neither is used.
SDLX=(); [ "$HOST" = linux ] && SDLX=(-DSDL_X11_XSCRNSAVER=OFF -DSDL_X11_XTEST=OFF)
step sdl "$(dir_of 'SDL3-*')" -DSDL_SHARED=OFF -DSDL_STATIC=ON -DSDL_TEST_LIBRARY=OFF -DSDL_EXAMPLES=OFF "${SDLX[@]}"
step ft "$(dir_of 'freetype-*')" -DFT_DISABLE_ZLIB=ON -DFT_DISABLE_BZIP2=ON -DFT_DISABLE_PNG=ON \
     -DFT_DISABLE_BROTLI=ON -DFT_DISABLE_HARFBUZZ=ON
step hb "$(dir_of 'harfbuzz-*')" -DHB_HAVE_FREETYPE=ON -DHB_HAVE_GLIB=OFF -DHB_HAVE_ICU=OFF \
     -DHB_HAVE_CORETEXT=OFF -DHB_BUILD_SUBSET=OFF -DHB_BUILD_UTILS=OFF -DHB_BUILD_TESTS=OFF
step ttf "$(dir_of 'SDL3_ttf-*')" -DSDLTTF_VENDORED=OFF -DSDLTTF_HARFBUZZ=ON -DSDLTTF_PLUTOSVG=OFF \
     -DSDLTTF_SAMPLES=OFF
step img "$(dir_of 'SDL3_image-*')" -DSDLIMAGE_VENDORED=OFF -DSDLIMAGE_BACKEND_STB=ON \
     -DSDLIMAGE_BACKEND_IMAGEIO=OFF -DSDLIMAGE_BACKEND_WIC=OFF -DSDLIMAGE_AVIF=OFF -DSDLIMAGE_JXL=OFF \
     -DSDLIMAGE_TIF=OFF -DSDLIMAGE_WEBP=OFF -DSDLIMAGE_SAMPLES=OFF -DSDLIMAGE_TESTS=OFF

lib_of() { find "$W/inst/lib" -maxdepth 1 \( -name "$1.lib" -o -name "$1-static.lib" -o -name "lib$1.a" \) | head -1; }
L_SDL=$(lib_of SDL3); L_TTF=$(lib_of SDL3_ttf); L_IMG=$(lib_of SDL3_image)
L_FT=$(lib_of freetype); L_HB=$(lib_of harfbuzz)
for l in "$L_SDL" "$L_TTF" "$L_IMG" "$L_FT" "$L_HB"; do
    [ -n "$l" ] && [ -f "$l" ] || { echo "SDL3 static: a library is missing under $W/inst/lib" >&2; ls "$W/inst/lib" >&2; exit 1; }
done

# ONE ARCHIVE FOR SDL3_ttf, with FreeType and HarfBuzz inside: the module names one file.
TTF=$OUT/SDL3_ttf_${HOST}_$ARCH.a
rm -f "$TTF"
case $HOST in
windows)
    "$(dirname "$CL")/llvm-lib.exe" -out:"$(cygpath -m "$TTF")" "$(cygpath -m "$L_TTF")" "$(cygpath -m "$L_FT")" "$(cygpath -m "$L_HB")" >> "$LOG" 2>&1 ;;
linux)
    printf 'create %s\naddlib %s\naddlib %s\naddlib %s\nsave\nend\n' "$TTF" "$L_TTF" "$L_FT" "$L_HB" | ar -M >> "$LOG" 2>&1 ;;
macos)
    libtool -static -o "$TTF" "$L_TTF" "$L_FT" "$L_HB" >> "$LOG" 2>&1 ;;
esac
[ -f "$TTF" ] || { echo "SDL3 static: combining SDL3_ttf failed ($LOG)" >&2; exit 1; }
if [ "$HOST" = windows ]; then
    for l in "$L_SDL" "$TTF" "$L_IMG"; do
        if grep -aq "MD_DynamicRelease" "$l"; then echo "SDL3 static: $(basename "$l") has /MD objects" >&2; exit 1; fi
    done
fi
cp -f "$L_SDL" "$OUT/SDL3_${HOST}_$ARCH.a"
cp -f "$L_IMG" "$OUT/SDL3_image_${HOST}_$ARCH.a"
echo "$STAMP" > "$OUT/.stamp"
mkdir -p "$W/done"
for o in $OUTS; do cp -f "$o" "$W/done/"; done
echo "$STAMP" > "$W/done/.stamp"
echo "SDL3 static: $OUT"
