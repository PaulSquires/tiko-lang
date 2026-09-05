#!/bin/sh
# abidelta.sh -- assert that the MSVC archive differs from the GATED one by
# exactly the known set, and by nothing else.
#
#   build/abidelta.sh [Debug|Release|RelWithDebInfo]
#
# WHY THIS EXISTS. gate.sh works by dropping tiko-rt's archive into fbc's own
# link line, and fbc is a MinGW toolchain -- so an MSVC-ABI archive cannot be
# gated, and RFC-0006 section 5 calls that the permanent loss of the instrument
# that has caught every regression in this project.
#
# It is not a loss, because the two archives are THE SAME 202 OBJECTS. Only the
# clang --target differs; no source is conditional on the ABI except the five
# libc bindings below. So the MinGW archive stays gated at 4,890,432 assertions,
# and this script checks that the MSVC one is that archive and not another --
# which turns "the shipped artefact is not the gated one" from an assumption
# into something that fails a build when it stops being true.
#
# WHAT IT CANNOT DO, and RFC-0006 section 13 says so at more length: a symbol
# diff proves the two CORRESPOND, never that either RUNS. diff.sh's 114
# differentials are what test behaviour, and only the MinGW side of them is
# gated by fbc's suite. This is the cheap half of the answer, not the whole of it.
#
# BOTH ARCHIVES MUST BE THE SAME CONFIGURATION. Comparing a Release MinGW build
# against a Debug MSVC one reports exp2, floorf, fputc, fabs and llabs as ABI
# differences; they are inlining at -O2 and vanish at equal optimisation. That
# mistake was made once while writing this and is why the check builds nothing
# itself and refuses a missing archive rather than reaching for whatever is there.

set -e

. "$(dirname "$0")/common.sh"

CFG=${1:-Release}
rt_cfg_flags "$CFG" >/dev/null || rt_die "unknown configuration '$CFG'"

GNU="$RT_ROOT/lib/win64/libfb.a"
MSVC="$RT_ROOT/lib/win64-msvc/libfb.a"

for a in "$GNU" "$MSVC"; do
    [ -f "$a" ] || rt_die "no archive at $a -- run build.sh $CFG win64 and build.sh $CFG win64-msvc first"
done

WORK="$RT_ROOT/obj/abidelta"
rm -rf "$WORK"; mkdir -p "$WORK"

# EXPORTS. '__real@...' and '__xmm@...' are excluded for the reason build.sh
# excludes them from its one-symbol-one-member check: under MSVC clang names a
# float constant after its bit pattern and COMDATs it, so every module using 1.0
# defines the same symbol and the linker folds them. They are not entry points.
exports( ) {
    "$TKORT_NM" -g --defined-only "$1" 2>/dev/null \
        | awk '$2 ~ /^[TDBR]$/ && $3 !~ /^__(real|xmm|ymm|zmm)@/ { print $3 }' \
        | sort -u
}
imports( ) {
    "$TKORT_NM" -u "$1" 2>/dev/null | awk '{ print $2 }' | sort -u
}

exports "$GNU"  > "$WORK/g.exp"; exports "$MSVC" > "$WORK/m.exp"
imports "$GNU"  > "$WORK/g.imp"; imports "$MSVC" > "$WORK/m.imp"

rc=0

# ------------------------------------------------------------------ exports
#
# '.refptr.<name>' is a gnu-ABI indirection stub the backend emits once per
# object that references a shared datum. MSVC does not use them, so they are
# expected to be missing there and are not entry points either way.
comm -23 "$WORK/g.exp" "$WORK/m.exp" | grep -v '^\.refptr\.' > "$WORK/only.g" || true
comm -13 "$WORK/g.exp" "$WORK/m.exp"                        > "$WORK/only.m" || true

if [ -s "$WORK/only.g" ]; then
    echo "abidelta: exported by the GATED archive and NOT by the MSVC one:" >&2
    sed 's/^/    /' "$WORK/only.g" >&2
    rc=1
fi
if [ -s "$WORK/only.m" ]; then
    echo "abidelta: exported by the MSVC archive and NOT by the gated one:" >&2
    sed 's/^/    /' "$WORK/only.m" >&2
    rc=1
fi

# ------------------------------------------------------------------ imports
#
# THE ONLY PERMITTED DIFFERENCES, each a rename of one libc binding and each
# with its reason recorded at the site that makes it:
#
#   ___chkstk_ms   -> __chkstk           the backend's, chosen by the triple
#   __iob_func     -> __acrt_iob_func    src/sys/sys.bi -- a different CALL
#   __mingw_sprintf-> sprintf/snprintf   src/inc/fmt.bi -- one CRT, no split
#   fseeko/ftello  -> _fseeki64/_ftelli64
#   (msvc gains _fltused, an MSVC CRT marker the CRT itself supplies)
#
# A NEW name on either side is the thing this check exists to catch: it means
# the two builds have started to diverge somewhere nobody decided they should.
cat > "$WORK/allow.g" <<'EOT'
___chkstk_ms
__iob_func
__mingw_sprintf
fseeko
ftello
EOT
cat > "$WORK/allow.m" <<'EOT'
__acrt_iob_func
__chkstk
_fltused
_fseeki64
_ftelli64
sprintf
snprintf
EOT
sort -u "$WORK/allow.g" -o "$WORK/allow.g"
sort -u "$WORK/allow.m" -o "$WORK/allow.m"

comm -23 "$WORK/g.imp" "$WORK/m.imp" | comm -23 - "$WORK/allow.g" > "$WORK/bad.g" || true
comm -13 "$WORK/g.imp" "$WORK/m.imp" | comm -23 - "$WORK/allow.m" > "$WORK/bad.m" || true

if [ -s "$WORK/bad.g" ]; then
    echo "abidelta: imported by the GATED archive, not by MSVC, and not on the allowed list:" >&2
    sed 's/^/    /' "$WORK/bad.g" >&2
    rc=1
fi
if [ -s "$WORK/bad.m" ]; then
    echo "abidelta: imported by the MSVC archive, not by the gated one, and not on the allowed list:" >&2
    sed 's/^/    /' "$WORK/bad.m" >&2
    rc=1
fi

if [ "$rc" != "0" ]; then
    echo "abidelta: FAIL -- the MSVC archive is no longer the gated archive plus a rename." >&2
    echo "abidelta: either the difference is intended, and belongs on the list above with" >&2
    echo "abidelta: a reason, or it is a divergence nobody decided on." >&2
    exit 1
fi

echo "abidelta: ok [$CFG] -- $(wc -l < "$WORK/g.exp" | tr -d ' ') exported names identical,"
echo "abidelta: imports differ only by the 5 known renames, and .refptr stubs aside"
echo "abidelta: the MSVC archive is the gated archive."
