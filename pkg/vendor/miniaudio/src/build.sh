#!/bin/bash
# Build vendor/miniaudio's libraries -- miniaudio 0.11.26 with stb_vorbis 1.25 as its Ogg Vorbis
# decoder, one static archive and one shared library -- from two pinned source archives. Run by
# build/vendorfetch.sh (the 'script' entries in ../fetch.toml), which downloads and verifies both
# and passes them as TIKO_VENDOR_INPUTS, miniaudio's first.
#
# WHY A SCRIPT AND NOT 'cbuild': the library is built from TWO archives and 'cbuild' takes one.
# miniaudio bundles stb_vorbis 1.22 in extras/, the version the 2023 out-of-bounds-write reports
# (CVE-2023-45675..45682) were filed against; stb's own stb_vorbis.c, 1.25 (2026-11-19), is pinned
# instead, and compiles with miniaudio 0.11.26 unchanged.
#
# ONE TRANSLATION UNIT, miniaudio_vorbis.c beside this script: stb_vorbis's declarations,
# miniaudio's implementation, stb_vorbis's implementation -- the order miniaudio.h documents.
# The Windows DLL's object is compiled with -DMA_DLL (miniaudio's export switch: dllexport while
# building); the archive's without. Elsewhere one -fPIC object makes both.
#
# NO LINK LIBRARIES: miniaudio loads its audio backends at run time -- WASAPI, DirectSound and
# WinMM; ALSA, PulseAudio and JACK -- so the DLL imports KERNEL32 alone and the .so libm and libc
# (measured: claude-docs docs/tiko-vendor/probes/av0/P0-RESULTS.md). macOS links CoreAudio's
# frameworks, as SDL3 does.
#
# THE COMPILER is chosen as vendorfetch chooses its own: TIKO_CLANG, else the LLVM install on
# Windows (and for Android, with the NDK's sysroot), else clang on PATH. TIKO_AR likewise.
#
# Output: bin/<os>-<arch>/ beside this script -- miniaudio_<os>_<arch>.a, and miniaudio.dll,
# miniaudio_<os>_<arch>.so or .dylib (none for Android, static only); each fetch.toml entry copies
# one. Built in a scratch directory; a finished build is kept in TIKO_VENDOR_CACHE and copied, not
# redone. Incremental: a stamp of the inputs, this script and miniaudio_vorbis.c.
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
HOST=${TIKO_VENDOR_HOST:?run me through build/vendorfetch.sh}
ARCH=${TIKO_VENDOR_ARCH:?run me through build/vendorfetch.sh}
CACHE=${TIKO_VENDOR_CACHE:?run me through build/vendorfetch.sh}
die( ) { echo "miniaudio build: $*" >&2; exit 1; }
set -- $TIKO_VENDOR_INPUTS
[ $# -eq 2 ] || die "expected 2 inputs (miniaudio, stb), got $#"
MAIN=$1; STB=$2

SYS=; SH=; SHF=; LIBS=; CF="-O2 -fPIC"
case $HOST-$ARCH in
    windows-x86_64)
        CC=${TIKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}; T=x86_64-pc-windows-msvc
        CF="-O2 -D_CRT_SECURE_NO_WARNINGS"; SH=miniaudio.dll ;;
    linux-x86_64|linux-arm64)
        CC=${TIKO_CLANG:-${CLANG:-clang}}; T=x86_64-pc-linux-gnu
        [ "$ARCH" = arm64 ] && T=aarch64-unknown-linux-gnu
        SH=miniaudio_${HOST}_$ARCH.so; SHF="-shared -Wl,-soname,$SH"; LIBS="-lm -lpthread -ldl" ;;
    macos-arm64)
        CC=${TIKO_CLANG:-${CLANG:-clang}}; T=arm64-apple-macosx13.0
        SH=miniaudio_macos_arm64.dylib; SHF="-dynamiclib -Wl,-install_name,@rpath/$SH"
        LIBS="-framework CoreFoundation -framework CoreAudio -framework AudioToolbox -lpthread -lm" ;;
    android-x86_64|android-arm64)
        CC=${TIKO_CLANG:-"C:/Program Files/LLVM/bin/clang.exe"}; T=x86_64-linux-android29
        [ "$ARCH" = arm64 ] && T=aarch64-linux-android29
        SYS="--sysroot=${TIKO_ANDROID_NDK:?no TIKO_ANDROID_NDK}/toolchains/llvm/prebuilt/windows-x86_64/sysroot" ;;
    *) die "no build for '$HOST-$ARCH'" ;;
esac
if [ -n "$TIKO_AR" ]; then AR=$TIKO_AR
elif [ "$HOST" = windows ] || [ "$HOST" = android ]; then AR="$(dirname "$CC")/llvm-ar.exe"
else AR=$(command -v llvm-ar || command -v ar); fi
ST=miniaudio_${HOST}_$ARCH.a
OUT=$HERE/bin/$HOST-$ARCH
WANT="$ST $SH"

STAMP=$( { basename "$MAIN"; basename "$STB"; cat "$0" "$HERE/miniaudio_vorbis.c"; echo "$HOST-$ARCH"; } | sha256sum | cut -c1-16 )
have=1; for f in $WANT; do [ -f "$OUT/$f" ] || have=0; done
[ "$have" = 1 ] && [ "$(cat "$OUT/.stamp" 2>/dev/null)" = "$STAMP" ] && exit 0
D=$CACHE/miniaudio-$HOST-$ARCH
cached=1; for f in $WANT; do [ -f "$D/$f" ] || cached=0; done
if [ "$cached" = 1 ] && [ "$(cat "$D/.stamp" 2>/dev/null)" = "$STAMP" ]; then
    mkdir -p "$OUT"; for f in $WANT; do cp -f "$D/$f" "$OUT/$f"; done; echo "$STAMP" > "$OUT/.stamp"; exit 0
fi

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
tar -xzf "$MAIN" -C "$W"; tar -xzf "$STB" -C "$W"
MH=$(find "$W" -mindepth 2 -maxdepth 2 -name miniaudio.h | head -1)
SV=$(find "$W" -mindepth 2 -maxdepth 2 -name stb_vorbis.c | head -1)
[ -f "$MH" ] || die "no miniaudio.h in $(basename "$MAIN")"
[ -f "$SV" ] || die "no stb_vorbis.c in $(basename "$STB")"
cp "$MH" "$SV" "$HERE/miniaudio_vorbis.c" "$W/"
cd "$W"
# shellcheck disable=SC2086
"$CC" --target=$T $SYS $CF -c miniaudio_vorbis.c -o ma.o || die "compiling failed"
"$AR" rcs "$ST" ma.o || die "archiving failed"
if [ "$HOST" = windows ]; then
    # The import library and .exp stay here: beside the DLL, '#foreignlib ... dynamic' would
    # find the .lib first. -implib:, not /implib: -- MSYS would rewrite a leading slash.
    # shellcheck disable=SC2086
    "$CC" --target=$T $CF -DMA_DLL -c miniaudio_vorbis.c -o ma_dll.o || die "compiling the DLL's object failed"
    "$CC" --target=$T -shared -fuse-ld=lld -o "$SH" -Wl,-implib:"$(cygpath -m "$W" 2>/dev/null || printf '%s' "$W")/miniaudio.lib" ma_dll.o ||
        die "linking $SH failed"
elif [ -n "$SH" ]; then
    # shellcheck disable=SC2086
    "$CC" --target=$T $SHF -o "$SH" ma.o $LIBS || die "linking $SH failed"
fi
mkdir -p "$D" "$OUT"
for f in $WANT; do [ -f "$f" ] || die "made no $f"; cp -f "$f" "$D/$f"; cp -f "$f" "$OUT/$f"; done
echo "$STAMP" > "$D/.stamp"; echo "$STAMP" > "$OUT/.stamp"
