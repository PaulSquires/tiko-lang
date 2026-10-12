#!/bin/sh
# oracle.sh -- what tiko-rt's ORACLE scripts share: an fbc, and fbc-modern's tree.
#
# Sourced after common.sh, never executed:
#
#   . "$(dirname "$0")/common.sh"
#   . "$(dirname "$0")/oracle.sh"
#   rt_check_tools
#   rt_oracle_check <script name>
#
# by gate.sh, gatemsvc.sh, diff.sh, diffmsvc.sh, symbols.sh, cbase.sh and bench.sh --
# the scripts that compare tiko-rt with fbc's libfb, its test suite or its output.
# NOTHING THAT BUILDS tiko-rt sources this (bootstrap plan, phase X, 2026-10-10): the
# runtime is built by tiko, and what used to live in common.sh for fbc moved here.
#
# THE ORACLE IS OPTIONAL. Without an fbc the scripts SKIP -- exit 0, and say so -- so a
# machine with no fbc can build, package and gate (the bootstrap plan's ORACLE.md).

# fbc-modern's tree: its sources (HEADERS only, never a .c body -- PROVENANCE.md), its
# shipped archives and its test suite.
FBC_TREE=${FBC_TREE:-/c/dev/fbc-modern}

# THE fbc: TKO_ORACLE_FBC, the one variable every oracle script in tiko-lang reads, else
# TKORT_FBC as before, else fbc-modern's toolchain fbc for this host.
if [ -n "${TKO_ORACLE_FBC:-}" ]; then
    TKORT_FBC=$TKO_ORACLE_FBC
elif [ -z "${TKORT_FBC:-}" ]; then
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) TKORT_FBC="$FBC_TREE/toolchains/fbc-modern-windows/fbc64.exe" ;;
        *)                    TKORT_FBC="$FBC_TREE/toolchains/fbc-modern-linux/bin/fbc" ;;
    esac
fi

# Present, or this script has nothing to compare against and skips.
rt_oracle_check( ) {
    if [ ! -x "$TKORT_FBC" ] || [ ! -d "$FBC_TREE" ]; then
        echo "$1: SKIPPED -- no oracle: fbc $TKORT_FBC, tree $FBC_TREE (TKO_ORACLE_FBC, FBC_TREE)"
        exit 0
    fi
}

# Where fbc's own libfb.a lives for a target.
#
# Two layouts, and the difference is not cosmetic: the standalone build tree puts
# win32/win64 archives in lib/<target>/, but for linux-x86_64 that directory holds
# only the startup objects (fbrt0.o and friends) and the ARCHIVES are one level
# down in lib/freebasic/<target>/. A script that assumes the first layout finds a
# real directory with no libfb.a in it, which reads as "wrong target" rather than
# "wrong path".
rt_reflib( ) {
    for d in "$FBC_TREE/src/lib/$1" "$FBC_TREE/src/lib/freebasic/$1"; do
        if [ -f "$d/libfb.a" ]; then echo "$d"; return 0; fi
    done
    return 1
}

# THE TARGET NAME fbc IS GIVEN. fbc has no MSVC target -- its -target table is
# win64, win32, x86_64-w64-mingw32 and linux-x86_64, and every msvc spelling is
# its error 81 -- so windows-x86_64 compiles as win64 and is retargeted afterwards.
rt_fbc_target( ) {
    case "$1" in
        windows-x86_64) echo "win64" ;;
        *)          echo "$1" ;;
    esac
}
