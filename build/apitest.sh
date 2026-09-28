#!/bin/sh
# apitest.sh -- the in-process checks for the editor's tikoParser.dll (src/api).
#
#   build/apitest.sh            (after build/build.sh --dll; Windows only)
#
# tests/api/*.test cover WHAT a scan records, through 'tiko --dump-scan'. This covers what
# only a host that loads the DLL can see: the exports and the contract version, scan_text
# byte-identical to scan, the same result scan after scan in one process, a working set
# that does not keep growing, a broken file that stays quiet, and an '#import' scan.

set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) ;;
    *) echo "apitest: Windows only (the harness loads a .dll)"; exit 0 ;;
esac
FBC=${TKO_STAGE0:-/c/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe}
DLL=bin/tikoParser.dll
[ -f "$DLL" ] || { echo "apitest: $DLL not built -- build/build.sh --dll" >&2; exit 3; }

"$FBC" tools/tkpdump/tkpdump.bas -i src -w all -x bin/tkpdump.exe
H=bin/tkpdump.exe
FAIL=0
check( ) {  # check <label> <expected-substring> <command...>
    label=$1; want=$2; shift 2
    if out=$("$@" 2>&1) && echo "$out" | grep -qF -- "$want"; then
        echo "ok    $label"
    else
        echo "FAIL  $label"; echo "$out" | sed 's/^/      /'; FAIL=1
    fi
}

check "scan_text == scan (basic)"  "TEXT OK" $H $DLL tests/api/src/scanbasic.tiko text
check "scan_text == scan (broken)" "TEXT OK" $H $DLL tests/api/src/scanbroken.tiko text
check "100 scans, one result, no leak" "all identical = yes" $H $DLL tests/api/src/scanbasic.tiko loop 100

# A broken file: records and diagnostics come back, and NOTHING reaches the host's console.
out=$($H $DLL tests/api/src/scanbroken.tiko dump 2>&1)
if echo "$out" | grep -qF "diags: 3" && ! echo "$out" | grep -qF "TKO0"; then
    echo "ok    broken file: 3 diags, none printed"
else
    echo "FAIL  broken file"; echo "$out" | sed 's/^/      /'; FAIL=1
fi

# '#import' through the DLL: the module's public procedure under its alias, at its source.
INC=$(cygpath -w "$ROOT/tests/driver/src/modcache/libs")
out=$(TKP_INCDIR="$INC" $H $DLL tests/driver/src/modcache/app/main.bas dump 2>&1)
if echo "$out" | grep -qF "k2 Twice as long  @3:3:17  parent=2  body=3..5" && \
   echo "$out" | grep -qF "k13 middle  @0:1:15"; then
    echo "ok    #import: middle.Twice at middle.bas:3:17"
else
    echo "FAIL  #import"; echo "$out" | sed 's/^/      /'; FAIL=1
fi
[ -e tests/driver/src/modcache/app/.tiko ] && { echo "FAIL  #import scan wrote a module cache"; FAIL=1; }

[ "$FAIL" = "0" ] && echo "apitest: ok" || { echo "apitest: FAILED"; exit 1; }
