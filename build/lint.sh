#!/bin/sh
# lint.sh -- the rules a compiler cannot check for us.
#
#   build/lint.sh
#
# Two of these have teeth that the others do not:
#
#   PROVENANCE (check 1). R2 -- "never open a rtlib .c" -- was LIFTED on
#   2026-08-29 (PROVENANCE.md), so this check no longer guards a clean room.
#   It still guards something narrower and still worth having: tiko-rt is a
#   REIMPLEMENTATION IN FREEBASIC, not a transliteration, and no .c belongs in
#   this tree outside the closed list in src/c/. Reading a body to learn what a
#   function does is now allowed; copying one in is not.
#
#   THE FREESTANDING SUBSET (check 2) is docs/tiko-rt/RFC-0003. The include path
#   necessarily puts fb/*.bi, string.bi and the containers within reach; nothing
#   but this check keeps them out.
#
# Checks 2 and 3 look at code lines only -- a line whose first non-blank
# character is a comment marker is skipped. That means a banned word in a
# comment is fine, and a banned construct hidden inside a /' '/ block comment
# would be missed. Cheap, and wrong only in the safe direction.

. "$(dirname "$0")/common.sh"
cd "$RT_ROOT" || exit 2
fails=0

note( ) {
    echo "lint: $1" >&2
    fails=$((fails + 1))
}

# Source lines only: drop blank lines and whole-line ' comments.
codelines( ) {
    grep -vn "^[[:space:]]*'" "$1" 2>/dev/null | grep -v ':[[:space:]]*$'
}

# Everything tiko-rt owns -- provenance and hygiene apply to all of it.
srcfiles( ) {
    find src tests -name '*.bas' -o -name '*.bi' 2>/dev/null | sort
}

# Runtime code only. The freestanding subset applies HERE and nowhere else:
# tests/bench holds ordinary FreeBASIC programs that exercise the runtime from
# the outside, and they must use STRING, PRINT and dynamic arrays -- that is
# what they are measuring.
rtfiles( ) {
    find src tests/unit -name '*.bas' -o -name '*.bi' 2>/dev/null | sort
}

# ------------------------------------------------------------- 1. provenance

# 1a. No C outside src/c/, which is a closed list.
# obj/ and lib/ are build output and are gitignored; scanning them made the
# provenance check fire on bench.sh's own per-run result files, which are named
# for the runtime they came from and end in .c for "the C runtime".
for f in $(find . -name '*.c' -not -path './.git/*' -not -path './obj/*' -not -path './lib/*' 2>/dev/null); do
    case "$f" in
        ./src/c/*) ;;
        *) note "$f: C source outside src/c/ (RFC-0005)" ;;
    esac
done

# 1b. Everything in src/c/ is listed in its README with a reason. The residue
#     that stays C is a CLOSED list (RFC-0003 section 4); it must not grow
#     silently, which is exactly how such a list normally grows.
for f in $(find src/c -name '*.c' -o -name '*.s' 2>/dev/null); do
    base=$(basename "$f")
    if ! grep -q "$base" src/c/README.md 2>/dev/null; then
        note "$f: in src/c/ but not listed in src/c/README.md (RFC-0003 section 4)"
    fi
done

# 1c. No source names an rtlib .c path. Someone who has opened one tends to
#     cite it; this catches the cheap case, not a determined one.
for f in $(srcfiles); do
    if grep -qE 'rtlib/[A-Za-z0-9_/]+\.c' "$f" 2>/dev/null; then
        note "$f: references an rtlib .c path (RFC-0005)"
    fi
done

# ------------------------------------------------- 2. the freestanding subset

# Each entry: <label>|<extended regex>. RFC-0003 section 3.
BANNED="
string type|(^|[^a-zA-Z_])as[[:space:]]+string([^a-zA-Z_]|$)
ustring type|(^|[^a-zA-Z_])as[[:space:]]+ustring([^a-zA-Z_]|$)
dynamic array|(^|[^a-zA-Z_])redim([^a-zA-Z_]|$)
console io|(^|[^a-zA-Z_])(print|input|open|close|write)[[:space:]]*[#\"]
error statement|(^|[^a-zA-Z_])(on[[:space:]]+error|resume[[:space:]]+next)([^a-zA-Z_]|$)
inline asm|(^|[^a-zA-Z_])(asm|naked)([^a-zA-Z_]|$)
defer|(^|[^a-zA-Z_])defer([^a-zA-Z_]|$)
for each|(^|[^a-zA-Z_])for[[:space:]]+each([^a-zA-Z_]|$)
runtime header|#include[[:space:]]+(once[[:space:]]+)?\"(fb/|string\.bi|vector\.bi|map\.bi|set\.bi)
"

# ONE GREP PER PATTERN, NOT ONE PER (FILE, PATTERN).
#
# The obvious nesting -- for each file, for each pattern -- spawns a subshell and
# a grep per pair, and on Windows a process launch costs tens of milliseconds. At
# 55 files and 12 patterns that is ~660 launches and it had grown to 1m50s of
# wall clock, nearly all of it `sys`. Inverting the loops makes it 12 launches.
#
# The comment strip that `codelines` did per file is done here in awk instead,
# on grep's `file:line:text` output, because grep is now reading every file at
# once and there is no per-file hook left to put it in.
FILES=$(rtfiles)
echo "$BANNED" | while IFS='|' read -r label re; do
    [ -z "$label" ] && continue
    # ALIAS STRINGS ARE STRIPPED BEFORE MATCHING. The console-io pattern looks
    # for a statement -- open/close/print followed by '#' or '"' -- and
    # `declare function fdopen_ alias "open" (...)` matches it purely because
    # the C symbol name sits inside quotes. That is a declaration of a libc
    # file descriptor, not an OPEN statement, and the rule has no business
    # firing on it. The strip is on a copy used only for matching, so a real
    # statement on the same line is still caught.
    hits=$(sed 's/alias[[:space:]]*"[^"]*"/alias/g' $FILES 2>/dev/null | grep -iEn "$re" 2>/dev/null            | awk -v q="'" '{ l=$0; sub(/^[0-9]+:/,"",l); sub(/^[ 	]+/,"",l);
                             if( substr(l,1,1) != q ) print }'            | head -3)
    if [ -n "$hits" ]; then
        echo "lint: banned by the freestanding subset -- $label (RFC-0003 section 3)" >&2
        echo "$hits" | sed 's/^/    /' >&2
        echo x >> "$RT_ROOT/obj/.lintfail"
    fi
done

# ------------------------------------------------------------- 3. export rule
#
# libfb has TWO tiers, and they need different blocks. Measured with nm over the
# shipped win32 archive, 2026-08-28:
#
#   FBCALL entry points        _fb_MemSwap@12   _fb_MemCopyClear@16   -> "rtlib"
#   non-FBCALL internals       _fb_hListInit    _fb_hRtInit           -> "c"
#
# So a blanket ban on EXTERN "c" would force the WRONG decoration on every
# internal helper. Instead: "windows" and "Windows-MS" are never correct here,
# and EXTERN "c" must be opted into at the site with a NON-FBCALL marker, so
# that choosing it is a decision someone recorded rather than a default.

for f in $(find src -name '*.bas' -o -name '*.bi' 2>/dev/null); do
    for kind in '"windows"' '"Windows"' '"Windows-MS"'; do
        if codelines "$f" | grep -qE "extern[[:space:]]+$kind"; then
            note "$f: EXTERN $kind is never correct -- FBCALL is EXTERN \"rtlib\" (RFC-0002 section 2.2)"
        fi
    done
    # EXTERN "c" without the marker on the same line.
    if codelines "$f" | grep -iE 'extern[[:space:]]+"c"' | grep -qv 'NON-FBCALL'; then
        note "$f: EXTERN \"c\" without a '' NON-FBCALL marker -- FBCALL exports need EXTERN \"rtlib\" (RFC-0002 section 2.2)"
    fi
done

# ------------------------------------------------------- 4. index width
#
# 'as long' is 32-bit on every target. As a length, index or offset it is both
# an ABI mismatch (the ABI wants ssize_t) and a per-iteration sign-extend that
# LLVM cannot remove, because fbc emits no nsw (RFC-0004 section 3.2).
# Deliberately a warning-shaped check on suspicious NAMES: 'as long' is legal
# and correct for a C `int` parameter, which several entry points really take.

for f in $(rtfiles); do
    hits=$(codelines "$f" | grep -iE 'as[[:space:]]+long[[:space:]]+(len|length|size|idx|index|ofs|offset|pos|count)' | head -3)
    if [ -n "$hits" ]; then
        note "$f: a length/index declared 'as long' -- use 'integer' (RFC-0003 section 5.1)"
        echo "$hits" | sed 's/^/    /' >&2
    fi
done

# ----------------------------------------------------- 5. trailing whitespace

for f in $(srcfiles) $(find build -name '*.sh' 2>/dev/null); do
    if grep -qE '[[:space:]]+$' "$f" 2>/dev/null; then
        note "$f: trailing whitespace"
    fi
done

# ------------------------------------------------------------------ verdict

if [ -f "$RT_ROOT/obj/.lintfail" ]; then
    fails=$((fails + $(wc -l < "$RT_ROOT/obj/.lintfail")))
    rm -f "$RT_ROOT/obj/.lintfail"
fi

if [ "$fails" -gt 0 ]; then
    echo "lint: $fails problem(s)" >&2
    exit 1
fi
echo "lint: ok"
