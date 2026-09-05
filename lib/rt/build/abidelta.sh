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

# AND BOTH MUST BE THE SAME CONFIGURATION AS EACH OTHER AND AS THIS RUN.
#
# This script's whole job is a symbol-table differential, and lib/<target>/ holds
# ONE archive per target that every configuration overwrites. The first time it
# was run it compared a RELEASE MinGW archive against a DEBUG MSVC one and
# reported exp2, floorf, fputc, fabs and llabs as ABI differences. They were -O2
# inlining. The header above says this script refuses to build anything itself
# for that reason; refusing to build is only half of it -- it also has to refuse
# to READ two archives that do not belong together.
for d in "$RT_ROOT/lib/win64" "$RT_ROOT/lib/win64-msvc"; do
    [ -f "$d/.config" ] || rt_die "no .config beside $d/libfb.a -- rebuild it with build/build.sh $CFG"
    have=$(cat "$d/.config")
    [ "$have" = "$CFG" ] || rt_die "$d was built [$have], not [$CFG] -- the two sides must match, and match this run"
done

WORK="$RT_ROOT/obj/abidelta"
rm -rf "$WORK"; mkdir -p "$WORK"

# EXPORTS. '__real@...' and '__xmm@...' are excluded for the reason build.sh
# excludes them from its one-symbol-one-member check: under MSVC clang names a
# float constant after its bit pattern and COMDATs it, so every module using 1.0
# defines the same symbol and the linker folds them. They are not entry points.
exports( ) {
    "$TKORT_NM" -g --defined-only "$1" 2>/dev/null \
        | awk '$2 ~ /^[TDBR]$/ && $3 !~ /^__(real|xmm|ymm|zmm)@/ && $3 !~ /^\?\?_C@/ { print $3 }' \
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

# THE MSVC ARCHIVE IS MEANT TO HAVE THREE EXPORTS THE GATED ONE DOES NOT.
#
#   _ZN10fb_Object$C1Ev   fb_Object$'s default constructor, and
#   __fb_ZTS6Object       its RTTI record. On the gnu targets these come from
#                         fbc's own oop_object.o, which the gate links; under
#                         MSVC there is no fbc archive to borrow from, so
#                         src/c/oop_object.c supplies them and is empty
#                         elsewhere. build/gatemsvc.sh is what found the gap:
#                         728 modules of fbc's suite linked three symbols
#                         short. RFC-0008 section 18.4.
#
# A string COMDAT (??_C@...) is excluded by the exports filter rather than
# listed: clang names a string literal after its own hash and COMDATs it, the
# same way it does __real@ and __xmm@ for float constants. "6OBJECT" is the
# RTTI id and the symbol is an artefact of how MSVC emits it, not an entry
# point.
#
# tkort_msvc_init_ is the third, and the
# gated one is not: src/c/msvcinit.c is empty on the gnu targets, where fbc's
# own fbrt0.o already calls fb_hRtInit. It is a .CRT$XCB table entry, not an
# entry point, and a program names it only through /INCLUDE:.
comm -13 "$WORK/g.exp" "$WORK/m.exp"\
    | grep -v '^tkort_msvc_init_$'\
    | grep -v '^_ZN10fb_Object\$C1Ev$'\
    | grep -v '^__fb_ZTS6Object$' > "$WORK/only.m" || true

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
#   __mingw_sprintf-> sprintf            src/inc/fmt.bi -- the C99 half
#   snprintf       -> __stdio_common_vsprintf
#                                       src/inc/fmt.bi -- the MSVCRT half. The
#                       UCRT's whole printf family is a wrapper over that one
#                       function, and the legacy behaviours fbc inherits from
#                       MinGW (three-digit exponents, 1.#INF, round-half-away)
#                       are OPTION BITS to it. Binding it directly is how the
#                       msvc build reproduces them; the gated archive gets them
#                       from MSVCRT's snprintf and needs no such call.
#   _findfirst     -> _findfirst64i32   src/fs/legacydir.bas -- NOT one function.
#   _findnext      -> _findnext64i32        The undecorated name is _finddata32_t
#                       in the UCRT and _finddata64i32_t in MinGW: name at offset
#                       20 against 36, so the same struct filled by the other CRT
#                       gives the right attributes and an EMPTY name. The 64i32
#                       spellings are what MSVC's own struct _finddata_t
#                       describes, so FB_DIRCTX_ is identical on both.
#   fseeko/ftello  -> _fseeki64/_ftelli64
#   strcasecmp     -> _stricmp           the UCRT has no POSIX spelling
#   strncasecmp    -> _strnicmp
#   (msvc gains _fltused, an MSVC CRT marker the CRT itself supplies)
#
# fb_hRtExit is the one that is NOT a rename. src/c/msvcinit.c hands it to
# atexit and calls fb_hRtInit, so the MSVC archive references BOTH where the
# gated archive references neither --
# there fbc's own fbrt0.o holds that reference, from outside the archive.
#
# A NEW name on either side is the thing this check exists to catch: it means
# the two builds have started to diverge somewhere nobody decided they should.
cat > "$WORK/allow.g" <<'EOT'
___chkstk_ms
__iob_func
__mingw_sprintf
_findfirst
_findnext
fseeko
ftello
strcasecmp
strncasecmp
EOT
cat > "$WORK/allow.m" <<'EOT'
__acrt_iob_func
__chkstk
__stdio_common_vsprintf
_findfirst64i32
_findnext64i32
_fltused
_fseeki64
_ftelli64
_stricmp
_strnicmp
fb_hRtExit
fb_hRtInit
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

# THE INTERSECTION, NOT ONE SIDE'S COUNT. This line used to print g.exp's
# length and call it "identical", which is the gated archive's export count
# and not the number the two agree on -- 1240 against 1236 once the MSVC side
# gained fb_Object's constructor and the gnu side its .refptr stubs.
echo "abidelta: ok [$CFG] -- $(comm -12 "$WORK/g.exp" "$WORK/m.exp" | wc -l | tr -d ' ') exported names identical,"
# COUNTED, NOT TYPED. This line read "the 7 known renames" while allow.g held
# nine of them -- a hardcoded number in the PASS message of a check whose
# whole job is to notice when a list changes.
echo "abidelta: imports differ only by the $(wc -l < "$WORK/allow.g" | tr -d ' ') known renames and the two startup"
echo "abidelta: hooks, and .refptr stubs aside the MSVC archive is the gated archive."
