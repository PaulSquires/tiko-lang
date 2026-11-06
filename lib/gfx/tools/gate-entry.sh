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
#   subject    tiko, windows-x86_64, links the tree's libtkogfx.a + tiko-rt
#
# gfxlib2 ships only as a MinGW archive and libtkogfx only as an MSVC one, so
# there is no configuration in which both are linkable. That is the same
# constraint abtest.sh works around with a recording; here the reference is
# simply built and run alongside, which is cheaper and cannot drift.
#
# Needs an interactive desktop session: the subject opens a real window.
#
# AN ORACLE SCRIPT: fbc builds only the reference, gfxlib2's half -- TKO_ORACLE_FBC, else
# fbc-modern's toolchain fbc -- and without one this SKIPS rather than fails. The subject
# is built by the tree's bin/tiko since 2026-10-10, where it was fbc '-z msvc' and clang.
#
# Usage: tools/gate-entry.sh [--keep]

HERE=$( cd "$( dirname "$0" )" && pwd )
GFX=$( cd "$HERE/.." && pwd )

# THE HOST PICKS THE TARGET. On Windows the subject is windows-x86_64 against the
# reference's MinGW gfxlib2; on Linux it is linux-x86_64 against fbc-linux's gfxlib2
# and its X11 driver (docs/graphics RFC-0012), which needs an X display -- under
# WSL, WSLg's. Set FBGFX=null to compare the null driver instead.
ROOTDIR=$( cd "$GFX/../.." && pwd )
case "$(uname -s)" in
    Linux) HOST=linux ;;
    *)     HOST=windows ;;
esac

# The oracle fbc for the reference (it links gfxlib2 itself); the tree's tiko for the
# subject.
if [ "$HOST" = linux ]; then
    FBC_REF=${TKO_ORACLE_FBC:-$( command -v fbc 2>/dev/null )}
    : "${TIKO:=$ROOTDIR/bin/tiko}"
    TARGET=linux-x86_64
    EXE=""
else
    FBC_REF=${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
    : "${TIKO:=$ROOTDIR/bin/tiko.exe}"
    TARGET=windows-x86_64
    EXE=".exe"
fi

TKOGFX="$GFX/lib/$TARGET/libtkogfx.a"
LIBFB="$GFX/../rt/lib/$TARGET/libfb.a"
# The import libraries tiko's own windows-x86_64 link resolves the CRT and Win32
# through (build/implibs.sh builds them). See the subject link below.
: "${MSVC_IMPLIBS:=$ROOTDIR/toolchains/tiko-windows/lib/windows-x86_64}"

# KNOWN DIFFERENCES, by case name, each with its reason -- excused, never skipped: an
# excused case that starts to AGREE fails the gate too, so the excuse cannot outlive it.
#   linux: tiko-rt converts a wide character with no ASCII form to UTF-8 (3 bytes), and
#          libfb to one byte -- the RUNTIME decides the string before either library
#          draws it (RFC-0012 F3).
KNOWN=""
[ "$HOST" = linux ] && KNOWN="a wide character with no ascii"

[ -n "$FBC_REF" ] && [ -x "$FBC_REF" ] || { echo "gate-entry: SKIPPED -- no oracle fbc at '$FBC_REF' (TKO_ORACLE_FBC)" ; exit 0 ; }
[ -x "$TIKO" ] || { echo "gate-entry: no $TIKO -- run build/build.sh" >&2 ; exit 3 ; }
for f in "$TKOGFX" "$LIBFB"; do
    [ -f "$f" ] || { echo "gate-entry: no $f -- run build/build.sh" >&2 ; exit 3 ; }
done
if [ "$HOST" = windows ]; then
    [ -f "$MSVC_IMPLIBS/ucrtbase.lib" ] || {
        echo "gate-entry: no ucrtbase.lib in $MSVC_IMPLIBS -- run build/implibs.sh build --out <dir>" >&2 ; exit 3 ; }
fi

# WSLg DROPS THE FIRST X CLIENT after a pause ("X connection to :0 broken"), whichever
# binary it is -- measured on both gfxlib2's and ours. One retry, on exactly that.
run_case_file( ) {
    timeout "$GATE_TIMEOUT" "$1" > "$2" 2>&1 && return 0
    grep -q "X connection to .* broken" "$2" || return 1
    sleep 2
    timeout "$GATE_TIMEOUT" "$1" > "$2" 2>&1
}

TMP=$( mktemp -d )
[ "$1" = "--keep" ] || trap 'rm -rf "$TMP"' EXIT

src="$HERE/gate-entry.bas"

# ---------------------------------------------------------------- reference
REFGEN="-gen llvm"
[ "$HOST" = linux ] && REFGEN=""
if ! "$FBC_REF" $REFGEN "$src" -x "$TMP/ref$EXE" > "$TMP/ref.log" 2>&1; then
    echo "gate-entry: the REFERENCE failed to build" >&2
    sed -n '1,10p' "$TMP/ref.log" >&2
    exit 1
fi
# A TIMEOUT, because the gate now drives INPUT. A blocking read that never sees
# its Enter would wedge the run forever, and a hung gate is worse than a failing
# one -- nobody looks at it and nothing says why. 120s is far beyond what the
# whole file takes and far below anyone's patience.
: "${GATE_TIMEOUT:=120}"

if ! run_case_file "$TMP/ref$EXE" "$TMP/ref.out"; then
    echo "gate-entry: the REFERENCE failed to run (or timed out after ${GATE_TIMEOUT}s)" >&2
    sed -n '1,20p' "$TMP/ref.out" >&2
    exit 1
fi

# ------------------------------------------------------------------ subject
# An unresolved fb_Gfx* names an entry point a legitimate program needs and the
# library does not export. The -p directories come first, so the tree's libtkogfx and
# tiko-rt are the ones linked.
if [ "$HOST" = linux ]; then
    "$TIKO" "$src" -target linux-x86_64 -p "$GFX/lib/linux-x86_64" -p "$GFX/../rt/lib/linux-x86_64" \
        -o "$TMP/sub" > "$TMP/sub.log" 2>&1
else
    "$TIKO" "$src" -target windows-x86_64 -p "$( cygpath -m "$GFX/lib/windows-x86_64" )" \
         -p "$( cygpath -m "$GFX/../rt/lib/windows-x86_64" )" -p "$( cygpath -m "$MSVC_IMPLIBS" )" \
         -o "$TMP/sub.exe" > "$TMP/sub.log" 2>&1
fi
if [ ! -f "$TMP/sub$EXE" ]; then
    echo "gate-entry: the SUBJECT does not build:" >&2
    sed -n '1,10p' "$TMP/sub.log" >&2
    grep -o 'undefined symbol: [A-Za-z0-9_@$]*' "$TMP/sub.log" \
        | sed 's/undefined symbol: /    /' | sort -u >&2
    exit 1
fi
if ! run_case_file "$TMP/sub$EXE" "$TMP/sub.out"; then
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
known=0
is_known( ) {
    case "|$KNOWN|" in *"|$1|"*) return 0 ;; esac
    return 1
}
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
    elif is_known "$rname"; then
        if [ "$rdig" != "$sdig" ]; then
            echo "gate-entry: KNOWN    $rname -- excused above, by reason" >&2
            known=$(( known + 1 ))
        else
            echo "gate-entry: STALE    $rname -- excused, but now AGREES: drop the excuse" >&2
            differ=$(( differ + 1 ))
        fi
    elif [ "$rdig" != "$sdig" ]; then
        echo "gate-entry: DIFFERS  $rname  gfxlib2=$rdig  tko=$sdig" >&2
        differ=$(( differ + 1 ))
    fi
done < "$TMP/ref.out" 3< "$TMP/sub.out"

[ "$1" = "--keep" ] && echo "gate-entry: build products left in $TMP"

if [ "$differ" = 0 ]; then
    if [ "$skipped" = 0 ] && [ "$known" = 0 ]; then
        echo "gate-entry: PASS -- $ref_n cases, every public entry point agrees with gfxlib2"
    else
        echo "gate-entry: PASS -- $ref_n cases [$TARGET], $skipped skipped, $known known difference(s) (see above), the rest agree"
    fi
    exit 0
fi
echo "gate-entry: FAIL -- $differ of $ref_n cases differ" >&2
exit 1
