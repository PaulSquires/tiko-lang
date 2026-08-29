#!/bin/bash
# tools/owed.sh -- the WORK-OWED filter over the last sweep's per-file skip counts.
#
# A raw skip count answers "how many statements did tiko decline?", which is not the
# same question as "how much work is owed?". Five buckets of the corpus are files
# tiko is CORRECT to decline, and they are the majority:
#
#   1. NEGATIVE tests        -- COMPILE_ONLY_FAIL / COMPILE_AND_RUN_FAIL: the file is
#                               there to be REJECTED. Declining it is the pass.
#   2. wrong dialect by PATH -- qb/ deprecated/ fblite/. tiko is #lang "fb" only.
#   3. wrong dialect by PRAGMA -- the same, said inside a file that sits elsewhere.
#   4. errors/               -- likewise written to be rejected.
#   5. fbc REJECTS IT TOO    -- measured, cached in tools/.fbc-rejects. If the ground
#                               truth will not compile it, tiko owes nothing.
#
# Run after build/mirsweep.sh (it reads that run's build/.skipparts/).
#   bash tools/owed.sh            -- the ranked owed files
#   bash tools/owed.sh --lines    -- the ranked owed SOURCE LINES
#   bash tools/owed.sh --why      -- the bucket census, so the ratio stays visible
set -u
cd "$(dirname "$0")/.."
[ -d build/.skipparts ] || { echo "owed: no build/.skipparts -- run build/mirsweep.sh first" >&2; exit 1; }
REJ=tools/.fbc-rejects
owed=""; declare -A CNT
n_neg=0; n_path=0; n_prag=0; n_err=0; n_rej=0; n_owed=0
c_neg=0; c_path=0; c_prag=0; c_err=0; c_rej=0; c_owed=0
# The part FILENAME is the corpus file, key-mangled; the lines INSIDE it are the source
# lines that declined, which are often a HEADER the corpus file included. Classify by the
# corpus file -- ex06.bas says '$lang: "qb"' in its own text and declines every line of it
# inside fbcunit.bi, so reading the first skip line instead answers about the wrong file.
declare -A SRCOF
while read -r f; do
    k="${f//[!A-Za-z0-9._-]/_}"; SRCOF[$k]="$f"
done < build/.corpus.lst
for part in build/.skipparts/*; do
    [ -s "$part" ] || continue
    src="${SRCOF[$(basename "$part")]:-}"
    [ -n "$src" ] && [ -f "$src" ] || continue
    k=$(wc -l < "$part")
    case "$src" in
        */qb/*|*/deprecated/*|*/fblite/*) n_path=$((n_path+1)); c_path=$((c_path+k)); continue;;
        */errors/*)                       n_err=$((n_err+1));  c_err=$((c_err+k));  continue;;
    esac
    if grep -qE 'COMPILE_(ONLY|AND_RUN)_FAIL' "$src"; then
        n_neg=$((n_neg+1)); c_neg=$((c_neg+k)); continue
    fi
    if grep -qiE '^[[:space:]]*(#lang[[:space:]]*"(qb|fblite|deprecated)"|'"'"'\$lang:)' "$src"; then
        n_prag=$((n_prag+1)); c_prag=$((c_prag+k)); continue
    fi
    if [ -f "$REJ" ] && grep -qxF "$src" "$REJ"; then
        n_rej=$((n_rej+1)); c_rej=$((c_rej+k)); continue
    fi
    n_owed=$((n_owed+1)); c_owed=$((c_owed+k)); owed="$owed $part"
done
case "${1:-}" in
  --why)
    printf 'owed: %5d skips in %4d files -- OWED\n' $c_owed $n_owed
    printf 'owed: %5d skips in %4d files -- negative tests\n' $c_neg $n_neg
    printf 'owed: %5d skips in %4d files -- wrong dialect by path\n' $c_path $n_path
    printf 'owed: %5d skips in %4d files -- wrong dialect by pragma\n' $c_prag $n_prag
    printf 'owed: %5d skips in %4d files -- errors/\n' $c_err $n_err
    printf 'owed: %5d skips in %4d files -- fbc rejects it too\n' $c_rej $n_rej
    ;;
  --lines) cat $owed | sort | uniq -c | sort -rn ;;
  *) for p in $owed; do printf '%5d %s\n' "$(wc -l < "$p")" "${SRCOF[$(basename "$p")]}"; done | sort -rn ;;
esac
