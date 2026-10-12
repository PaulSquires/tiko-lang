#!/bin/sh
# difflane.sh -- the executed differential lane: generated programs, fbc vs tiko.
#
#   build/difflane.sh [first-seed] [count]          default: 1 200
#
# tools/difflane/dgen.py writes a deterministic, DEFINED program per seed -- every
# integer width and signedness, mixed-width arithmetic, shifts, '\', mod, comparisons,
# int<->float conversions, the c* casts, bit operations, iif, nested calls with byval
# and byref arguments, local arrays, string building -- printing one labelled line per
# statement. Each is built with fbc (the stage0, FBC-Modern) and with bin/tiko at -O0
# and -O2, all three are RUN, and their output and exit codes must agree.
#
# WHY: the suite compares tiko with itself (goldens) or with what someone measured once.
# Literal typing (F-15), SELECT promotion (F-23) and the -O2 shift folding (F-43) all
# passed it, and a few hundred seeds found each of them (audit, Phase 3 item 2).
#
# Windows only for now: the stage0 there is the reference this tree is measured against.
# Prints MATCH/FIND per seed and a summary; exits 1 if anything differed. A FIND keeps
# its files under build/.difflane/ -- the program, both outputs, both build logs.

ROOT=$(cd "$(dirname "$0")/.." && pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;;
    *) echo "difflane: Windows only for now" >&2; exit 3 ;;
esac
FBC=${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
TKO="$ROOT/bin/tiko$EXT"
[ -x "$FBC" ] || { echo "difflane: SKIPPED -- no oracle fbc at $FBC (TKO_ORACLE_FBC)"; exit 0; }
[ -x "$TKO" ] || { echo "difflane: build tiko first (build/build.sh)" >&2; exit 3; }
PY=$(command -v python || command -v python3)
[ -n "$PY" ] || { echo "difflane: needs python" >&2; exit 3; }

export TKO_LIBPATH=${TKO_LIBPATH:-$ROOT/toolchains/tiko-windows/lib/windows-x86_64}
first=${1:-1}
count=${2:-200}
W="$ROOT/build/.difflane"
mkdir -p "$W"
cd "$W" || exit 3

found=0
matched=0
i=$first
last=$((first + count - 1))
while [ $i -le $last ]; do
    "$PY" "$ROOT/tools/difflane/dgen.py" $i p$i.bas
    if ! "$FBC" p$i.bas -x f$i$EXT > f$i.log 2>&1; then
        echo "SKIP $i: fbc refused it ($(grep -m1 -i error f$i.log))"
        i=$((i + 1)); continue
    fi
    res=""
    for O in 0 2; do
        "$TKO" -O$O p$i.bas -o t${O}_$i$EXT > t${O}_$i.log 2>&1 || res="$res TIKO-BUILD-O$O"
    done
    timeout 20 ./f$i$EXT < /dev/null > f$i.txt 2>&1; fr=$?
    for O in 0 2; do
        [ -f t${O}_$i$EXT ] || continue
        timeout 20 ./t${O}_$i$EXT < /dev/null > t${O}_$i.txt 2>&1; tr=$?
        [ $tr -eq $fr ] || res="$res EXIT-O$O($fr/$tr)"
        cmp -s f$i.txt t${O}_$i.txt || res="$res DIFF-O$O"
    done
    if [ -z "$res" ]; then
        matched=$((matched + 1))
        rm -f p$i.bas f$i$EXT f$i.txt f$i.log t0_$i$EXT t2_$i$EXT t0_$i.txt t2_$i.txt t0_$i.log t2_$i.log
    else
        found=$((found + 1))
        echo "FIND $i:$res"
    fi
    i=$((i + 1))
done
rm -f *.o *.obj 2>/dev/null
echo "difflane: $matched matched, $found differed, seeds $first..$last"
[ $found -eq 0 ]
