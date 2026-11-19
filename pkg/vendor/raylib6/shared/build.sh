#!/bin/bash
# Build vendor/raylib6's Linux SHARED library -- libraylib.so.6.2.0, soname libraylib.so.620 --
# for '#import "vendor/raylib6"' linked dynamically, from raylib 6.2's pinned source. Run by
# build/vendorfetch.sh (the 'script' entry in ../fetch.toml), which downloads and verifies the
# source archive and passes it as TIKO_VENDOR_INPUTS.
#
# WHY NOT UPSTREAM'S BINARY: raylib's release libraylib.so.6.2.0 imports fmod@GLIBC_2.38,
# fmodf@GLIBC_2.38 and hypot(f)@GLIBC_2.35, so a program linking it does not link on glibc < 2.38
# (Ubuntu 22.04: "undefined reference to 'fmod@GLIBC_2.38'"). This is upstream's own release
# build -- 'make PLATFORM=PLATFORM_DESKTOP CC=gcc RAYLIB_LIBTYPE=SHARED' in src/, as raylib's
# build_linux.yml runs it: GLFW built in, X11 only -- with every libm symbol newer than glibc
# 2.34 bound to its oldest version instead (glibc234.h, beside this script), so the library
# loads on glibc 2.34 or later whichever host builds it; the build fails if anything newer is
# left. The static archive is upstream's still: an archive's references are bound when a
# program links, against that system's libm.
#
# Output: bin/linux/libraylib.so.6.2.0 beside this script. Built in a scratch directory (the
# 53 MB unpack and the Makefile's 'ln -s' stay off /mnt/c); a finished build is kept in
# TIKO_VENDOR_CACHE and copied, not redone. Incremental: a stamp of the input and this script.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 1 ] || { echo "raylib shared: expected 1 input, got $#" >&2; exit 1; }
[ "$HOST" = linux ] || { echo "raylib shared: Linux only, not '$HOST'" >&2; exit 1; }
SO=libraylib.so.6.2.0
OUT=$HERE/bin/$HOST

STAMP=$( { basename "$1"; cat "$0" "$HERE/glibc234.h"; echo "$HOST"; } | sha256sum | cut -c1-16 )
[ -f "$OUT/$SO" ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
D=$CACHE/raylib-shared-$HOST
if [ "$(cat "$D/.stamp" 2>/dev/null)" = "$STAMP" ] && [ -f "$D/$SO" ]; then
    mkdir -p "$OUT"; cp -f "$D/$SO" "$OUT/$SO"; echo "$STAMP" > "$OUT/.stamp"; exit 0
fi

command -v make >/dev/null || { echo "raylib shared: make is not on PATH" >&2; exit 1; }
command -v gcc >/dev/null || { echo "raylib shared: gcc is not on PATH" >&2; exit 1; }
W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
tar -xzf "$1" -C "$W"
SRC=$(find "$W" -mindepth 2 -maxdepth 2 -type d -name src | head -1)
[ -f "$SRC/Makefile" ] || { echo "raylib shared: no src/Makefile in $(basename "$1")" >&2; exit 1; }
LOG=$W/build.log; mkdir -p "$W/out"
if ! make -C "$SRC" PLATFORM=PLATFORM_DESKTOP CC=gcc RAYLIB_LIBTYPE=SHARED \
        RAYLIB_RELEASE_PATH="$W/out" CUSTOM_CFLAGS="-include $HERE/glibc234.h" -B > "$LOG" 2>&1; then
    echo "raylib shared: make failed" >&2; tail -20 "$LOG" >&2; exit 1
fi
[ -f "$W/out/$SO" ] && [ ! -L "$W/out/$SO" ] || { echo "raylib shared: make made no $SO" >&2; ls -l "$W/out" >&2; exit 1; }

# THE CHECKS the pin is for: no glibc symbol version newer than 2.34, and the soname a program
# records as NEEDED -- tiko copies the library beside a program under that name.
NEW=$(objdump -T "$W/out/$SO" | grep -o 'GLIBC_2\.[0-9]*' | sort -u | awk -F. '$2 > 34' | tr '\n' ' ')
[ -z "$NEW" ] || { echo "raylib shared: $SO needs $NEW-- glibc234.h must pin it" >&2; exit 1; }
objdump -p "$W/out/$SO" | grep -q 'SONAME *libraylib\.so\.620$' ||
    { echo "raylib shared: $SO's soname is not libraylib.so.620" >&2; exit 1; }

mkdir -p "$D" "$OUT"
cp -f "$W/out/$SO" "$D/$SO"; echo "$STAMP" > "$D/.stamp"
cp -f "$W/out/$SO" "$OUT/$SO"; echo "$STAMP" > "$OUT/.stamp"
