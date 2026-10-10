#!/bin/sh
# parse-gap.sh -- the REAL parser-quality metric: corpus files that fbc ACCEPTS and tiko-lang
# reports a diagnostic on.
#
# The raw count is misleading in BOTH directions, and each has cost a wrong conclusion.
#
# Counting tiko-lang's error NODES alone: the corpus is fbc's own test suite and is full of
# files fbc itself rejects -- deliberately invalid input and machine-generated syntax
# torture. Measured 2026-08-18: of 11,719 error nodes, 11,613 (99.1%) were in files fbc
# also rejects.
#
# Counting FILES THAT REPORT A DIAGNOSTIC, which is what mirsweep prints: measured
# 2026-08-20, of 390 such files, 152 are ones fbc rejects too. Those are agreements
# wearing the costume of failures.
#
# So this script asks the only question that means anything -- fbc clean AND tiko-lang not --
# and splits what is left into the part that is deliberate and the part that is work.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

# fbc-modern, the same toolchain every other gate measures against. TKO_FBC overrides.
FBC=${TKO_FBC:-${TKO_ORACLE_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}}
[ -x "$FBC" ] || { echo "parse-gap: SKIPPED -- no oracle fbc at $FBC (TKO_ORACLE_FBC)"; exit 0; }
CORPUS=tests/vendor/fbc-tests
[ -d "$CORPUS" ] || { echo "parse-gap: corpus not vendored" >&2; exit 3; }

# The corpus's own test framework lives in a subdirectory the files do not name; a
# quarter of them include it. Both compilers get the same path, or the comparison is
# between one that can read the harness and one that cannot.
FBCUNIT=""
if [ -d "$CORPUS/fbcunit/inc" ]; then
    FBCUNIT="-i $CORPUS/fbcunit/inc"
fi

# tiko-lang ships no headers, so its default include directory does not exist in a source tree.
# Without a header set 144 files fail at their first line and this comparison measures
# that instead of the parser. Same harness fact as mirsweep's.
TKOINC=${TKO_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$TKOINC" ]; then
    TKO_INCLUDE="$TKOINC"
    export TKO_INCLUDE
else
    echo "parse-gap: no runtime headers at $TKOINC -- 144 files will fail on #include" >&2
fi

find "$CORPUS" -name '*.bas' | sort > build/.corpus.lst
mkdir -p build/.rt
: > build/.parsegap.out
: > build/.parsegap.lang

dirty=0
agree=0
lang=0
while IFS= read -r f; do
    msg=$(./bin/tiko.exe --dump-ir $FBCUNIT "$f" 2>&1 | grep -m1 -E ': (error|fatal) TKO' || true)
    [ -n "$msg" ] || continue
    dirty=$((dirty + 1))
    e=$("$FBC" -c $FBCUNIT "$f" -o build/.rt/pg.o 2>&1 | grep -c 'error [0-9]' || true)
    if [ "$e" != "0" ]; then
        # fbc rejects it too. tiko-lang and fbc agree on the outcome, whatever the wording.
        agree=$((agree + 1))
        continue
    fi
    case "$msg" in
        *"unsupported language mode"*)
            # '#lang "qb"' and '"fblite"'. tiko-lang implements "fb" only, ON PURPOSE, and
            # every one of these files has an '-fb' sibling testing the same construct.
            lang=$((lang + 1))
            echo "$f" >> build/.parsegap.lang
            ;;
        *)
            echo "$msg" >> build/.parsegap.out
            ;;
    esac
done < build/.corpus.lst

gaps=$(grep -c . build/.parsegap.out || true)

# The three buckets must ACCOUNT FOR the total, or something wrote into the output that
# this run did not put there. That is not hypothetical: a previous invocation killed on a
# timeout kept running and kept appending, and the next run reported 207 real gaps where
# 172 were found -- a believable number, over by exactly the orphan's contribution.
if [ $((agree + lang + gaps)) -ne "$dirty" ]; then
    echo "parse-gap: INCONSISTENT -- $agree + $lang + $gaps <> $dirty." >&2
    echo "parse-gap: another process is probably writing build/.parsegap.out." >&2
    exit 4
fi

echo "parse-gap: $dirty files report a diagnostic"
echo "parse-gap:   $agree  fbc rejects them too -- an AGREEMENT, not a gap"
echo "parse-gap:   $lang  '#lang' other than \"fb\" -- deliberate"
echo "parse-gap:   $gaps  REAL GAPS: fbc accepts, tiko-lang does not"
echo "parse-gap: by first diagnostic ->"
sed -E "s/.*(error|fatal) TKO[0-9]+: //; s/'[^']*'/'X'/g; s/[0-9]+/N/g" build/.parsegap.out \
    | sort | uniq -c | sort -rn | head -10 | sed 's/^/parse-gap:   /'
