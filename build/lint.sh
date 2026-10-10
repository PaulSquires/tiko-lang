#!/bin/sh
# lint.sh -- structural rules that a compiler cannot check for us.
#
#   build/lint.sh
#
# lib/rt is EXCLUDED from every rule here. The runtime is a separate source area
# with its own lint (lib/rt/build/lint.sh) and its own conventions -- it was gated
# under those before it was consolidated into this tree, and re-judging it by the
# compiler's rules produced 7 failures on code that had passed its own lint.
#
# These are the rules from docs/plan/14 section 6 that are mechanical. A violation is
# a build failure, not a warning, because every one of them is cheap to fix now and
# expensive to fix after it has spread.
#
# Checks:
#   1. LAYERING. A module may only include from its own layer or below.
#   2. GLOBAL MUTABLE STATE. 'dim shared' is banned outside an explicit allowlist.
#   3. FILE SIZE. No source file over 1500 lines.
#   4. TRAILING WHITESPACE.
#   5. TABS in source. tiko-lang sources are space-indented.
#   6. UNSIGNED LOOP COUNTERS.
#   7. NARROW LOOP COUNTERS in lib/gfx hot loops (see below -- costs 4x).
#   8. ATTRIBUTION HEADER on every lib/gfx source (LGPL obligation).
#   9. MODULE DIRECTIVES in tiko's own source: '#import "std/..."' only.
#
# TODO: port to tools/tiko-lang-lint once tiko-lang can compile itself, so the lint is
# self-hosted like everything else.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2
fails=0

note( ) {
    echo "lint: $1" >&2
    fails=$((fails + 1))
}

# ---------------------------------------------------------------- 1. layering
#
# layer 0: support
# layer 1: source diag        -- plus the intra-layer rule below
# layer 2: lexer pp parser ast types symbols semantics
# layer 3: mir lowering
# layer 4: target abi codegen
# layer 5: toolchain driver
# layer 6: api               -- the editor's tikoParser.dll, over the driver
#
# INTRA-LAYER RULE: diag may include source (it renders locations), source may NOT
# include diag. The source manager reports failure by return value, never by
# diagnostic, which is what keeps it usable from a test or a fuzz harness.
# EVERY RULE IS ONE PASS OVER ALL ITS FILES, not a process per file. The per-file loops
# started some 5,000 short processes -- grep, sed, sort, wc, tr, a subshell for every
# layer_of -- and at Git Bash's ~40ms a process that was 250 seconds (2026-09-28). The
# rules and the messages are the same; only the order of the messages within one rule
# can differ.
SRC=$(find src -name '*.bas' -o -name '*.bi' | sort)
ALL=$(find src tools lib -path 'lib/rt' -prune -o \( -name '*.bas' -o -name '*.bi' \) -print | sort)
# THE STANDARD LIBRARY'S MODULES (pkg/std, real modules since 2026-10-10) are held to the
# size, whitespace and tab rules too. Not to layering or the 'dim shared' allowlist: those
# are the compiler's own architecture, and a module's state is its own.
STD=$(find pkg/std -name '*.tiko' -o -name '*.ti' | sort)

# THE FILES OF $2.. THAT grep $1 SELECTS, one per line; nothing -- not stdin -- for none.
grep_files( ) {
    pat=$1; shift
    [ $# -gt 0 ] || return 0
    grep -lE "$pat" "$@" 2>/dev/null
}

grep -oH '#include once "[a-z]*/' $SRC 2>/dev/null | \
sed 's/:#include once "/ /; s|/$||' | sort -u | awk '
function layer( d ) {
    if (d == "support") return 0
    if (d == "source" || d == "diag") return 1
    if (d ~ /^(lexer|pp|parser|ast|types|symbols|semantics)$/) return 2
    if (d == "mir" || d == "lowering") return 3
    if (d ~ /^(target|abi|codegen)$/) return 4
    if (d ~ /^(toolchain|driver|cimport)$/) return 5
    if (d == "api") return 6
    return 9
}
{
    f = $1; inc = $2
    split( f, part, "/" ); dir = part[2]
    if (dir == "tko.bi") next
    mine = layer( dir ); if (mine == 9) next
    theirs = layer( inc ); if (theirs == 9) next
    if (theirs > mine) print "LAYERING " f " (layer " mine ") includes " inc "/ (layer " theirs ")"
    if (dir == "source" && inc == "diag") print "LAYERING " f " -- source/ must not depend on diag/"
}' > build/.lint.layer
if [ -s build/.lint.layer ]; then
    while read -r l; do note "$l"; done < build/.lint.layer
fi
rm -f build/.lint.layer

# ------------------------------------------------- 2. global mutable state
#
# Allowlist, with the reason each is allowed:
#
#   diag/diagnostic.bas   the DiagId table          write-once, built from an X-macro
#   driver/cmdline.bas    the option table          write-once, built from an X-macro
#   lexer/lexer.bas       the token-kind name table write-once, built from an X-macro
#   parser/expr.bas       node names + infix table   write-once, built from an X-macro
#   parser/intrinsics.bas the intrinsic form table    write-once, built from an X-macro
#   types/type.bas        the builtin metadata table write-once, built from an X-macro
#   symbols/symbol.bas    the symbol-kind name table  write-once, built from an X-macro
#   diag/engine.bas       the stderr file handle    a PROCESS resource, opened once
#
# The first three are lazily-built constant tables: written by their Init sub and
# read-only thereafter, so they are shared state but not mutable state. The fourth is
# a handle to a process-wide resource; opening it twice under threads would be benign.
# Nothing else may be added here without the same kind of argument.
allow_shared( ) {
    case "$1" in
        src/diag/diagnostic.bas|src/driver/cmdline.bas) return 0 ;;
        src/lexer/lexer.bas|src/diag/engine.bas) return 0 ;;
        src/parser/expr.bas|src/parser/intrinsics.bas) return 0 ;;
        src/types/type.bas|src/symbols/symbol.bas) return 0 ;;
        *) return 1 ;;
    esac
}
for f in $(grep_files '^[[:space:]]*dim shared' $SRC); do
    if ! allow_shared "$f"; then
        note "GLOBAL STATE $f uses 'dim shared' (docs/plan/01 D12)"
    fi
done

# ------------------------------------------------------------- 3. file size
wc -l $ALL $STD | awk '$2 != "total" && $1 > 1500 { print "SIZE " $2 " is " $1 " lines (limit 1500)" }' > build/.lint.size
while read -r l; do note "$l"; done < build/.lint.size
rm -f build/.lint.size

# ---------------------------------------- 6. unsigned loop counters and bounds
#
# 'for i as ulong = 0 to n - 1' with n = 0 underflows to 4294967295 and the loop
# runs four billion times. This cost real debugging time twice, so it is a rule:
# loop counters are signed, and so is anything they are compared against.
for f in $(grep_files 'for [A-Za-z_][A-Za-z0-9_]* as (ulong|uinteger|ulongint|ushort|ubyte) ' $ALL); do
    note "UNSIGNED LOOP $f uses an unsigned loop counter (see docs/internals/known-toolchain-issues.md)"
done

# ------------------------- 7. narrow loop counters in the graphics hot loops
#
# MEASURED 2026-08-29. fbc's LLVM backend widens a narrow induction variable
# through i32 -> sext i64 -> add -> trunc i32, and ScalarEvolution cannot read
# that as an affine recurrence, so the loop does not vectorise. On win64, where
# FB 'long' is 32-bit and a pointer is 64-bit, that is the difference between
# 1.04x and 3.96x of the equivalent C on a row-convert loop.
#
# 'integer' is pointer-width on every target we build, so it is the portable
# answer. This applies only to the pixel-pushing modules; elsewhere a 'long'
# counter is fine and this rule would just be noise.
for f in $(grep_files 'for [A-Za-z_][A-Za-z0-9_]* as (long|short|byte) ' $(find lib/gfx/raster lib/gfx/blit lib/gfx/put -name '*.bas' -o -name '*.bi' 2>/dev/null | sort)); do
    note "NARROW LOOP $f uses a narrow loop counter in a hot path; use 'integer' (docs/graphics/probe-results.md)"
done

# ------------------------------- 8. attribution headers on lib/gfx sources
#
# libtkogfx is a derivative work of gfxlib2 and carries its licence. Every file
# must say where its bodies came from -- 'Derived from: <gfxlib2 file>' or
# 'ORIGINAL WORK'. This is a licence obligation, and it is also how you find the
# file to re-check when upstream fbc fixes a rasterizer bug.
GFX=$(find lib/gfx -name '*.bas' -o -name '*.bi' -o -name '*.c' 2>/dev/null | sort)
if [ -n "$GFX" ]; then
    attributed=" $(awk 'FNR <= 20 && /Derived from:|ORIGINAL WORK/ { print FILENAME; nextfile }' $GFX | tr '\n' ' ') "
    for f in $GFX; do
        case "$attributed" in
            *" $f "*) ;;
            *) note "ATTRIBUTION $f has no provenance header (see docs/graphics/RFC-0001 D13)" ;;
        esac
    done
fi

# ------------------------------------ 9. module directives in tiko's source
#
# tiko bootstrapped from fbc-modern, which has no module system, and until 2026-10-10 a
# '#import' in src/ or tools/ was refused outright. The seed is tiko itself now (seed-3 on),
# and the compiler's source imports std/containers and std/fs -- the std modules ARE what
# inc/fb was. What stays refused: '#module' and '#export' (tiko's source is a program, not
# a module) and an import of anything but std, which would make the compiler depend on a
# package the seed does not carry. Directives at the start of a line only, so comments and
# the preprocessor's own 'case "import"' do not match.
for f in $(grep_files '^[[:space:]]*#[[:space:]]*(module|export)([^A-Za-z0-9_]|$)' $(find src tools \( -name '*.bas' -o -name '*.bi' \) -print | sort)); do
    note "MODULES $f uses #module/#export; tiko's own source is not a module (ADR 0017)"
done
for f in $(grep_files '^[[:space:]]*#[[:space:]]*import[[:space:]]+"([^s]|s[^t]|st[^d]|std[^/])' $(find src tools \( -name '*.bas' -o -name '*.bi' \) -print | sort)); do
    note "MODULES $f imports something other than std/ (only the std modules travel with the seed)"
done
# ...AND NO fb/ LIBRARY HEADER: they are the std modules since 2026-10-10, inc/fb is gone, and
# an include of one would find a stale copy in some seed's inc/ or nothing at all.
for f in $(grep_files '^[[:space:]]*#[[:space:]]*include[[:space:]]+(once[[:space:]]+)?"(fb/|containers\.bi")' $(find src tools pkg \( -name '*.bas' -o -name '*.bi' -o -name '*.tiko' -o -name '*.ti' \) -print | sort)); do
    note "MODULES $f includes an fb/ library header or containers.bi; #import the std module instead"
done

# ------------------------------------- 4/5. trailing whitespace and hard tabs
# THE CR OF A CRLF FILE IS NOT TRAILING WHITESPACE. Git Bash grep treats a CR-LF pair as
# the line terminator and never saw it; the WSL grep does not, so every CRLF source in the
# tree read as a violation the moment this script became runnable on Linux -- 160 of them.
# awk strips the CR and tests what the line actually ends in.
for f in $(awk '{ gsub( /\r/, "" ) } /[[:space:]]$/ { print FILENAME; nextfile }' $ALL $STD); do
    note "WHITESPACE $f has trailing whitespace"
done
# NOT 'grep -P'. Git Bash refuses it outright -- 'grep: -P supports only unibyte and UTF-8
# locales' -- and the 2>/dev/null that hid the message hid the fact that this check had
# never once run on Windows. It found two real violations the first time it did. A literal
# tab is portable.
for f in $(grep_files "$(printf '\t')" $ALL $STD); do
    note "TABS $f contains hard tabs"
done

if [ "$fails" -gt 0 ]; then
    echo "lint: $fails problem(s)" >&2
    exit 1
fi
echo "lint: ok"
exit 0
