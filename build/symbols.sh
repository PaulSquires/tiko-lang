#!/bin/sh
# symbols.sh -- Gate 1, mechanised.
#
#   build/symbols.sh [target ...]
#
# For every symbol tiko-rt defines, assert that fbc's own archive defines a
# symbol with the BYTE-IDENTICAL name, on every target.
#
# This is the check that catches the whole class of win32 decoration mistakes,
# and it is worth having as a script rather than as an occasional look, because
# the failure is invisible until link time and then total:
#
#   FBCALL entry points     _fb_WstrCompare@8   -- stdcall, @N = argument bytes
#   non-FBCALL internals    _fb_hListInit       -- cdecl, no suffix
#
# Getting the @N wrong by four bytes produces a symbol that does not resolve; and
# omitting it produces one that resolves against nothing, silently, until a
# program calls it.
#
# win64 and linux-x86_64 have no decoration at all, so **they cannot catch any of
# this** -- which is the point of running it on all three.

set -eu

. "$(dirname "$0")/common.sh"
rt_check_tools

TARGETS=${*:-$RT_TARGETS}
fails=0
checked=0

for target in $TARGETS; do
    rt_is_target "$target" || rt_die "unsupported target '$target'"

    ours="$RT_ROOT/lib/$target/libfb.a"
    [ -f "$ours" ] || rt_die "no tiko-rt archive at $ours -- run build/build.sh first"

    refdir=$(rt_reflib "$target") || rt_die "no reference libfb.a for $target"
    theirs="$refdir/libfb.a"

    "$TKORT_NM" --defined-only "$theirs" 2>/dev/null \
        | awk '$2=="T"||$2=="D"||$2=="B"{print $3}' | sort -u > "$RT_ROOT/obj/.ref.$target"

    for sym in $("$TKORT_NM" --defined-only "$ours" 2>/dev/null \
                 | awk '$2=="T"||$2=="D"||$2=="B"{print $3}' | sort -u); do
        checked=$((checked + 1))
        if ! grep -qx "$sym" "$RT_ROOT/obj/.ref.$target"; then
            echo "symbols: $target: '$sym' is not defined by fbc's libfb.a" >&2
            # The likeliest cause, named rather than left to be worked out.
            base=$(echo "$sym" | sed 's/@[0-9]*$//; s/^_//')
            alt=$(grep -E "^_?${base}(@[0-9]+)?$" "$RT_ROOT/obj/.ref.$target" || true)
            [ -n "$alt" ] && echo "         fbc spells it: $alt" >&2
            fails=$((fails + 1))
        fi
    done
    rm -f "$RT_ROOT/obj/.ref.$target"
done

if [ "$fails" -gt 0 ]; then
    echo "symbols: $fails mismatch(es) over $checked symbols" >&2
    exit 1
fi
echo "symbols: ok -- $checked symbol names identical to fbc's, across $TARGETS"
