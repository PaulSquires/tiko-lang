#!/bin/sh
# check-mangle.sh -- the D3 gate: tiko-lang's mangled names against fbc's, byte for byte.
#
#   tools/gen/check-mangle.sh
#
# Compares tiko-lang --dump-mangle with the symbols tools/gen/mangle-truth.sh extracted
# from fbc. A single differing character here is a link error in someone else's
# project against a library tiko-lang never saw, so the comparison is exact and the gate
# is all-or-nothing.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
# THE HOST'S BINARY, chosen by PLATFORM and not by which file happens to
# exist. Preferring bin/tiko.exe and falling back only when it is absent
# picks the WINDOWS build under WSL, where both binaries sit in bin/ after
# a dual-platform session. WSL cannot run it, the 2>/dev/null below ate the
# error, and the comparison reported all 135 names missing rather than
# saying it never ran. Same idiom as build/build.sh.
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;; *) EXT="" ;; esac
TKO="$ROOT/bin/tiko$EXT"
# ...AND SAY SO WHEN IT IS NOT THERE. The dump below discards stderr, so a
# missing binary produced an empty result that read as "every name wrong".
[ -x "$TKO" ] || { echo "${0##*/}: $TKO not built" >&2; exit 3; }
EXPECTED="$ROOT/tests/mangle/expected/fbc-mangle.txt"
WORK="$ROOT/build/.mg"

if [ ! -f "$EXPECTED" ]; then
    echo "check-mangle: no expected file; run tools/gen/mangle-truth.sh" >&2
    exit 3
fi


mkdir -p "$WORK"
rc=0

one( ) {
    want=$1; tgt=$2; label=$3
    if [ ! -f "$want" ]; then
        echo "check-mangle: no $label expectations" >&2
        return 3
    fi
    "$TKO" --dump-mangle $tgt "$ROOT/tests/mangle/src/probe.bas" 2>/dev/null         | tr -d "\r" | sort > "$WORK/tiko-$label.txt"
    if diff -u "$want" "$WORK/tiko-$label.txt" > "$WORK/diff-$label.txt"; then
        n=$(wc -l < "$want" | tr -d ' ')
        echo "check-mangle: $label ok -- $n/$n names match fbc"
        return 0
    fi
    echo "check-mangle: $label MISMATCH"
    cat "$WORK/diff-$label.txt"
    return 1
}

# NAME THE TARGET, do not inherit the host's. The label said win64 while the
# empty argument asked for whatever the host defaults to -- true on Windows and
# false under WSL, where this measured linux-x86_64 and still called it win64.
# The expectations are fbc's WIN64 answers, so win64 is what must be asked for.
#
# MEASURED 2026-09-04: --dump-mangle is byte-identical for win64 and
# linux-x86_64, all 135 names. It always was going to be -- win32's '@N'
# stdcall decoration was the only target-dependent part, and win32 was removed
# -- so the old invocation gave the right ANSWER on both hosts. It gave it for
# the wrong reason, and would have stopped the day a target diverged.
one "$EXPECTED"   "-target win64" win64 || rc=1
exit $rc
