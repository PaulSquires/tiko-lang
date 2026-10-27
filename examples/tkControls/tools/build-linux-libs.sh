#!/bin/bash
# Builds SDL3_ttf 3.2.2 and SDL3_image 3.4.4 for linux-x86_64 against PsPlatform's prebuilt
# SDL3 + FreeType + HarfBuzz prefix. No sudo. Output: $OUT/lib (all .so's side by side).
set -euo pipefail
SP=${SP:?set SP to the folder holding dl/SDL3_ttf-3.2.2.tar.gz and dl/SDL3_image-3.4.4.tar.gz}
DEPS=/mnt/c/dev/utils/PsPlatform/deps/out/linux64
W=$HOME/pssdl-build
OUT=${OUT:-$(cd "$(dirname "$0")/.." && pwd)/linux-lib-build}
rm -rf "$W" "$OUT"; mkdir -p "$W" "$OUT"
cp -a "$DEPS/." "$W/deps/"
cd "$W"
tar xzf "$SP/dl/SDL3_ttf-3.2.2.tar.gz"
tar xzf "$SP/dl/SDL3_image-3.4.4.tar.gz"

cmake -S SDL3_ttf-3.2.2 -B b-ttf -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$W/deps" \
    -DCMAKE_INSTALL_PREFIX="$W/inst" -DSDLTTF_VENDORED=OFF -DSDLTTF_HARFBUZZ=ON \
    -DSDLTTF_PLUTOSVG=OFF -DSDLTTF_SAMPLES=OFF -DBUILD_SHARED_LIBS=ON > ttf.log 2>&1
cmake --build b-ttf -j 8 >> ttf.log 2>&1
cmake --install b-ttf >> ttf.log 2>&1

cmake -S SDL3_image-3.4.4 -B b-img -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$W/deps" \
    -DCMAKE_INSTALL_PREFIX="$W/inst" -DSDLIMAGE_VENDORED=OFF -DSDLIMAGE_BACKEND_STB=ON \
    -DSDLIMAGE_AVIF=OFF -DSDLIMAGE_JXL=OFF -DSDLIMAGE_TIF=OFF -DSDLIMAGE_WEBP=OFF \
    -DSDLIMAGE_SAMPLES=OFF -DSDLIMAGE_TESTS=OFF -DBUILD_SHARED_LIBS=ON > img.log 2>&1
cmake --build b-img -j 8 >> img.log 2>&1
cmake --install b-img >> img.log 2>&1

mkdir -p "$OUT/lib"
cp -a "$W"/deps/lib/libSDL3.so* "$W"/deps/lib/libfreetype.so* "$W"/deps/lib/libharfbuzz.so "$OUT/lib/"
cp -a "$W"/inst/lib/libSDL3_ttf.so* "$W"/inst/lib/libSDL3_image.so* "$OUT/lib/"
cp ttf.log img.log "$OUT/"
ls -la "$OUT/lib"
for f in "$OUT"/lib/libSDL3_ttf.so.0 "$OUT"/lib/libSDL3_image.so.0; do readelf -d "$f" | grep -E 'NEEDED|SONAME'; done
