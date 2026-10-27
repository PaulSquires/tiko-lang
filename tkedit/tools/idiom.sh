#!/bin/bash
# The idiom gate (PLAN.md, Verification): fails on FB-era forms tkEdit does not use.
#   bash tools/idiom.sh        prints each offending line; exit code = number of rules broken
# Comment lines are skipped. Test programs (*/tests/*) may keep counters in `dim shared`.
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 1
bad=0

rule() {     # rule <name> <regex> <path filter to EXCLUDE, regex on the file name> [code]
    # "code": the regex must match outside string literals ("wstring" in a word list is data)
    local hits
    hits=$(grep -rniE --include='*.tiko' --include='*.ti' "$2" src \
               | grep -viE '^[^:]+:[0-9]+:[[:space:]]*'"'" \
               | { [ -n "$3" ] && grep -vE "$3" || cat; } \
               | { if [ "$4" = code ]; then
                       RX=$2 perl -ne '($f, $c) = /^([^:]+:\d+:)(.*)$/s; $c =~ s/"[^"]*"//g;
                                       $r = $ENV{RX}; $r =~ s/\[\[:space:\]\]/\\s/g; print if $c =~ /$r/i'
                   else cat; fi; })
    if [ -n "$hits" ]; then
        echo "== $1"; echo "$hits"; bad=$((bad+1))
    fi
}

rule "dim shared (state belongs to an object)"  '\bdim[[:space:]]+shared\b'  '^[^:]*/tests/'   code
rule "redim (use containers.Array)"             '\bredim\b'                  ''                  code
rule "wstring (use ustring)"                    '\bwstring\b'                ''                  code
rule "iif with a string arm (use if/else)"      '\biif[[:space:]]*\(.*"'     ''
rule "TIKO_OS_* outside src/platform"           'TIKO_OS_'                   '^src/platform/|^[^:]*/tests/'
rule "raw SCI_ outside the Editor class"        '\bSCI_[A-Z]'                '^src/app/editor/'
echo "idiom rules broken: $bad"
exit $bad
