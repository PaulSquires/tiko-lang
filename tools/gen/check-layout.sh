#!/bin/sh
# check-layout.sh -- tiko-lang's builtin layout must agree with fbc's, field by field.
set -e
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) EXT=".exe" ;; *) EXT="" ;; esac

rc=0

one( ) {
    TRUTH=$1; tgt=$2; label=$3
    if [ ! -f "$TRUTH" ]; then
        echo "check-layout: no $label expectations; run tools/gen/layout-truth.sh" >&2
        return 3
    fi
    ./bin/tiko$EXT --dump-types $tgt tests/lexer/src/basics.bas 2>/dev/null \
        > "build/.types-$label.out"
    bad=0
    while read -r name size align; do
        [ -z "$name" ] && continue
        line=$(grep -E "^ *[0-9]+ $name +size=" "build/.types-$label.out" || true)
        got_size=$(echo "$line" | sed -n 's/.*size= *\([0-9]*\).*/\1/p')
        got_align=$(echo "$line" | sed -n 's/.*align= *\([0-9]*\).*/\1/p')
        if [ "$got_size" != "$size" ] || [ "$got_align" != "$align" ]; then
            echo "check-layout: $label $name fbc=$size/$align tiko-lang=$got_size/$got_align" >&2
            bad=$((bad + 1))
        fi
    done < "$TRUTH"
    if [ "$bad" -gt 0 ]; then
        echo "check-layout: $label $bad mismatch(es)" >&2
        return 1
    fi
    echo "check-layout: $label ok ($(grep -c . "$TRUTH") builtin types agree with fbc)"
}

# NAME THE TARGET, do not inherit the host's. The label said win64 while the
# empty argument asked for whatever the host defaults to -- true on Windows and
# false under WSL, where this measured linux-x86_64 and still called it win64.
# The expectations are fbc's WIN64 answers, so win64 is what must be asked for.
#
# THIS ONE WAS NOT MERELY MISLABELLED. Layout DOES differ by target --
# measured, wstring is 2 bytes on win64 and 4 on linux-x86_64, cva_list 8 and
# 24 -- so under WSL this compared LINUX sizes against WIN64 expectations. It
# passed only because the expectations cover the fourteen target-independent
# scalars and name neither of those two types. Adding one would have turned a
# silent pass into a mystery failure on Linux alone.
one tests/types/expected/fbc-layout.txt       "-target win64" win64 || rc=1
exit $rc
