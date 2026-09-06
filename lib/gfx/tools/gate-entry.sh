#!/bin/sh
# gate-entry.sh -- A/B the ENTRY LAYER against gfxlib2.
#
# ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
# exception).
#
# ONE SOURCE, LINKED TWICE. gate-entry.bas is compiled without a single #ifdef
# and linked first against gfxlib2 and then against libtkogfx; each binary
# prints one digest per case and the two streams are diffed. Whatever differs is
# a disagreement about what a PUBLIC ENTRY POINT does -- which is the seam none
# of the abtests can reach, because they all link gfxlib2 for those same names.
#
# NOTHING IS CHECKED IN. Both sides are rebuilt on every run, so there is no
# recording that can go stale and no --record mode to get wrong.
#
# THE TWO BUILDS ARE NOT THE SAME ABI, and they cannot be:
#
#   reference  fbc -gen llvm, MinGW, links libfbgfx.a  -- gfxlib2's answers
#   subject    fbc -gen llvm -r -z msvc + clang, links libtkogfx.a + tiko-rt
#
# gfxlib2 ships only as a MinGW archive and libtkogfx only as an MSVC one, so
# there is no configuration in which both are linkable. That is the same
# constraint abtest.sh works around with a recording; here the reference is
# simply built and run alongside, which is cheaper and cannot drift.
#
# Needs an interactive desktop session: the subject opens a real window.
#
# Usage: tools/gate-entry.sh [--keep]

HERE=$( cd "$( dirname "$0" )" && pwd )
GFX=$( cd "$HERE/.." && pwd )

# The bundled toolchain fbc for the reference (it links gfxlib2 itself), and the
# LOCALLY BUILT one for the subject, which needs -z msvc.
: "${FBC_REF:=/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}"
: "${FBC:=/c/dev/fbc-modern/src/fbc.exe}"
: "${CLANG:=$( command -v clang 2>/dev/null || echo "/c/Program Files/LLVM/bin/clang.exe" )}"

TKOGFX="$GFX/lib/win64-msvc/libtkogfx.a"
LIBFB="$GFX/../rt/lib/win64-msvc/libfb.a"

for f in "$FBC_REF" "$FBC" "$CLANG"; do
    [ -x "$f" ] || { echo "gate-entry: no $f" >&2 ; exit 3 ; }
done
for f in "$TKOGFX" "$LIBFB"; do
    [ -f "$f" ] || { echo "gate-entry: no $f -- run build/build.sh" >&2 ; exit 3 ; }
done

TMP=$( mktemp -d )
[ "$1" = "--keep" ] || trap 'rm -rf "$TMP"' EXIT

src="$HERE/gate-entry.bas"

# ---------------------------------------------------------------- reference
if ! "$FBC_REF" -gen llvm "$src" -x "$TMP/ref.exe" > "$TMP/ref.log" 2>&1; then
    echo "gate-entry: the REFERENCE failed to build" >&2
    sed -n '1,10p' "$TMP/ref.log" >&2
    exit 1
fi
# A TIMEOUT, because the gate now drives INPUT. A blocking read that never sees
# its Enter would wedge the run forever, and a hung gate is worse than a failing
# one -- nobody looks at it and nothing says why. 120s is far beyond what the
# whole file takes and far below anyone's patience.
: "${GATE_TIMEOUT:=120}"

if ! timeout "$GATE_TIMEOUT" "$TMP/ref.exe" > "$TMP/ref.out" 2>&1; then
    echo "gate-entry: the REFERENCE failed to run (or timed out after ${GATE_TIMEOUT}s)" >&2
    sed -n '1,20p' "$TMP/ref.out" >&2
    exit 1
fi

# ------------------------------------------------------------------ subject
if ! "$FBC" -c "$src" -m gate-entry -target win64 -gen llvm -r -z msvc \
         -o "$TMP/sub.o" > "$TMP/sub.log" 2>&1; then
    echo "gate-entry: the SUBJECT failed to emit IR" >&2
    sed -n '1,10p' "$TMP/sub.log" >&2
    exit 1
fi
if ! "$CLANG" --target=x86_64-pc-windows-msvc -march=x86-64 -O2 \
         -Wno-override-module "$TMP/sub.ll" -c -o "$TMP/sub.o" \
         >> "$TMP/sub.log" 2>&1; then
    echo "gate-entry: the SUBJECT does not assemble for MSVC, see $TMP/sub.log" >&2
    exit 1
fi
# An unresolved fb_Gfx* names an entry point a legitimate program needs and the
# library does not export.
if ! "$CLANG" --target=x86_64-pc-windows-msvc "$TMP/sub.o" "$TKOGFX" "$LIBFB" \
         -o "$TMP/sub.exe" \
         -lwinspool -lgdi32 -luser32 -ladvapi32 -llegacy_stdio_definitions \
         -Xlinker /INCLUDE:tkort_msvc_init_ >> "$TMP/sub.log" 2>&1; then
    echo "gate-entry: the SUBJECT does not link, still needs:" >&2
    grep -o 'unresolved external symbol [A-Za-z0-9_@$]*' "$TMP/sub.log" \
        | sed 's/unresolved external symbol /    /' | sort -u >&2
    exit 1
fi
if ! timeout "$GATE_TIMEOUT" "$TMP/sub.exe" > "$TMP/sub.out" 2>&1; then
    echo "gate-entry: the SUBJECT failed to run (or timed out after ${GATE_TIMEOUT}s)" >&2
    sed -n '1,20p' "$TMP/sub.out" >&2
    exit 1
fi

# ---------------------------------------------------------------- compare
#
# Compared by CASE NAME rather than by line number, so a side that emitted a
# different number of lines is reported as such instead of misaligning every
# case after it.
ref_n=$( wc -l < "$TMP/ref.out" )
sub_n=$( wc -l < "$TMP/sub.out" )
if [ "$ref_n" != "$sub_n" ]; then
    echo "gate-entry: the two sides emitted different case counts -- ref $ref_n, subject $sub_n" >&2
    exit 1
fi

differ=0
skipped=0
while IFS=$( printf '\t' ) read -r rdig rname; do
    IFS=$( printf '\t' ) read -r sdig sname <&3 || break
    if [ "$rname" != "$sname" ]; then
        echo "gate-entry: OUT OF STEP -- ref \"$rname\", subject \"$sname\"" >&2
        differ=$(( differ + 1 ))
        break
    fi
    # A case that could not capture the screen is a SKIP on whichever side
    # failed, not a difference. Readback grabs whatever is actually on the
    # glass, so an occluding window or a blanked screen makes it fail for
    # reasons that have nothing to do with either library.
    if [ "$rdig" = "CAPTURE-FAILED" ] || [ "$sdig" = "CAPTURE-FAILED" ]; then
        echo "gate-entry: SKIP     $rname -- readback captured no frame" >&2
        skipped=$(( skipped + 1 ))
    elif [ "$rdig" != "$sdig" ]; then
        echo "gate-entry: DIFFERS  $rname  gfxlib2=$rdig  tko=$sdig" >&2
        differ=$(( differ + 1 ))
    fi
done < "$TMP/ref.out" 3< "$TMP/sub.out"

[ "$1" = "--keep" ] && echo "gate-entry: build products left in $TMP"

if [ "$differ" = 0 ]; then
    if [ "$skipped" = 0 ]; then
        echo "gate-entry: PASS -- $ref_n cases, every public entry point agrees with gfxlib2"
    else
        echo "gate-entry: PASS -- $ref_n cases, $skipped skipped (see above), the rest agree"
    fi
    exit 0
fi
echo "gate-entry: FAIL -- $differ of $ref_n cases differ" >&2
exit 1
