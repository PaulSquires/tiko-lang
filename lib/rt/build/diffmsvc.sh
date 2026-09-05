#!/bin/sh
# diffmsvc.sh -- the differentials, run against the MICROSOFT ABI runtime.
#
#   build/diffmsvc.sh [Debug|Release|RelWithDebInfo]
#
# RFC-0006 §8 step 5: *"run check-str before anything else that looks like
# progress. The stdio swap is the change most likely to be silently wrong, and
# the only one that produces no diagnostic at all."*
#
# CHECK-STR IS THE WRONG INSTRUMENT FOR IT, and RFC-0006 §3.3 named it in good
# faith. tools/gen/check-str.sh compares tiko-lang's COMPILE-TIME float folding
# against fbc's STR( ) truth; it never links libfb and cannot see which printf a
# runtime calls. It is worth running -- it says 1483/1483 -- and it says nothing
# about this.
#
# THIS is the instrument. Every program in tests/abi/ is built twice and run:
#
#   reference   fbc, its own stock MinGW runtime, exactly as diff.sh's is
#   subject     the same source through fbc -gen llvm -r, retargeted to
#               x86_64-pc-windows-msvc, linked against lib/win64-msvc/libfb.a
#
# and the two outputs must be byte-identical. What that measures is the whole of
# the ABI change at once: UCRT against MinGW's stdio, __acrt_iob_func against
# __iob_func, _fseeki64 against fseeko, .CRT$XCU against .ctors, and every
# codegen difference the triple produces.
#
# WHY THE REFERENCE IS fbc AND NOT THE MinGW tiko-rt. The question here is not
# "do the two tiko-rt builds agree" -- abidelta.sh answers a version of that from
# the symbol tables. It is "does the MSVC build still behave like FreeBASIC",
# and fbc is the only thing that answers that. It is also the same reference
# diff.sh uses, so a failure here and a pass there localises to the ABI.
#
# /INCLUDE:tkort_msvc_init_ IS REQUIRED TOO, and for a subtler reason. An
# archive member is extracted only when it RESOLVES AN UNDEFINED SYMBOL, and
# nothing references a CRT initialiser -- the CRT walks a section, it does not
# call a name. So src/c/msvcinit.o sat in the archive and was never linked:
# measured, the locale stayed "C" with the object present. /INCLUDE: names it
# and is the supported way to pull one in.
#
# -llegacy_stdio_definitions IS REQUIRED and is not optional decoration: the
# UCRT does not export sprintf at all -- it is inline in the header -- so a
# non-C caller cannot link it without that library. Measured; RFC-0006 §12.
#
# ---------------------------------------------------------- KNOWN DIVERGENCES
#
# Three tests differ and none of them is an ABI defect. They are listed so that
# a FOURTH is visible immediately.
#
#   rnd-parity      2 lines   MSVCRT's printf is accurate to about fifteen
#   write-parity    1 line    significant digits and the UCRT's is exactly
#                             rounded, so past the fifteenth the MICROSOFT SIDE
#                             IS THE CORRECT ONE. All three values are dyadic
#                             rationals whose exact decimal expansion was
#                             computed; see src/inc/fmt.bi. No UCRT option bit
#                             makes it less accurate.
#
#   format-parity   2 values  NOT printf -- libm. FORMAT$ divides a value with
#                             more than 19 integer digits by pow( 10, n ) before
#                             rendering it, and the two pow implementations
#                             differ in the last bit: 1e20 * pow(10,-2) is
#                             1000000000000000000 on the UCRT and
#                             1000000000000000256 on MinGW. Measured. Fixing it
#                             means replacing fbc's algorithm, which is a rewrite
#                             dividend inside a parity measurement.
#
# WIN64 HOST ONLY. There is no MSVC ABI to compare against anywhere else.

set -e

. "$(dirname "$0")/common.sh"
rt_check_tools

CFG=${1:-Release}
rt_cfg_flags "$CFG" > /dev/null || rt_die "unknown configuration '$CFG'"

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) ;;
    *) rt_die "win64 host only -- there is no MSVC ABI to compare against here" ;;
esac

LIB="$RT_ROOT/lib/win64-msvc/libfb.a"
[ -f "$LIB" ] || rt_die "no archive at $LIB -- run build/build.sh $CFG win64-msvc first"

# THE PROBE PROGRAMS ARE BUILT UNOPTIMISED, ON BOTH SIDES. The archive keeps the
# configuration it was built with -- that is the thing under test -- but the
# tests/abi programs are the INSTRUMENT, and an instrument should not be the
# most complicated part of the measurement. At -O2 they go through fbc's LLVM
# backend miscompile described below, which zeroes the very input a test then
# converts, so utf-parity ended up comparing two heap buffers full of whatever
# had been there. Neither side was wrong about the ABI and neither agreed.
PROBE_OPT=0
WORK="$RT_ROOT/obj/diffmsvc"
rm -rf "$WORK"; mkdir -p "$WORK"

ident=0
differ=0
skip=0
bothnz=0

for src in $(ls "$RT_ROOT"/tests/abi/*.bas 2>/dev/null | sort); do
    name=$(basename "$src" .bas)

    # NEEDS-MT would have to link libfbmt.a and be built with -d ENABLE_MT on
    # both sides. Skipped rather than silently run against the wrong library,
    # which is the mistake diff.sh's own header records having made.
    if grep -q 'NEEDS-MT' "$src"; then
        skip=$((skip + 1))
        echo "diffmsvc: SKIP $name -- NEEDS-MT, not wired here yet" >&2
        continue
    fi

    ref="$WORK/$name-ref.exe"
    sub="$WORK/$name-msvc.exe"

    # THE SAME PER-TEST OPTIONS diff.sh READS, and for the same reasons. A first
    # version of this script passed none of them and skipped 22 of 114 as "does
    # not build against fbc's runtime" -- which was this harness failing, not a
    # finding, and it would have made the identical/differing split a ratio over a
    # biased subset. -l winspool and -l gdi32 are needed because io_printer draws
    # through both and this link names the whole archive.
    LANGOPT=""
    if grep -q 'NEEDS-LANG-FBLITE' "$src"; then LANGOPT="-lang fblite"; fi
    if grep -q 'NEEDS-LANG-QB' "$src"; then LANGOPT="-lang qb"; fi
    EXTRALIBS="-l winspool -l gdi32"

    # ---------------------------------------------------------- reference
    #
    # -gen llvm AND THE SAME -O AS THE SUBJECT, so the only thing that differs
    # between the two sides is THE TRIPLE. The first version of this script
    # built the reference with fbc's default backend and the subject through
    # -gen llvm -O2, which compares the ABI, the backend and the optimisation
    # level all at once -- and utf-parity duly "failed" on something that has
    # nothing to do with the ABI:
    #
    #     fbc -gen llvm -O0  (gnu)   41 C3 A9 E2 82 AC   correct
    #     fbc -gen llvm -O2  (gnu)   00 00 00 00 00 00   WRONG
    #     fbc -gen gas64 -O2         41 C3 A9 E2 82 AC   correct
    #
    # -- an fbc LLVM-backend miscompile at -O2, reproduced in six lines: a SUB
    # taking "u( ) as ubyte" and writing u( 0 ) does not write it. It is not
    # tiko-rt's and tiko-rt is not exposed to it (it declares no array
    # parameter anywhere), but a harness that hides it inside an "ABI"
    # differential is worse than one that does not run at all.
    if ! "$TKORT_FBC" "$src" -x "$ref" $(rt_incflags) $LANGOPT $EXTRALIBS \
            -gen llvm -O "$PROBE_OPT" > "$WORK/$name.reflog" 2>&1; then
        skip=$((skip + 1))
        echo "diffmsvc: SKIP $name -- does not build against fbc's runtime" >&2
        continue
    fi

    # ------------------------------------------------------------ subject
    #
    # -r stops fbc at the .ll and emits no object; clang is then given the
    # triple we want. The .ll is NOT edited -- clang's --target overrides the
    # module's own line, and the result is symbol-for-symbol identical to one
    # built from a rewritten file. RFC-0006 §12.
    ll="$WORK/$name.ll"
    obj="$WORK/$name.o"
    rm -f "$ll" "$obj"
    if ! "$TKORT_FBC" -c "$src" -m "$name" -target win64 -gen llvm -r \
            $(rt_incflags) $LANGOPT -o "$obj" > "$WORK/$name.sublog" 2>&1; then
        skip=$((skip + 1))
        echo "diffmsvc: SKIP $name -- does not compile for llvm" >&2
        continue
    fi
    [ -f "$ll" ] || { skip=$((skip + 1)); echo "diffmsvc: SKIP $name -- no .ll" >&2; continue; }

    if ! "$CLANG" --target=x86_64-pc-windows-msvc -march=x86-64 "-O$PROBE_OPT" \
            -Wno-override-module "$ll" -c -o "$obj" >> "$WORK/$name.sublog" 2>&1; then
        differ=$((differ + 1))
        echo "diffmsvc: FAIL $name -- does not assemble for msvc, see $WORK/$name.sublog" >&2
        continue
    fi

    if ! "$CLANG" --target=x86_64-pc-windows-msvc "$obj" "$LIB" -o "$sub" \
            -lwinspool -lgdi32 -luser32 -ladvapi32 -llegacy_stdio_definitions -Xlinker /INCLUDE:tkort_msvc_init_ \
            >> "$WORK/$name.sublog" 2>&1; then
        differ=$((differ + 1))
        echo "diffmsvc: FAIL $name -- does not LINK against the msvc runtime, see $WORK/$name.sublog" >&2
        continue
    fi

    # ---------------------------------------------------------------- run
    #
    # A non-zero exit on BOTH sides is agreement, not failure: errdie-parity
    # ends in a runtime error on purpose, and diff.sh reports it the same way.
    "$ref" > "$WORK/$name.refout" 2>&1 || rrc=$? ; rrc=${rrc:-0}
    "$sub" > "$WORK/$name.subout" 2>&1 || src_rc=$? ; src_rc=${src_rc:-0}

    if cmp -s "$WORK/$name.refout" "$WORK/$name.subout"; then
        if [ "$rrc" != "0" ] && [ "$src_rc" = "$rrc" ]; then
            bothnz=$((bothnz + 1))
            echo "diffmsvc: NOTE $name -- both sides exited non-zero (exit=$rrc)"
        fi
        ident=$((ident + 1))
    else
        differ=$((differ + 1))
        echo "diffmsvc: DIFFER $name" >&2
        diff "$WORK/$name.refout" "$WORK/$name.subout" 2>&1 | head -6 | sed 's/^/    /' >&2
    fi
    unset rrc src_rc
done

echo "diffmsvc: win64-msvc [$CFG] -- $ident identical, $differ differing, $skip skipped, $bothnz exited non-zero on BOTH sides"

# A SKIP IS A HARNESS FAILURE, not a neutral outcome -- diff.sh says so and the
# same applies here. A differing result is a real one and fails the run.
[ "$differ" = "0" ] || exit 1
