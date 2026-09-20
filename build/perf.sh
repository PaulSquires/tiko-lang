#!/bin/sh
# perf.sh -- one number beside every budget in docs/plan/14-engineering-standards.md §4.
#
# WHY THIS EXISTS. The budgets were written so they could be missed VISIBLY, and for
# three phases nothing measured them: seven rows, no numbers. Phase 14 owes "a script
# that measures section 4's table over the corpus and the self-compile". This is it.
#
# TWO DENOMINATORS, BOTH PRINTED. 'input' is what the user handed the compiler -- the
# corpus files themselves, 5.46 MB. 'processed' is every byte its units read between
# them: their own text PLUS the headers each includes PLUS the virtual files the
# preprocessor makes for macro expansion, 157 MB. One 3,696-byte corpus file reads
# 48,640. Throughput against 'input' is what a user feels; against 'processed' is the
# work done, and that is what the budgets are written against. See section 2 + 3 for
# what measuring the wrong one cost.
#
# TIMING IS THE COMPILER'S OWN. --time-passes reports 'lex', 'parse' and 'front', all
# of which exclude process start-up; only the self-compile's frontend and the fbc
# comparison are wall-clocked, and the start-up is measured and subtracted there.
#
# CHUNKS, FOR THE LEXER ONLY. 2,709 paths do not fit in one Windows command line
# (32,767 characters), so --lex-only is handed the corpus 300 files at a time. Parse
# and frontend are one file per invocation, which is what a build does.
set -e

cd "$(dirname "$0")/.."

CORPUS_ROOT=tests/vendor/fbc-tests
[ -d "$CORPUS_ROOT" ] || { echo "perf: corpus not vendored" >&2; exit 3; }

TIKO=./bin/tiko
[ -x ./bin/tiko.exe ] && TIKO=./bin/tiko.exe
[ -x "$TIKO" ] || { echo "perf: build bin/tiko first" >&2; exit 3; }

FBCUNIT=""
[ -d "$CORPUS_ROOT/fbcunit/inc" ] && FBCUNIT="-i $CORPUS_ROOT/fbcunit/inc"

# The headers the corpus expects -- fbgfx.bi and the rest. icescan.sh does the same.
TKOINC=${TKO_INCLUDE:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc}
if [ -d "$TKOINC" ]; then TKO_INCLUDE="$TKOINC"; export TKO_INCLUDE; fi

# THE DEV TREE HAS NO lib/<target>: the import libraries are a package step, not a build
# one, so a link from bin/ needs the packaged toolchain's copy pointed at explicitly.
LIBP=""
[ -d toolchains/tiko-windows/lib/win64-msvc ] && LIBP="-p toolchains/tiko-windows/lib/win64-msvc"

FBC=${TKO_FBC:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}

WORK=build/.perf
rm -rf "$WORK" 2>/dev/null || true
mkdir -p "$WORK"

find "$CORPUS_ROOT" -name '*.bas' | sort > "$WORK/corpus.lst"
split -l 300 "$WORK/corpus.lst" "$WORK/chunk_"
FILES=$(wc -l < "$WORK/corpus.lst")
INPUT=$(find "$CORPUS_ROOT" -name '*.bas' -printf '%s\n' | awk '{s+=$1} END {print s}')

now_ms( ) { date +%s%3N ; }

# Peak working set of one run, in bytes. Windows answers through psapi (see
# build/peakws.ps1, and the reason a .NET property will not do); elsewhere GNU time
# reports it in kilobytes.
peak_rss( ) {
    printf '%s\n' "$@" > "$WORK/args.txt"
    case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        powershell -NoProfile -ExecutionPolicy Bypass -File build/peakws.ps1 \
            -Exe "$(pwd -W 2>/dev/null || pwd)/${TIKO#./}" -ArgsFile "$WORK/args.txt" \
            | tr -d '\r' | tail -1
        ;;
    *)
        /usr/bin/time -f '%M' "$TIKO" "$@" > /dev/null 2> "$WORK/time.txt" || true
        awk 'END {print $1 * 1024}' "$WORK/time.txt"
        ;;
    esac
}

# WHICH BINARY, SAID OUT LOUD. build/test.sh ends by rebuilding DEBUG, so a gate run
# leaves a Debug tiko in bin/ -- and a Debug binary produces this whole table with no
# error anywhere, about four times slow. It was measured and believed twice before the
# 50 MB file size gave it away: the lexer at 11 MB/s against 79, and passes that had
# not been touched all moving together. The size is the tell, so the size is the guard.
TIKOBYTES=$(wc -c < "$TIKO")
TIKOWHEN=$(date -r "$TIKO" '+%Y-%m-%d %H:%M' 2>/dev/null || echo unknown)
echo "perf: $TIKO is $TIKOBYTES bytes, built $TIKOWHEN"
if [ "$TIKOBYTES" -gt 8000000 ] && [ -z "$PERF_ALLOW_DEBUG" ] ; then
    echo "perf: that is a Debug build -- run 'bash build/build.sh Release' first," >&2
    echo "      or set PERF_ALLOW_DEBUG=1 to measure it anyway." >&2
    exit 3
fi

echo "perf: $FILES corpus files, $INPUT bytes of input -- this takes a few minutes"

# ---------------------------------------------------------------- start-up cost
# Subtracted from every wall-clocked figure below: one process creation plus the
# compiler's fixed set-up. At ~45 ms over ten chunks it is not noise.
s=$( now_ms )
i=0
while [ $i -lt 10 ]; do "$TIKO" --version > /dev/null 2>&1; i=$(( i + 1 )); done
e=$( now_ms )
STARTUP=$(( ( e - s ) / 10 ))
echo "perf: start-up ${STARTUP} ms per invocation"

# ---------------------------------------------------------------- 1. lexer
for c in "$WORK"/chunk_*; do
    "$TIKO" --lex-only --time-passes $(cat "$c") 2>&1 || true
done > "$WORK/lex.out"
LEX_S=$(awk '/^  lex /{s+=$2} END {printf "%.3f", s}' "$WORK/lex.out")
LEX_B=$(awk '/^lexed /{s+=$4} END {print s}' "$WORK/lex.out")
LEX_T=$(awk '/^lexed /{s+=$6} END {print s}' "$WORK/lex.out")

# ------------------------------------------------- 2 + 3. parse, AST and frontend
# ONE FILE PER INVOCATION, WHICH IS WHAT A BUILD DOES -- and what the denominator has
# to match. Handing 300 files to one process, as this script used to, loads each shared
# header ONCE and counts its bytes once, while the parser still parses those tokens in
# every unit that included them. chunk_aa reports 13.8 MB read in a batch and its 300
# units process 68.8 MB between them; the same files then measure 4.7 MB/s batched and
# 17.56 MB/s one at a time. The second is the compiler's throughput; the first was an
# artefact of the chunking, which exists only because 2,709 paths do not fit on a
# Windows command line.
#
# The compiler's OWN timers are summed -- 'parse' and 'front' -- so process start-up is
# excluded. It has to be: over 2,709 invocations start-up is about two minutes, which is
# larger than the work being measured.
: > "$WORK/parse.out"
: > "$WORK/check.out"
while read -r f ; do
    "$TIKO" --parse-only --stats --time-passes $FBCUNIT "$f" >> "$WORK/parse.out" 2>&1 || true
    "$TIKO" --check --stats --time-passes -fmax-errors 100000 $FBCUNIT "$f" >> "$WORK/check.out" 2>&1 || true
done < "$WORK/corpus.lst"

PAR_S=$(awk '/^  parse /{s+=$2} END {printf "%.3f", s}' "$WORK/parse.out")
PAR_R=$(awk '/^source bytes/{s+=$3} END {print s}' "$WORK/parse.out")
AST_B=$(awk '/^  ast /{s+=$2} END {print s}' "$WORK/parse.out")
AST_T=$(awk '/^  ast /{s+=$4} END {print s}' "$WORK/parse.out")
FE_S=$(awk '/^  front /{s+=$2} END {printf "%.3f", s}' "$WORK/check.out")
FE_ERRS=$(awk '/^errors/{s+=$2} END {print s+0}' "$WORK/check.out")

# ---------------------------------------------------------------- 4. self-compile
SELF=$(cat build/sources.txt)
SELF_N=$(wc -l < build/sources.txt)
SELF_B=$(xargs -a build/sources.txt ls -l | awk '{s+=$5} END {print s}')
"$TIKO" --parse-only --stats --time-passes -i src $SELF > "$WORK/self.out" 2>&1 || true
SELF_PAR=$(awk '/^  parse /{print $2}' "$WORK/self.out")
SELF_READ=$(awk '/^source bytes/{print $3}' "$WORK/self.out")
SELF_AST_B=$(awk '/^  ast /{print $2}' "$WORK/self.out")
SELF_AST_T=$(awk '/^  ast /{print $4}' "$WORK/self.out")
s=$( now_ms )
"$TIKO" --check -i src $SELF > /dev/null 2>&1 || true
e=$( now_ms )
SELF_FE=$(( e - s - STARTUP ))

# ---------------------------------------------------------------- 5. peak RSS
# THE RATIO IS NOT ONE NUMBER. A single small file is dominated by the compiler's own
# floor, so the floor is printed beside every figure and the ratio is given both ways:
# against the bytes read, and against the bytes read ABOVE the floor -- the marginal
# cost, which is what the budget is really about.
RSS_FLOOR=$( peak_rss --version )
BIG=$(find "$CORPUS_ROOT" -name '*.bas' -printf '%s %p\n' | sort -rn | head -1 | awk '{print $2}')
"$TIKO" --check --stats $FBCUNIT "$BIG" > "$WORK/big.out" 2>&1 || true
BIG_READ=$(awk '/^source bytes/{print $3}' "$WORK/big.out")
BIG_RSS=$( peak_rss --check --stats $FBCUNIT "$BIG" )
LAST=$(ls "$WORK"/chunk_* | head -5 | tail -1)
"$TIKO" --check --stats -fmax-errors 100000 $FBCUNIT $(cat "$LAST") > "$WORK/chunk.out" 2>&1 || true
CH_READ=$(awk '/^source bytes/{print $3}' "$WORK/chunk.out")
CHUNK_RSS=$( peak_rss --check -fmax-errors 100000 $FBCUNIT $(cat "$LAST") )
SELF_RSS=$( peak_rss --check -i src $SELF )

# ---------------------------------------------------------------- 6. vs fbc -gen gcc
# THE ROW SAYS 'tiko build', WHICH CANNOT BE RUN: tiko does not compile itself yet. The
# substitute is corpus programs BOTH compilers accept, built both ways -- once to an
# object and once all the way to an executable, because the two halves answer
# differently and one average would hide it.
E2E="skipped (no fbc at $FBC)"
CMP=""
if [ -x "$FBC" ]; then
    grep -L 'fbcunit' $(cat "$WORK/corpus.lst") 2>/dev/null > "$WORK/standalone.lst" || true
    : > "$WORK/both.lst"
    want=${PERF_LINK_N:-40}
    for f in $(head -200 "$WORK/standalone.lst"); do
        [ "$(wc -l < "$WORK/both.lst")" -ge "$want" ] && break
        if "$TIKO" $LIBP -o "$WORK/t.exe" "$f" > /dev/null 2>&1 &&
           "$FBC" -gen gcc -x "$WORK/f.exe" "$f" > /dev/null 2>&1 ; then
            echo "$f" >> "$WORK/both.lst"
        fi
    done
    N=$(wc -l < "$WORK/both.lst")
    s=$( now_ms )
    while read -r f; do "$TIKO" -c -o "$WORK/t.o" "$f" > /dev/null 2>&1 || true; done < "$WORK/both.lst"
    e=$( now_ms ); TKO_C=$(( e - s ))
    s=$( now_ms )
    while read -r f; do "$FBC" -c -gen gcc -o "$WORK/f.o" "$f" > /dev/null 2>&1 || true; done < "$WORK/both.lst"
    e=$( now_ms ); FBC_C=$(( e - s ))
    s=$( now_ms )
    while read -r f; do "$TIKO" $LIBP -o "$WORK/t.exe" "$f" > /dev/null 2>&1 || true; done < "$WORK/both.lst"
    e=$( now_ms ); TKO_X=$(( e - s ))
    s=$( now_ms )
    while read -r f; do "$FBC" -gen gcc -x "$WORK/f.exe" "$f" > /dev/null 2>&1 || true; done < "$WORK/both.lst"
    e=$( now_ms ); FBC_X=$(( e - s ))
    E2E="$N programs both compilers build"
    CMP=$(awk -v tc="$TKO_C" -v fc="$FBC_C" -v tx="$TKO_X" -v fx="$FBC_X" 'BEGIN {
        printf "  to an object   tiko %6.2f s   fbc %6.2f s   ratio %.2f\n", tc/1000, fc/1000, tc/fc
        printf "  to an exe      tiko %6.2f s   fbc %6.2f s   ratio %.2f\n", tx/1000, fx/1000, tx/fx
        printf "  the link half  tiko %6.2f s   fbc %6.2f s   ratio %.2f\n", (tx-tc)/1000, (fx-fc)/1000, (tx-tc)/(fx-fc) }')
fi

# ---------------------------------------------------------------- the table
awk -v files="$FILES" -v input="$INPUT" \
    -v lexs="$LEX_S" -v lexb="$LEX_B" -v lext="$LEX_T" \
    -v pars="$PAR_S" -v parr="$PAR_R" -v astb="$AST_B" -v astt="$AST_T" \
    -v fes="$FE_S" -v feerr="$FE_ERRS" \
    -v selfn="$SELF_N" -v selfb="$SELF_B" -v selfread="$SELF_READ" \
    -v selfpar="$SELF_PAR" -v selffe="$SELF_FE" \
    -v selfastb="$SELF_AST_B" -v selfastt="$SELF_AST_T" \
    -v floor="$RSS_FLOOR" -v bigrss="$BIG_RSS" -v bigread="$BIG_READ" \
    -v chrss="$CHUNK_RSS" -v chread="$CH_READ" -v selfrss="$SELF_RSS" -v e2e="$E2E" '
function mb( b ) { return b / 1048576.0 }
function verdict( got, want, higher ) {
    if( higher ) return (got >= want) ? "MET" : "MISSED"
    return (got <= want) ? "MET" : "MISSED"
}
BEGIN {
    printf "\n--- docs/plan/14 section 4, measured ---\n\n"
    printf "corpus: %d files, %.2f MB input, %.2f MB processed by its %d units\n\n", files, mb(input), mb(parr), files
    l = mb(lexb) / lexs
    printf "lexer      %8.2f MB/s input  %11.0f tokens/s   budget >= 20 MB/s  %s\n", l, lext/lexs, verdict(l,20,1)
    p1 = mb(input) / pars; p2 = mb(parr) / pars
    printf "parse      %8.2f MB/s input  %8.2f MB/s read   budget >=  8 MB/s  %s\n", p1, p2, verdict(p2,8,1)
    f1 = mb(input) / fes; f2 = mb(parr) / fes
    printf "frontend   %8.2f MB/s input  %8.2f MB/s read   budget >=  4 MB/s  %s\n", f1, f2, verdict(f2,4,1)
    printf "           (%.1f s of --check; %d diagnostics -- tiko rejects part of the corpus)\n", fes, feerr
    a = astb / astt
    printf "AST        %8.2f bytes/token                    budget <= 40       %s\n", a, verdict(a,40,0)
    printf "\nself-compile: %d modules, %.2f MB of .bas, %.2f MB read\n", selfn, mb(selfb), mb(selfread)
    printf "  parse    %8.2f s\n", selfpar
    printf "  frontend %8.2f s                              budget <= 10 s     %s\n", selffe/1000.0, verdict(selffe/1000.0,10,0)
    printf "  AST      %8.2f bytes/token                    budget <= 40       %s\n", selfastb/selfastt, verdict(selfastb/selfastt,40,0)
    printf "\npeak RSS (the floor, one --version, is %.2f MB)\n", mb(floor)
    allow = 5.0 + 32.0 * mb(bigread)
    printf "  ONE UNIT, largest corpus file %6.2f MB, allowed %6.2f MB (5 + 32 x %.2f MB read)  %s\n", mb(bigrss), allow, mb(bigread), verdict(mb(bigrss),allow,0)
    printf "  many units in one process -- reported, not judged by that rule:\n"
    printf "    300-file chunk %6.2f MB, %5.2f MB read, %.1fx  (%.1fx above the floor)\n", mb(chrss), mb(chread), chrss/chread, (chrss-floor)/chread
    printf "    self-compile   %6.2f MB, %5.2f MB read, %.1fx  (%.1fx above the floor)\n", mb(selfrss), mb(selfread), selfrss/selfread, (selfrss-floor)/selfread
    printf "\nend to end vs fbc -gen gcc: %s   budget: not slower\n", e2e
}'
printf '%s' "$CMP"
echo
