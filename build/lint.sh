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
#
# INTRA-LAYER RULE: diag may include source (it renders locations), source may NOT
# include diag. The source manager reports failure by return value, never by
# diagnostic, which is what keeps it usable from a test or a fuzz harness.
layer_of( ) {
    case "$1" in
        support) echo 0 ;;
        source|diag) echo 1 ;;
        lexer|pp|parser|ast|types|symbols|semantics) echo 2 ;;
        mir|lowering) echo 3 ;;
        target|abi|codegen) echo 4 ;;
        toolchain|driver|cimport) echo 5 ;;
        *) echo 9 ;;
    esac
}

for f in $(find src -name '*.bas' -o -name '*.bi' | sort); do
    dir=$(echo "$f" | cut -d/ -f2)
    [ "$dir" = "tko.bi" ] && continue
    mine=$(layer_of "$dir")
    [ "$mine" = "9" ] && continue

    grep -o '#include once "[a-z]*/' "$f" 2>/dev/null | \
    sed 's/#include once "//; s|/||' | sort -u | while read -r inc; do
        theirs=$(layer_of "$inc")
        [ "$theirs" = "9" ] && continue
        if [ "$theirs" -gt "$mine" ]; then
            echo "LAYERING $f (layer $mine) includes $inc/ (layer $theirs)"
        fi
        if [ "$dir" = "source" ] && [ "$inc" = "diag" ]; then
            echo "LAYERING $f -- source/ must not depend on diag/"
        fi
    done
done > build/.lint.layer
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
for f in $(find src -name '*.bas' -o -name '*.bi' | sort); do
    if grep -qE '^[[:space:]]*dim shared' "$f"; then
        if ! allow_shared "$f"; then
            note "GLOBAL STATE $f uses 'dim shared' (docs/plan/01 D12)"
        fi
    fi
done

# ------------------------------------------------------------- 3. file size
for f in $(find src tools lib -path 'lib/rt' -prune -o \( -name '*.bas' -o -name '*.bi' \) -print | sort); do
    n=$(wc -l < "$f")
    if [ "$n" -gt 1500 ]; then
        note "SIZE $f is $n lines (limit 1500)"
    fi
done

# ---------------------------------------- 6. unsigned loop counters and bounds
#
# 'for i as ulong = 0 to n - 1' with n = 0 underflows to 4294967295 and the loop
# runs four billion times. This cost real debugging time twice, so it is a rule:
# loop counters are signed, and so is anything they are compared against.
for f in $(find src tools lib -path 'lib/rt' -prune -o \( -name '*.bas' -o -name '*.bi' \) -print | sort); do
    if grep -nqE 'for [A-Za-z_][A-Za-z0-9_]* as (ulong|uinteger|ulongint|ushort|ubyte) ' "$f"; then
        note "UNSIGNED LOOP $f uses an unsigned loop counter (see docs/internals/known-toolchain-issues.md)"
    fi
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
for f in $(find lib/gfx/raster lib/gfx/blit lib/gfx/put -name '*.bas' -o -name '*.bi' 2>/dev/null | sort); do
    if grep -nqE 'for [A-Za-z_][A-Za-z0-9_]* as (long|short|byte) ' "$f"; then
        note "NARROW LOOP $f uses a narrow loop counter in a hot path; use 'integer' (docs/graphics/probe-results.md)"
    fi
done

# ------------------------------- 8. attribution headers on lib/gfx sources
#
# libtkogfx is a derivative work of gfxlib2 and carries its licence. Every file
# must say where its bodies came from -- 'Derived from: <gfxlib2 file>' or
# 'ORIGINAL WORK'. This is a licence obligation, and it is also how you find the
# file to re-check when upstream fbc fixes a rasterizer bug.
for f in $(find lib/gfx -name '*.bas' -o -name '*.bi' -o -name '*.c' 2>/dev/null | sort); do
    if ! head -20 "$f" | grep -qE 'Derived from:|ORIGINAL WORK'; then
        note "ATTRIBUTION $f has no provenance header (see docs/graphics/RFC-0001 D13)"
    fi
done

# ------------------------------------- 4/5. trailing whitespace and hard tabs
for f in $(find src tools lib -path 'lib/rt' -prune -o \( -name '*.bas' -o -name '*.bi' \) -print | sort); do
    # THE CR OF A CRLF FILE IS NOT TRAILING WHITESPACE. Git Bash grep treats
    # a CR-LF pair as the line terminator and never saw it; the WSL grep does
    # not, so every CRLF source in the tree read as a violation the moment
    # this script became runnable on Linux -- 160 of them. Strip the CR and
    # test what the line actually ends in.
    if tr -d '\r' < "$f" | grep -q '[[:space:]]$'; then
        note "WHITESPACE $f has trailing whitespace"
    fi
    # NOT 'grep -P'. Git Bash refuses it outright -- 'grep: -P supports only
    # unibyte and UTF-8 locales' -- and the 2>/dev/null that hid the message
    # hid the fact that this check had never once run on Windows. It found
    # two real violations the first time it did. A literal tab is portable.
    if grep -q "$(printf '\t')" "$f"; then
        note "TABS $f contains hard tabs"
    fi
done

if [ "$fails" -gt 0 ]; then
    echo "lint: $fails problem(s)" >&2
    exit 1
fi
echo "lint: ok"
exit 0
