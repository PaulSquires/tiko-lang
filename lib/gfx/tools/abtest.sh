#!/bin/sh
# abtest.sh -- pixel-exactness A/B against gfxlib2.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception).
#
# gate-abi.sh checks the ABI seam -- that we agree with the runtime about memory.
# This checks the RASTER OUTPUT -- that we agree with gfxlib2 about pixels.
#
# Each abtest-* program asks gfxlib2 to draw a case into an IMAGECREATE buffer,
# draws the same case itself into an identical buffer, and compares digests. No
# object substitution needed, so raster work can be verified from the first
# primitive rather than after the whole library exists.
#
# Runs in all four configurations because the drawing code is shared but the
# runtime underneath is not.
#
# Usage: tools/abtest.sh [--keep]     (--keep leaves the built exes in $TMP)

HERE=$( cd "$( dirname "$0" )" && pwd )
: "${FBC:=/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}"

if [ ! -x "$FBC" ]; then
    echo "abtest: no compiler at $FBC (set FBC)" >&2
    exit 3
fi

TMP=$( mktemp -d )
[ "$1" = "--keep" ] || trap 'rm -rf "$TMP"' EXIT

status=0

# probe-driver is a unit test rather than an A/B (gfxlib2's driver table is
# internal and its presentation is only observable by eye), but it runs in the
# same four configurations and fails the same way, so it lives here.
# probe-window opens a REAL WINDOW and reads pixels back off it, so it needs a
# desktop session -- it cannot run on a headless runner and will fail there
# rather than skip. That is deliberate: the checks it makes (client size,
# orientation, dirty presentation) have no offscreen equivalent.
for src in "$HERE"/abtest-*.bas "$HERE"/probe-driver.bas "$HERE"/probe-gdi.bas "$HERE"/probe-window.bas; do
    [ -f "$src" ] || continue
    name=$( basename "$src" .bas )

    for cfg in "win64|" "win64-mt|-mt" "win32|-target win32" "win32-mt|-target win32 -mt"; do
        label=${cfg%%|*}
        flags=${cfg#*|}

        if ! "$FBC" $flags -gen llvm "$src" -x "$TMP/$name-$label.exe" \
                 > "$TMP/$name-$label.err" 2>&1; then
            echo "abtest: $name/$label -- FAILED TO BUILD" >&2
            sed -n '1,8p' "$TMP/$name-$label.err" >&2
            status=1
            continue
        fi

        if "$TMP/$name-$label.exe" > "$TMP/$name-$label.out" 2>&1; then
            sed -n '$p' "$TMP/$name-$label.out" | sed "s/^/abtest: $label -- /"
        else
            echo "abtest: $name/$label -- PIXELS DIFFER FROM gfxlib2" >&2
            cat "$TMP/$name-$label.out" >&2
            status=1
        fi
    done
done

[ "$1" = "--keep" ] && echo "abtest: build products left in $TMP"

exit $status
