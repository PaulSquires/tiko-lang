#!/bin/sh
# bootstrap.sh -- the self-hosting fixpoint: tiko-lang compiles itself, twice.
#
#   build/bootstrap.sh [-O<n>] [--target <name>] [--stage1 <tiko>] [--gate]
#
# docs/plan/13 section 8 and D11, as one command. The Windows peer is
# build/bootstrap.bat and is kept line-for-line analogous.
#
#   stage0  FBC-Modern builds tiko-lang (build.sh Debug)       -> stage1
#   stage1  compiles tiko-lang's own sources                   -> stage2
#   stage2  compiles them again                                -> stage3
#
# and asserts, in this order:
#
#   1. stage1 LOWERS EVERY STATEMENT of every module, and every module verifies. A
#      build reports no decline, so a statement tiko gives up on vanishes from the
#      compiler it is building and nothing says so. That is not hypothetical:
#      'Tko.TKO_VERSION_SUFFIX' in cmdline.bas declined twice, and the self-built
#      compiler's --version lost its suffix and its whole target line.
#   2. stage2 AND stage3 ARE BYTE-IDENTICAL FILES. Nothing is zeroed and nothing is
#      masked: the link is reproducible (HANDOFF 8m). stage1 is NOT compared -- a
#      different compiler built it, and it may legitimately differ.
#   3. stage3 COMPILES A PROGRAM AND IT PRINTS WHAT stage0's BUILD OF IT PRINTS.
#   4. With --gate, THE SUITE AGAINST stage2 FAILS EXACTLY WHAT IT FAILS AGAINST
#      stage1. A fixpoint says the compiler reproduces itself; it says nothing about
#      code tiko-lang's own source never exercises. The suite does: a paren-less
#      'cast( ulong, flds.Count )' passed byref gave every threadcall descriptor a
#      CODE ADDRESS for its field count, in stage2 and stage3 alike, and only the
#      suite run against stage2 could see it. "The same failures" rather than "none",
#      because a worktree has an environmental one or two (see HANDOFF).
#
# -O<n> is passed to the stage1 and stage2 compiles of tiko-lang; Phase 10's
# criterion is the fixpoint at -O0 AND -O2. --stage1 skips the stage0 build and
# uses the given compiler. --target defaults to the host's default target.
#
# Headers: the stage0 toolchain's own set, which is what stage0 compiled against --
# <stage0 dir>/inc on Windows, <prefix>/include/freebasic elsewhere -- or
# TKO_BOOT_INC. Libraries: per target below, or TKO_BOOT_LIBDIRS (space-separated).
# TKO_LIBPATH and TKO_INCLUDE from the caller are NOT inherited: a variable exported
# for some earlier probe would otherwise decide what this links (see Learnings).
#
# Everything lands in build/.bootstrap/, which is cleared first: a stage binary
# left by an earlier run would compare equal to itself and prove nothing.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOSTWIN=1; EXT=".exe" ;;
    *)                    HOSTWIN=0; EXT="" ;;
esac

OPT=""
TARGET=""
STAGE1=""
GATE=0
while [ $# -gt 0 ]; do
    case "$1" in
        -O[0-3])  OPT="$1" ;;
        --target) shift; TARGET="$1" ;;
        --stage1) shift; STAGE1="$1" ;;
        --gate)   GATE=1 ;;
        *) echo "bootstrap: unknown argument '$1'" >&2; exit 2 ;;
    esac
    shift
done

if [ -z "$TKO_STAGE0" ]; then
    if [ "$HOSTWIN" = "1" ]; then
        TKO_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe"
    else
        TKO_STAGE0="/c/dev/fbc-modern/toolchains/fbc-modern-linux/bin/fbc"
    fi
fi
export TKO_STAGE0

if [ -z "$TKO_BOOT_INC" ]; then
    if [ "$HOSTWIN" = "1" ]; then
        TKO_BOOT_INC="$(dirname "$TKO_STAGE0")/inc"
    else
        TKO_BOOT_INC="$(dirname "$(dirname "$TKO_STAGE0")")/include/freebasic"
    fi
fi
[ -d "$TKO_BOOT_INC" ] || { echo "bootstrap: no header directory $TKO_BOOT_INC (set TKO_BOOT_INC)" >&2; exit 3; }

if [ -z "$TARGET" ]; then
    if [ "$HOSTWIN" = "1" ]; then TARGET="win64-msvc"; else TARGET="linux-x86_64"; fi
fi
if [ -z "$TKO_BOOT_LIBDIRS" ]; then
    case "$TARGET" in
        win64-msvc)   TKO_BOOT_LIBDIRS="$ROOT/toolchains/tiko-windows/lib/win64-msvc" ;;
        # MinGW needs fbc's CRT objects beside the runtime; see cmdline.bas.
        win64)        TKO_BOOT_LIBDIRS="$ROOT/toolchains/tiko-windows/lib/win64 $ROOT/toolchains/tiko-windows/lib/win64-fb" ;;
        linux-x86_64) TKO_BOOT_LIBDIRS="$ROOT/lib/rt/lib/linux-x86_64" ;;
        *) echo "bootstrap: unknown target '$TARGET'" >&2; exit 2 ;;
    esac
fi
LIBP=""
for d in $TKO_BOOT_LIBDIRS; do
    [ -d "$d" ] || { echo "bootstrap: no library directory $d (set TKO_BOOT_LIBDIRS)" >&2; exit 3; }
    LIBP="$LIBP -p $d"
done

unset TKO_LIBPATH
TKO_INCLUDE="$TKO_BOOT_INC"
export TKO_INCLUDE

SOURCES=$(grep -v '^[[:space:]]*#' build/sources.txt | grep -v '^[[:space:]]*$')
NMOD=$(echo "$SOURCES" | wc -l | tr -d ' ')
MAINMOD=$(basename "$(echo "$SOURCES" | head -1)" .bas)

OUT="$ROOT/build/.bootstrap"
rm -rf "$OUT"
mkdir -p "$OUT/stage1" "$OUT/stage2" "$OUT/stage3" "$OUT/hello"

now( ) { date +%s; }
say( ) { echo "bootstrap: $*"; }
fail( ) { echo "bootstrap: FAILED -- $*" >&2; exit 1; }
size_of( ) { wc -c < "$1" | tr -d ' '; }

say "target $TARGET ${OPT:--O0}, $NMOD modules, headers $TKO_BOOT_INC"

# ------------------------------------------------------------------ stage1
t0=$(now)
if [ -n "$STAGE1" ]; then
    [ -x "$STAGE1" ] || fail "no stage1 compiler at $STAGE1"
    cp "$STAGE1" "$OUT/stage1/tiko$EXT"
    say "stage1  $STAGE1"
else
    if [ "$GATE" = "1" ]; then
        sh build/build.sh Debug --test-runner --no-dll > "$OUT/stage1.log" 2>&1 || { cat "$OUT/stage1.log" >&2; fail "stage0 could not build stage1"; }
    else
        sh build/build.sh Debug --no-dll > "$OUT/stage1.log" 2>&1 || { cat "$OUT/stage1.log" >&2; fail "stage0 could not build stage1"; }
    fi
    cp "bin/tiko$EXT" "$OUT/stage1/tiko$EXT"
    say "stage1  built by $(basename "$TKO_STAGE0") in $(( $(now) - t0 )) s"
fi
S1="$OUT/stage1/tiko$EXT"

# -------------------------------------------- 1. every statement lowers
# One invocation over every module: 92 processes would re-read the shared headers
# 92 times. Only the summary lines are kept; the IR itself is tens of megabytes.
"$S1" --dump-ir -target "$TARGET" -i src $SOURCES 2>&1 | grep -E '^(lowered|verify):' > "$OUT/lowered.txt" || true
NLOW=$(grep -c '^lowered:' "$OUT/lowered.txt" || true)
NVER=$(grep -c '^verify: ok' "$OUT/lowered.txt" || true)
NDEC=$(grep '^lowered:' "$OUT/lowered.txt" | grep -vc ' 0 statements not lowered' || true)
[ "$NLOW" = "$NMOD" ] || fail "--dump-ir reported $NLOW modules of $NMOD (see $OUT/lowered.txt)"
[ "$NVER" = "$NMOD" ] || fail "$(( NMOD - NVER )) modules did not verify (see $OUT/lowered.txt)"
[ "$NDEC" = "0" ]     || fail "$NDEC modules have statements stage1 does not lower (see $OUT/lowered.txt)"
say "stage1  lowers every statement of all $NMOD modules; all verify"

# ------------------------------------------------------------ stage2, stage3
build_stage( ) {
    # $1 = the compiler, $2 = the stage it builds
    ts=$(now)
    "$1" $SOURCES -m "$MAINMOD" -i src -target "$TARGET" $OPT $LIBP -o "$OUT/$2/tiko$EXT" \
        > "$OUT/$2.log" 2>&1 || { cat "$OUT/$2.log" >&2; fail "$2 did not build"; }
    [ -f "$OUT/$2/tiko$EXT" ] || fail "$2 reported success and wrote no compiler"
    # A build that says nothing is the only acceptable one: a warning in the
    # compiler's own source is either real or a divergence from what stage0 said.
    if [ -s "$OUT/$2.log" ]; then
        cat "$OUT/$2.log" >&2
        fail "$2's build printed diagnostics"
    fi
    say "$2  built by $(basename "$(dirname "$1")") in $(( $(now) - ts )) s, $(size_of "$OUT/$2/tiko$EXT") bytes"
}
build_stage "$S1" stage2
build_stage "$OUT/stage2/tiko$EXT" stage3

# ------------------------------------------------------------- 2. fixpoint
cmp -s "$OUT/stage2/tiko$EXT" "$OUT/stage3/tiko$EXT" || fail "stage2 and stage3 differ"
if command -v sha256sum > /dev/null 2>&1; then
    say "fixpoint  stage2 == stage3, sha256 $(sha256sum "$OUT/stage3/tiko$EXT" | cut -c1-16)..."
else
    say "fixpoint  stage2 == stage3"
fi

# ------------------------------------------ 3. stage3 builds a working program
cat > "$OUT/hello/hello.bas" <<'EOF'
namespace Boot
    const WHO as string = "stage3"
end namespace
function Twice( byval n as long ) as long
    return n * 2
end function
dim as string s = "hello from " & Boot.WHO
print s; Twice( 21 ); " "; len( s )
EOF
"$OUT/stage3/tiko$EXT" "$OUT/hello/hello.bas" -target "$TARGET" $LIBP -o "$OUT/hello/hello3$EXT" \
    > "$OUT/hello/build3.log" 2>&1 || { cat "$OUT/hello/build3.log" >&2; fail "stage3 could not build hello.bas"; }
"$OUT/hello/hello3$EXT" > "$OUT/hello/out3.txt" 2>&1 || fail "stage3's hello did not run"
( cd "$OUT/hello" && "$TKO_STAGE0" hello.bas -x "hello0$EXT" > build0.log 2>&1 ) || fail "stage0 could not build hello.bas"
"$OUT/hello/hello0$EXT" > "$OUT/hello/out0.txt" 2>&1 || fail "stage0's hello did not run"
cmp -s "$OUT/hello/out0.txt" "$OUT/hello/out3.txt" || fail "stage3's hello prints '$(cat "$OUT/hello/out3.txt")', stage0's '$(cat "$OUT/hello/out0.txt")'"
say "stage3  builds hello.bas, and it prints what stage0's build prints"

# ------------------------------------------------- 4. the suite, both ways
if [ "$GATE" = "1" ]; then
    [ -x "bin/tiko-test$EXT" ] || fail "--gate needs bin/tiko-test$EXT (build.sh Debug --test-runner)"
    unset TKO_INCLUDE
    sh build/test.sh --no-build --tiko-lang "$S1" > "$OUT/gate1.log" 2>&1 || true
    sh build/test.sh --no-build --tiko-lang "$OUT/stage2/tiko$EXT" > "$OUT/gate2.log" 2>&1 || true
    grep '^FAIL ' "$OUT/gate1.log" | sort > "$OUT/fail1.txt" || true
    grep '^FAIL ' "$OUT/gate2.log" | sort > "$OUT/fail2.txt" || true
    SUM1=$(grep '^tiko-test' "$OUT/gate1.log" | tail -1)
    SUM2=$(grep '^tiko-test' "$OUT/gate2.log" | tail -1)
    [ -n "$SUM1" ] && [ -n "$SUM2" ] || fail "the suite did not report a result (see $OUT/gate1.log, gate2.log)"
    say "suite   stage1: ${SUM1#*: }"
    say "suite   stage2: ${SUM2#*: }"
    if ! cmp -s "$OUT/fail1.txt" "$OUT/fail2.txt"; then
        diff "$OUT/fail1.txt" "$OUT/fail2.txt" >&2 || true
        fail "the suite fails differently against stage2 than against stage1"
    fi
    say "suite   stage2 fails exactly what stage1 fails"
fi

say "ok"
