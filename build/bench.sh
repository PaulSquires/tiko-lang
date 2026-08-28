#!/bin/sh
# bench.sh -- C libfb vs FreeBASIC libfb, which is the whole question.
#
#   build/bench.sh [target] [runs]
#
#   build/bench.sh win64 7
#
# This is Gate 4 of docs/tiko-rt/RFC-0004 section 4.
#
# GATE:  <=5% geomean regression, and no single benchmark worse than 20%.
#
# WHAT MAKES THE COMPARISON VALID
#
# Both binaries are built by the SAME compiler with the SAME flags and the SAME
# backend. The only difference is which libfb.a the linker finds, which -p
# decides. If anything else differs, the number measures that instead.
#
# Each benchmark times itself internally and prints "<name> <seconds>", so
# process startup is outside the measurement. Runs are repeated and the MEDIAN
# is taken -- not the mean, which one scheduling hiccup can move, and not the
# minimum, which hides variance that matters.
#
# IMPROVEMENTS ARE REPORTED BUT EXCLUDED FROM THE GEOMEAN. A rewrite can beat
# the original in places -- the temp-descriptor free list and str_concat's
# allocation strategy are both improvable -- but that is a rewrite dividend, not
# a language dividend, and averaging it in would make the number measure the
# wrong thing.
#
# DO NOT RUN THIS CONCURRENTLY WITH ANYTHING. A 5% budget is smaller than the
# noise from a competing build.

set -eu

. "$(dirname "$0")/common.sh"
rt_check_tools

TARGET=${1:-win64}
RUNS=${2:-5}
rt_is_target "$TARGET" || rt_die "unsupported target '$TARGET'"

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOST=win64; EXT=".exe" ;;
    *)                    HOST=linux-x86_64; EXT="" ;;
esac
[ "$TARGET" = "$HOST" ] || rt_die "bench must run natively; host is $HOST, asked for $TARGET"

GATE_FBC=${GATE_FBC:-"$FBC_TREE/src/fbc.exe"}
[ -x "$GATE_FBC" ] || rt_die "compiler not found at $GATE_FBC"

CLIB="$FBC_TREE/src/lib/$TARGET"
FLIB="$RT_ROOT/obj/gate/$TARGET/lib"
[ -f "$FLIB/libfb.a" ] || rt_die "no merged tiko-rt runtime at $FLIB -- run build/gate.sh first"

WORK="$RT_ROOT/obj/bench/$TARGET"
rm -rf "$WORK"; mkdir -p "$WORK"

benches=$(find "$RT_ROOT/tests/bench" -name '*.bas' 2>/dev/null | sort)
[ -n "$benches" ] || rt_die "no benchmarks in tests/bench"

# ------------------------------------------------------------------ build

for src in $benches; do
    name=$(basename "$src" .bas)
    for which in c fb; do
        case $which in c) libp="$CLIB" ;; fb) libp="$FLIB" ;; esac
        "$GATE_FBC" "$src" -i "$FBC_TREE/src/inc" -gen gcc -O 2 \
            -p "$libp" -x "$WORK/$name-$which$EXT" \
            > "$WORK/$name-$which.buildlog" 2>&1 \
            || rt_die "benchmark $name failed to build against the $which runtime; see $WORK/$name-$which.buildlog"
    done
done

# ------------------------------------------------------------------- run

median( ) { tr ' ' '\n' | sort -g | awk '{v[NR]=$1} END{ print (NR%2) ? v[(NR+1)/2] : (v[NR/2]+v[NR/2+1])/2 }'; }

printf '%-28s %12s %12s %9s\n' benchmark "C (s)" "FB (s)" ratio
printf '%-28s %12s %12s %9s\n' "----------------------------" "------------" "------------" "---------"

: > "$WORK/ratios.txt"
worst=1.0
worstname="-"

for src in $benches; do
    name=$(basename "$src" .bas)
    for which in c fb; do
        acc=""
        i=0
        while [ "$i" -lt "$RUNS" ]; do
            t=$("$WORK/$name-$which$EXT" | awk '{print $NF}')
            acc="$acc $t"
            i=$((i + 1))
        done
        eval "t_$which=\$(echo \"\$acc\" | median)"
    done

    ratio=$(awk -v c="$t_c" -v f="$t_fb" 'BEGIN{ printf "%.4f", (c>0)? f/c : 0 }')
    printf '%-28s %12.6f %12.6f %8.2fx\n' "$name" "$t_c" "$t_fb" "$ratio"
    echo "$name $ratio" >> "$WORK/ratios.txt"
    worse=$(awk -v r="$ratio" -v w="$worst" 'BEGIN{ print (r>w) ? 1 : 0 }')
    if [ "$worse" = "1" ]; then worst=$ratio; worstname=$name; fi
done

# -------------------------------------------------------------- the verdict

awk -v worst="$worst" -v worstname="$worstname" '
    { r = $2; if (r > 1.0) { s += log(r); n++ } }   # regressions only
    END {
        geo = (n > 0) ? exp(s / n) : 1.0
        printf "\ngeomean of regressions: %.4fx over %d of the benchmarks\n", geo, n
        printf "worst single:           %.4fx (%s)\n", worst, worstname
        ok = 1
        if (geo > 1.05)  { printf "FAIL geomean %.2f%% > 5%% budget\n", (geo-1)*100; ok = 0 }
        if (worst > 1.20){ printf "FAIL %s %.2f%% > 20%% single-benchmark budget\n", worstname, (worst-1)*100; ok = 0 }
        if (ok) print "PASS within budget (RFC-0004 R5)"
        exit (ok ? 0 : 1)
    }
' "$WORK/ratios.txt"
