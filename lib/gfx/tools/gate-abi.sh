#!/bin/sh
# gate-abi.sh -- re-measure the rtlib/gfxlib2 layout and fail on drift.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception; see LICENSE at the repository root).
#
# libtkogfx mirrors private runtime structs in FreeBASIC. Those structs belong to
# a runtime we do not own, so the mirror can silently rot. This gate rebuilds the
# C probe against the CURRENT rtlib headers, runs it, and diffs the result against
# the checked-in goldens. Any difference is a build failure, not a warning.
#
# Usage:  tools/gate-abi.sh [--accept]
#   --accept rewrites the goldens. A commit that accepts new goldens without
#   saying why does not land -- same rule as build/test.sh.

# NO `set -e`. This script's whole job is to run EVERY check and report all the
# failures; -e made it abort at the first one, which silently skipped the hook
# checks entirely and reported success. Failures accumulate in $status instead.

HERE=$( cd "$( dirname "$0" )" && pwd )
GFX=$( dirname "$HERE" )
GOLD="$GFX/abi/offsets"

: "${FBC_MODERN:=/c/dev/fbc-modern}"
RTLIB="$FBC_MODERN/src/src/rtlib"
GFXLIB="$FBC_MODERN/src/src/gfxlib2"

[ -d "$RTLIB" ]  || { echo "gate-abi: no rtlib at $RTLIB (set FBC_MODERN)" >&2; exit 3; }
[ -d "$GFXLIB" ] || { echo "gate-abi: no gfxlib2 at $GFXLIB (set FBC_MODERN)" >&2; exit 3; }

ACCEPT=0
[ "$1" = "--accept" ] && ACCEPT=1

TMP=$( mktemp -d )
trap 'rm -rf "$TMP"' EXIT

# The rtlib headers identify Windows only via __MINGW32__, which a -windows-msvc
# clang does not define; and they assume MinGW's ssize_t, which the probe shims.
CFLAGS="-D__MINGW32__ -I $RTLIB -I $GFXLIB -w"

status=0
for target in win64 win32; do
    case "$target" in
        win64) bits="" ;;
        win32) bits="-m32" ;;
    esac

    if ! clang $bits "$HERE/probe-rtlabi.c" $CFLAGS -o "$TMP/probe-$target.exe" 2>"$TMP/cc.err"; then
        echo "gate-abi: $target -- probe failed to BUILD" >&2
        sed -n '1,10p' "$TMP/cc.err" >&2
        status=1
        continue
    fi

    "$TMP/probe-$target.exe" > "$TMP/$target.txt"

    if [ "$ACCEPT" = "1" ]; then
        cp "$TMP/$target.txt" "$GOLD/$target.txt"
        echo "gate-abi: $target -- golden ACCEPTED"
        continue
    fi

    if [ ! -f "$GOLD/$target.txt" ]; then
        echo "gate-abi: $target -- no golden at $GOLD/$target.txt (run with --accept)" >&2
        status=1
        continue
    fi

    if diff -u --strip-trailing-cr "$GOLD/$target.txt" "$TMP/$target.txt" > "$TMP/$target.diff"; then
        echo "gate-abi: $target -- ok"
    else
        echo "gate-abi: $target -- LAYOUT DRIFT, the FB mirror is now WRONG" >&2
        cat "$TMP/$target.diff" >&2
        status=1
    fi
done

# ---------------------------------------------------------------------------
# The FB side. The C probe above measures the REAL runtime; this measures our
# MIRROR of it in abi/rtlabi.ti. Both must agree, or every field access through
# the mirror is reading the wrong bytes.
#
# The C probe also prints alignof, which FreeBASIC has no operator for, and it
# covers FB_RTLIB_CTX, which we deliberately do NOT mirror (it is ~20KB of
# FB_FILE we have no business duplicating). Those lines are stripped from the
# reference rather than faked on the FB side -- compare what both can measure.
FBC="${FBC:-${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}}"

if [ ! -x "$FBC" ]; then
    echo "gate-abi: fb -- no compiler at $FBC (set FBC); FB MIRROR NOT CHECKED" >&2
    status=1
else
    for target in win64 win32; do
        case "$target" in
            win64) tflag="" ;;
            win32) tflag="-target win32" ;;
        esac

        if ! "$FBC" -d nullptr=0 $tflag -gen llvm "$HERE/probe-fbabi.bas"                  -x "$TMP/probe-fb-$target.exe" > "$TMP/fbc.err" 2>&1; then
            echo "gate-abi: fb/$target -- MIRROR FAILED TO COMPILE" >&2
            sed -n '1,10p' "$TMP/fbc.err" >&2
            status=1
            continue
        fi

        "$TMP/probe-fb-$target.exe" "$TMP/fb-$target.txt" || {
            echo "gate-abi: fb/$target -- probe did not run" >&2; status=1; continue; }

        sed -E 's/ +align=[0-9]+//' "$GOLD/$target.txt"             | grep -v '^== constants'             | grep -vE '^(FB_TLSKEY_GFX|PUT_HEADER_NEW|MASK_COLOR_32|FB_RTLIB_CTX)'             | grep -v '^== FB_RTLIB_CTX' > "$TMP/ref-$target.txt"

        if diff -u --strip-trailing-cr "$TMP/ref-$target.txt" "$TMP/fb-$target.txt"                > "$TMP/fb-$target.diff"; then
            echo "gate-abi: fb/$target -- mirror matches the runtime"
        else
            echo "gate-abi: fb/$target -- MIRROR DISAGREES WITH THE RUNTIME" >&2
            cat "$TMP/fb-$target.diff" >&2
            status=1
        fi
    done
fi

# ---------------------------------------------------------------------------
# The generated FB_RTLIB_CTX offsets, and a BEHAVIOURAL check that they are real.
#
# A wrong offset compiles and reads something plausible. So this does not just
# regenerate and diff -- it drives the real gfxlib2 through SCREENRES/SCREEN 0
# and watches the hook table populate and clear. Garbage cannot do that.
if [ -x "$FBC" ]; then
    sh "$HERE/gen-rtlctx.sh" "$TMP/rtlctx-offsets.ti" > /dev/null
    if diff -q --strip-trailing-cr "$GFX/abi/rtlctx-offsets.ti"              "$TMP/rtlctx-offsets.ti" > /dev/null 2>&1; then
        echo "gate-abi: rtlctx -- generated offsets are current"
    else
        echo "gate-abi: rtlctx -- abi/rtlctx-offsets.ti is STALE, re-run tools/gen-rtlctx.sh" >&2
        status=1
    fi

    if "$FBC" -d nullptr=0 -gen llvm "$HERE/probe-rtlctx.bas" -x "$TMP/probe-rtlctx.exe"             > "$TMP/rtlctx.err" 2>&1; then
        if "$TMP/probe-rtlctx.exe" > "$TMP/rtlctx.out" 2>&1; then
            echo "gate-abi: rtlctx -- offsets address the real runtime fields (behavioural)"
        else
            echo "gate-abi: rtlctx -- BEHAVIOURAL CHECK FAILED" >&2
            cat "$TMP/rtlctx.out" >&2
            status=1
        fi
    else
        echo "gate-abi: rtlctx -- probe failed to build" >&2
        sed -n '1,10p' "$TMP/rtlctx.err" >&2
        status=1
    fi
fi

# ---------------------------------------------------------------------------
# The TLS seam. Proves we share gfxlib2's per-thread FB_GFXCTX rather than a
# private copy: open a 320x200x32 screen, draw, then read the context back
# through our mirror and check the screen's own geometry comes out. A wrong slot
# index, a wrong struct size or a wrong field offset each break this, and none
# of the three is visible to the compiler.
#
# Run in all four configurations -- the MT/non-MT split is real, because
# fb_GraphicsLock exists only in libfbmt.
if [ -x "$FBC" ]; then
    # label|flags -- the label is explicit so it does not have to be parsed
    # back out of the flags, which got it wrong ("win32 win32") the first time.
    for cfg in "win64|" "win64-mt|-mt" "win32|-target win32" "win32-mt|-target win32 -mt"; do
        label=${cfg%%|*}
        flags=${cfg#*|}

        if ! "$FBC" -d nullptr=0 $flags -gen llvm "$HERE/probe-rtlseam.bas"                  -x "$TMP/seam.exe" > "$TMP/seam.err" 2>&1; then
            echo "gate-abi: seam/$label -- FAILED TO BUILD" >&2
            sed -n '1,8p' "$TMP/seam.err" >&2
            status=1
            continue
        fi

        if "$TMP/seam.exe" > "$TMP/seam.out" 2>&1; then
            echo "gate-abi: seam/$label -- shares the runtime's gfx context"
        else
            echo "gate-abi: seam/$label -- TLS SEAM BROKEN" >&2
            cat "$TMP/seam.out" >&2
            status=1
        fi
    done
fi

# ---------------------------------------------------------------------------
# Hook installation. The first thing that CHANGES runtime state, so it is
# checked by consequence rather than by inspection: install a table whose
# printbuffproc captures, PRINT, and require that
#
#   - the captured line does NOT appear on stdout   (the hook really took over)
#   - the visible line DOES appear                  (clearing really gave it back)
#   - the sentinel file exists                      (exit_gfxlib2 fired in fb_End)
#
# A hook at the wrong offset, or with the wrong calling convention, fails the
# first of those by letting the text through to stdout.
if [ -x "$FBC" ]; then
    for cfg in "win64|" "win64-mt|-mt" "win32|-target win32" "win32-mt|-target win32 -mt"; do
        label=${cfg%%|*}
        flags=${cfg#*|}

        if ! "$FBC" -d nullptr=0 $flags -gen llvm "$HERE/probe-hooks.bas"                  -x "$TMP/hooks.exe" > "$TMP/hooks.err" 2>&1; then
            echo "gate-abi: hooks/$label -- FAILED TO BUILD" >&2
            sed -n '1,8p' "$TMP/hooks.err" >&2
            status=1
            continue
        fi

        rm -f "$TMP/sentinel.txt"
        "$TMP/hooks.exe" "$TMP/sentinel.txt" > "$TMP/hooks.out" 2>&1
        rc=$?

        bad=""
        [ "$rc" = "0" ] || bad="$bad exit=$rc"
        grep -q "VISIBLE-LINE" "$TMP/hooks.out" || bad="$bad no-visible-line"
        grep -q "CAPTURED-LINE" "$TMP/hooks.out" && bad="$bad capture-leaked-to-stdout"
        [ -f "$TMP/sentinel.txt" ] || bad="$bad exit-hook-did-not-fire"

        if [ -z "$bad" ]; then
            echo "gate-abi: hooks/$label -- console taken over, given back, exit hook fired"
        else
            echo "gate-abi: hooks/$label -- HOOK INSTALL BROKEN:$bad" >&2
            sed -n '1,12p' "$TMP/hooks.out" >&2
            status=1
        fi
    done
fi

# linux-x86_64 is owed: it needs the probe run under WSL against the Linux rtlib.
# Absent, not passing -- do not read a green run above as three-target coverage.

exit $status
