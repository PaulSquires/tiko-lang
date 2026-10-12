#!/bin/sh
# cimportdiff.sh -- import C headers with tiko and with fbc-modern, and compare the bindings.
#
#   bash build/cimportdiff.sh [--all]
#
# fbc-modern's -cimport-out is the only other importer that writes this format, so it is
# the differential oracle for tiko's (0016 §B): same header, same target, both bindings,
# compared by build/cimportdiff.py as SETS -- declarations by name, the rename and skip
# ledgers as multisets -- because a line diff turns one reordered record into thousands.
#
# WHAT RUNS WHERE. Freestanding headers -- ours and fbc-modern's own test headers, which
# need nothing past <stddef.h> -- are imported for BOTH 64-bit targets on either host.
# sqlite3.h and the C library need the target's system headers, so they run for the HOST
# target only; windows.h on Windows. windows-x86_64 is not here: fbc-modern cannot import for
# it, and its oracle is clang's own layout (build/cimportlayout.sh).
#
# A DIFFERENCE IS NOT AUTOMATICALLY A DEFECT. Each class below was run down to its cause,
# and each is a PREDICATE the comparer checks against the two files -- never a list of
# names -- so the count to read is "unexplained". Add a class only with its cause.
#
#   DUP-MACRO       fbc-modern keeps EVERY definition of a macro C redefines: a constant
#                   comes out twice, the second as NAME_2 with the same value, and an alias
#                   collides with itself and is refused ("not unique once case is ignored").
#                   tiko keeps one, at the macro's first position, valued as C ends it.
#   DUP-SKIP        fbc-modern ledgers a typedef C declares twice, twice.
#   SPURIOUS-SKIP   fbc-modern ledgers 'record has no importable members' for a record it
#                   then declares -- a forward declaration met before the definition.
#   DANGLING-ALIAS  fbc-modern writes '#define A B' where B is declared nowhere in its own
#                   binding (urlmon.h's LPOINETPROTOCOLSINKSTACKABLE, mingw's _copysignl
#                   to a long-double function it skipped). tiko aliases only to a name it
#                   emitted.
#   STALE-ALIAS     a forward alias fbc-modern resolved to 'any ptr' for a record both skip,
#                   where tiko names the record: FreeBASIC takes a pointer to an undeclared
#                   type as a forward reference (winnt.h PCACTIVATION_CONTEXT_...).
#   ALIAS-CONST     fbc-modern drops the pointee's const through a forward alias; tiko keeps
#                   it where it has a spelling.
#   ORPHAN          a synthetic 'Parent_field_t' record written before its parent was then
#                   refused. Both importers do it; they refuse at different parents.
#   NESTED-NAMED    a named record declared inside another is file scope in C, and tiko
#                   keeps its C name; fbc-modern names it 'Parent_field_t'. Paired through
#                   the parent's field and confirmed by identical bodies.
#   NESTED-KEPT     the same kind of record, used by no field -- objidl.h's
#                   _STGMEDIUM_UNION -- which fbc-modern drops and tiko declares.
#   TIKO-IMPORTS    fbc-modern skips what tiko imports: an array parameter (decays to a
#                   pointer, as C adjusts it), an anonymous member of an unnamed record,
#                   and everything that cascaded from either -- the records' own synthetic
#                   members, the records they name, and 'any ptr' where tiko names them.
#   TIKO-DEEPER     both skip a record, tiko at a later member than fbc-modern's first
#                   refusal, because the earlier one is a shape tiko handles.
#   LAYOUT-REFUSED  a record tiko lays out differently from clang, refused by tiko's own
#                   layout check (driver/cimportverify.bas), and whatever held it by value.
#                   fbc-modern writes it and then fails its own check (error 390): SysV's
#                   bit-fields that share a storage unit with the next member -- probe.h's
#                   probe_bits on linux-x86_64.
#   REASON-WORDING  both skip, for the same reason in different words: an extern array of
#                   unknown size, and a member whose record was skipped (fbc-modern's
#                   sentence stops at "cannot be").
#
# Not a gate: it needs fbc-modern, a Windows SDK or MinGW, and several minutes on
# windows.h. The freestanding headers are the part tests/cimport pins byte for byte.
set -u
cd "$(dirname "$0")/.."
ROOT=$(pwd)
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) HOST=win64 ;;
    *) HOST=linux-x86_64 ;;
esac
if [ "$HOST" = win64 ]; then
    FBCROOT=${FBCROOT:-/c/dev/fbc-modern}
    FBC=${FBC:-${TKO_ORACLE_FBC:-$FBCROOT/toolchains/fbc-modern-windows/fbc64.exe}}
    TKO=${TKO:-$ROOT/bin/tiko.exe}
    PY=${PYTHON:-python}
else
    FBCROOT=${FBCROOT:-/mnt/c/dev/fbc-modern}
    FBC=${FBC:-${TKO_ORACLE_FBC:-$FBCROOT/toolchains/fbc-modern-linux/bin/fbc}}
    TKO=${TKO:-$ROOT/bin/tiko}
    PY=${PYTHON:-python3}
fi
SHOWALL=
[ "${1:-}" = "--all" ] && SHOWALL=--all
WK=${TMPDIR:-/tmp}/cimportdiff.$$
mkdir -p "$WK"
trap 'rm -rf "$WK"' EXIT

printf '#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n#include <wchar.h>\n#include <ctype.h>\n#include <math.h>\n#include <time.h>\n#include <errno.h>\n#include <setjmp.h>\n#include <stdarg.h>\n' > "$WK/libc.h"
[ "$HOST" = linux-x86_64 ] && printf '#include <unistd.h>\n' >> "$WK/libc.h"

nrun=0; nclean=0; nexpl=0; nbad=0; nfail=0

# one <tag> <header> <target>
one() {
    tag=$1; h=$2; t=$3
    nrun=$((nrun + 1))
    # fbc-modern verifies its binding's layout after writing it, and exits non-zero when
    # its own FreeBASIC layout disagrees with clang -- probe.h's bit-fields for
    # linux-x86_64 (error 390). The binding is still its answer to compare against.
    if ! "$FBC" -target "$t" -cimport "$h" -cimport-out "$WK/$tag.$t.fbc.bi" > "$WK/fbc.log" 2>&1; then
        if [ ! -s "$WK/$tag.$t.fbc.bi" ]; then
            echo "$tag $t: fbc-modern failed to import"; sed -n 1,5p "$WK/fbc.log"; nfail=$((nfail + 1)); return
        fi
        echo "$tag $t: fbc-modern wrote its binding, then failed: $(grep -o 'error [0-9]*:.*' "$WK/fbc.log" | head -1 | cut -c1-160)"
    fi
    if ! "$TKO" -target "$t" -cimport "$h" -cimport-out "$WK/$tag.$t.tiko.bi" > "$WK/tiko.log" 2>&1; then
        echo "$tag $t: tiko failed to import"; sed -n 1,5p "$WK/tiko.log"; nfail=$((nfail + 1)); return
    fi
    "$PY" build/cimportdiff.py "$WK/$tag.$t.fbc.bi" "$WK/$tag.$t.tiko.bi" "$tag $t" $SHOWALL > "$WK/out" 2>&1
    rc=$?
    cat "$WK/out"
    if [ $rc -ne 0 ]; then
        nbad=$((nbad + 1))
    elif grep -q ", 0 differences," "$WK/out"; then
        nclean=$((nclean + 1))
    else
        nexpl=$((nexpl + 1))
    fi
}

for t in win64 linux-x86_64; do
    one probe tests/cimport/src/probe.h $t
    one shapes tests/cimport/src/shapes.h $t
    for h in aggregates types testlib; do
        one $h "$FBCROOT/docs/tests/cimport/$h.h" $t
    done
done
one sqlite3 "$FBCROOT/src/examples/cimport/vendor/sqlite3.h" $HOST
one libc "$WK/libc.h" $HOST
[ "$HOST" = win64 ] && one windows windows.h win64

echo "cimportdiff: $nrun imports -- $nclean identical, $nexpl explained, $nbad with unexplained differences, $nfail failed"
[ $nbad -eq 0 ] && [ $nfail -eq 0 ]
