#!/bin/sh
# lint.sh -- structural rules that a compiler cannot check for us.
#
#   build/lint.sh
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
#   5. TABS in source. fbx sources are space-indented.
#
# TODO: port to tools/fbx-lint once fbx can compile itself, so the lint is
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
        toolchain|driver) echo 5 ;;
        *) echo 9 ;;
    esac
}

for f in $(find src -name '*.bas' -o -name '*.bi' | sort); do
    dir=$(echo "$f" | cut -d/ -f2)
    [ "$dir" = "fbx.bi" ] && continue
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
for f in $(find src tools -name '*.bas' -o -name '*.bi' | sort); do
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
for f in $(find src tools -name '*.bas' -o -name '*.bi' | sort); do
    if grep -nqE 'for [A-Za-z_][A-Za-z0-9_]* as (ulong|uinteger|ulongint|ushort|ubyte) ' "$f"; then
        note "UNSIGNED LOOP $f uses an unsigned loop counter (see docs/internals/known-toolchain-issues.md)"
    fi
done

# ------------------------------------- 4/5. trailing whitespace and hard tabs
for f in $(find src tools -name '*.bas' -o -name '*.bi' | sort); do
    if grep -nq '[[:space:]]$' "$f"; then
        note "WHITESPACE $f has trailing whitespace"
    fi
    if grep -Pnq '\t' "$f" 2>/dev/null; then
        note "TABS $f contains hard tabs"
    fi
done

if [ "$fails" -gt 0 ]; then
    echo "lint: $fails problem(s)" >&2
    exit 1
fi
echo "lint: ok"
exit 0
