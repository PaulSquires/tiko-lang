#!/bin/sh
# test.sh -- tiko-rt's own tests.
#
#   build/test.sh [Debug|Release|RelWithDebInfo]
#
# Two kinds, and the distinction matters:
#
#   COMPILE-ONLY  runs for every target x threading combination, including the
#                 ones this host cannot execute. Catches layout, binding and
#                 codegen breakage on win32 and Linux from a Windows host --
#                 which is where it lives, because win64 is the target where
#                 every platform distinction collapses.
#
#   RUN           host target only. Behaviour, not shape.
#
# tests/abi/ and tests/bench/ have their own drivers (gate.sh, bench.sh).

set -e

. "$(dirname "$0")/common.sh"
rt_check_tools

CFG=${1:-Debug}
FLAGS=$(rt_cfg_flags "$CFG") || rt_die "unknown configuration '$CFG'"

WORK="$RT_ROOT/obj/test"
rm -rf "$WORK"; mkdir -p "$WORK"

pass=0
fail=0

report( ) {
    if [ "$1" = "ok" ]; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "test: FAIL $2" >&2
        [ -n "$3" ] && echo "$3" | sed 's/^/    /' >&2
    fi
}

# ------------------------------------------------------- compile-only tests

compile_only( ) {
    src=$1
    name=$(basename "$src" .bas)
    for target in $RT_TARGETS; do
        for mt in "" "-d ENABLE_MT"; do
            label="$name [$target${mt:+ +MT}]"
            out=$("$TKORT_FBC" -c "$src" -target "$target" -gen llvm \
                    $(rt_incflags) $FLAGS $mt \
                    -o "$WORK/$name-$target.o" 2>&1) || true
            if [ -z "$out" ]; then
                report ok "$label"
            else
                report no "$label" "$out"
            fi
        done
    done
}

for src in "$RT_ROOT"/tests/unit/*.bas; do
    [ -e "$src" ] || continue
    compile_only "$src"
done

# ------------------------------------------------------------- run tests
#
# None yet -- there is nothing to run until S2 defines fb_MemAlloc. When there
# is, they build for the host target only and execute here.

echo "test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
