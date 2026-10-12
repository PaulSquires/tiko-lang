#!/bin/sh
# smoke.sh -- drive the ENTRY LAYER from a tiko-compiled MSVC program.
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
# BUILT BY tiko since 2026-10-10 -- the tree's bin/tiko, linking the tree's libtkogfx and
# tiko-rt ahead of the toolchain's -- where it was fbc '-z msvc' plus clang by hand.
# Nothing here runs fbc now: the program is what a user's would be.
#
# Usage: tools/smoke.sh [--keep]

HERE=$( cd "$( dirname "$0" )" && pwd )
GFX=$( cd "$HERE/.." && pwd )

: "${TIKO:=$( cd "$GFX/../.." && pwd )/bin/tiko.exe}"

TKOGFX="$GFX/lib/windows-x86_64/libtkogfx.a"
LIBFB="$GFX/../rt/lib/windows-x86_64/libfb.a"
# The import libraries tiko's own windows-x86_64 link resolves the CRT and Win32
# through (build/implibs.sh builds them). See the subject link below.
: "${MSVC_IMPLIBS:=$( cd "$GFX/../.." && pwd )/toolchains/tiko-windows/lib/windows-x86_64}"

[ -x "$TIKO" ] || { echo "smoke: no $TIKO -- run build/build.sh" >&2 ; exit 3 ; }
for f in "$TKOGFX" "$LIBFB"; do
    [ -f "$f" ] || { echo "smoke: no $f -- run build/build.sh" >&2 ; exit 3 ; }
done
[ -f "$MSVC_IMPLIBS/ucrtbase.lib" ] || {
    echo "smoke: no ucrtbase.lib in $MSVC_IMPLIBS -- run build/implibs.sh build --out <dir>" >&2 ; exit 3 ; }

TMP=$( mktemp -d )
[ "$1" = "--keep" ] || trap 'rm -rf "$TMP"' EXIT

src="$HERE/smoke-entry.bas"
name=smoke-entry

# An unresolved fb_Gfx* here is the useful failure: it names an entry point the
# library still does not export, from a program that legitimately uses it. The -p
# directories come first, so the tree's libtkogfx and tiko-rt are the ones linked.
if ! "$TIKO" "$src" -target windows-x86_64 -p "$( cygpath -m "$GFX/lib/windows-x86_64" )" \
         -p "$( cygpath -m "$GFX/../rt/lib/windows-x86_64" )" -p "$( cygpath -m "$MSVC_IMPLIBS" )" \
         -o "$TMP/$name.exe" > "$TMP/$name.log" 2>&1 || [ ! -f "$TMP/$name.exe" ]; then
    echo "smoke: DOES NOT BUILD, see below; an entry point it still needs:" >&2
    sed -n '1,10p' "$TMP/$name.log" >&2
    grep -o 'undefined symbol: [A-Za-z0-9_@$]*' "$TMP/$name.log" \
        | sed 's/undefined symbol: /    /' | sort -u >&2
    exit 1
fi

# A TIMEOUT, because the smoke test now drives INPUT. A blocking read that never
# sees its Enter would wedge the run; a hung test says nothing and nobody waits
# for it.
: "${SMOKE_TIMEOUT:=90}"

# THE OUTPUT IS CAPTURED as well as shown: one check is only visible in it -- see the
# WIDTH line at the end of smoke-entry.bas.
if timeout "$SMOKE_TIMEOUT" "$TMP/$name.exe" > "$TMP/$name.out"; then
    cat "$TMP/$name.out"
else
    rc=$?
    cat "$TMP/$name.out"
    echo "smoke: FAILED (exit $rc, or timed out after ${SMOKE_TIMEOUT}s)" >&2
    exit 1
fi

# SCREEN 0 restored the 80-column console: the four zones are ONE line. Wrapped at
# the 40 set while the screen was open, '4' lands on a line of its own.
if ! tr -d '\r' < "$TMP/$name.out" | grep -qx ' 1             2             3             4'; then
    echo "smoke: FAILED -- SCREEN 0 kept the graphics screen's WIDTH; the zoned line wrapped" >&2
    exit 1
fi
echo "smoke: ok -- windows-x86_64, entry points reached through fb_Gfx*"

[ "$1" = "--keep" ] && echo "smoke: build products left in $TMP"
exit 0
