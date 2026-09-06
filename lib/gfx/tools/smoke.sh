#!/bin/sh
# smoke.sh -- drive the ENTRY LAYER from an fbc-compiled MSVC program.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception).
#
# abtest.sh compares our INTERNALS against gfxlib2 and cannot call an entry
# point: it links gfxlib2, which exports the same names. This links libtkogfx
# INSTEAD of gfxlib2 and reaches the rasterizers only through fb_Gfx*, which is
# the only way that seam gets exercised at all.
#
# It needs an interactive desktop session -- SCREENRES opens a real window.
#
# Usage: tools/smoke.sh [--keep]

HERE=$( cd "$( dirname "$0" )" && pwd )
GFX=$( cd "$HERE/.." && pwd )

# The LOCALLY BUILT fbc, not the bundled toolchain one: -z msvc landed
# 2026-09-05 and the shipped compiler predates it. build/build.sh makes the same
# demand and for the same reason.
: "${FBC:=/c/dev/fbc-modern/src/fbc.exe}"
: "${CLANG:=$( command -v clang 2>/dev/null || echo "/c/Program Files/LLVM/bin/clang.exe" )}"

TKOGFX="$GFX/lib/win64-msvc/libtkogfx.a"
LIBFB="$GFX/../rt/lib/win64-msvc/libfb.a"

for f in "$FBC" "$CLANG"; do
    [ -x "$f" ] || { echo "smoke: no $f" >&2 ; exit 3 ; }
done
for f in "$TKOGFX" "$LIBFB"; do
    [ -f "$f" ] || { echo "smoke: no $f -- run build/build.sh" >&2 ; exit 3 ; }
done

TMP=$( mktemp -d )
[ "$1" = "--keep" ] || trap 'rm -rf "$TMP"' EXIT

src="$HERE/smoke-entry.bas"
name=smoke-entry

if ! "$FBC" -c "$src" -m "$name" -target win64 -gen llvm -r -z msvc \
         -o "$TMP/$name.o" > "$TMP/$name.log" 2>&1; then
    echo "smoke: FAILED TO EMIT IR" >&2
    sed -n '1,10p' "$TMP/$name.log" >&2
    exit 1
fi

if ! "$CLANG" --target=x86_64-pc-windows-msvc -march=x86-64 -O2 \
         -Wno-override-module "$TMP/$name.ll" -c -o "$TMP/$name.o" \
         >> "$TMP/$name.log" 2>&1; then
    echo "smoke: DOES NOT ASSEMBLE FOR MSVC, see $TMP/$name.log" >&2
    exit 1
fi

# An unresolved fb_Gfx* here is the useful failure: it names an entry point the
# library still does not export, from a program that legitimately uses it.
if ! "$CLANG" --target=x86_64-pc-windows-msvc "$TMP/$name.o" "$TKOGFX" "$LIBFB" \
         -o "$TMP/$name.exe" \
         -lwinspool -lgdi32 -luser32 -ladvapi32 -llegacy_stdio_definitions \
         -Xlinker /INCLUDE:tkort_msvc_init_ >> "$TMP/$name.log" 2>&1; then
    echo "smoke: DOES NOT LINK, still needs:" >&2
    grep -o 'unresolved external symbol [A-Za-z0-9_@$]*' "$TMP/$name.log" \
        | sed 's/unresolved external symbol /    /' | sort -u >&2
    exit 1
fi

# A TIMEOUT, because the smoke test now drives INPUT. A blocking read that never
# sees its Enter would wedge the run; a hung test says nothing and nobody waits
# for it.
: "${SMOKE_TIMEOUT:=90}"

if timeout "$SMOKE_TIMEOUT" "$TMP/$name.exe"; then
    echo "smoke: ok -- win64-msvc, entry points reached through fb_Gfx*"
else
    rc=$?
    echo "smoke: FAILED (exit $rc, or timed out after ${SMOKE_TIMEOUT}s)" >&2
    exit 1
fi

[ "$1" = "--keep" ] && echo "smoke: build products left in $TMP"
exit 0
