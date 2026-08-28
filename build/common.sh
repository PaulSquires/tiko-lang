#!/bin/sh
# common.sh -- configuration shared by every tiko-rt build script.
#
# Sourced, never executed:  . "$(dirname "$0")/common.sh"
#
# Everything target- or toolchain-specific lives here and nowhere else, so that
# adding a target is one edit rather than five.

# ------------------------------------------------------------------ paths

RT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

# The reference tree: fbc-modern's sources, its shipped archives, and its test
# suite. tiko-rt reads HEADERS and BINARIES from here and never a .c body
# (PROVENANCE.md).
FBC_TREE=${FBC_TREE:-/c/dev/fbc-modern}

# stage0 -- the compiler that builds tiko-rt. Overridable because it moves.
if [ -z "${TKORT_FBC:-}" ]; then
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
            TKORT_FBC="$FBC_TREE/toolchains/fbc-modern-windows/fbc64.exe" ;;
        *)
            TKORT_FBC="$FBC_TREE/toolchains/fbc-modern-linux/bin/fbc" ;;
    esac
fi

# clang. fbc's -gen llvm hands the .ll to clang -c, and looks for a
# target-prefixed <target>-clang.exe that does not exist: one clang serves every
# target through --target. Absolute, and with .exe on Windows. This is the same
# workaround gate-win.sh in fbc-modern uses, for the same reason.
if [ -z "${CLANG:-}" ]; then
    CLANG=$(command -v clang 2>/dev/null || echo "/c/Program Files/LLVM/bin/clang.exe")
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
            case $CLANG in *.exe) ;; *) CLANG="$CLANG.exe" ;; esac ;;
    esac
fi
export CLANG

# llvm-ar. D13: the toolchain is 100% LLVM -- llvm-ar, not the MinGW ar.
if [ -z "${TKORT_AR:-}" ]; then
    TKORT_AR=$(command -v llvm-ar 2>/dev/null || echo "/c/Program Files/LLVM/bin/llvm-ar.exe")
fi
if [ -z "${TKORT_NM:-}" ]; then
    TKORT_NM=$(command -v llvm-nm 2>/dev/null || echo "/c/Program Files/LLVM/bin/llvm-nm.exe")
fi

# ------------------------------------------------------------------ targets

# The three targets of R3. Any other target is not a gap to be filled later:
# it is out of scope, and the build refuses it rather than guessing.
RT_TARGETS="win64 win32 linux-x86_64"

# Include path. fbc's src/inc supplies the OS bindings (src/sys/sys.bi explains
# why they, and not #cinclude, are the primary binding under the amended R6).
#
# Note this also puts fb/*.bi, string.bi and the containers within reach -- all
# of them BANNED by the freestanding subset. lint.sh is what keeps them out;
# the include path cannot.
RT_INC="$RT_ROOT/src $FBC_TREE/src/inc"

rt_incflags( ) {
    for d in $RT_INC; do printf -- '-i %s ' "$d"; done
}

rt_is_target( ) {
    for t in $RT_TARGETS; do [ "$1" = "$t" ] && return 0; done
    return 1
}

# ------------------------------------------------------------------ flags

# Configuration flags. Note what is ABSENT: -exx and -e are NEVER used, on any
# configuration. They insert bounds and null checks that call into the runtime,
# which is the code being defined. See docs/tiko-rt/RFC-0003 section 3.
rt_cfg_flags( ) {
    case "$1" in
        Debug)          echo "-g -w all" ;;
        RelWithDebInfo) echo "-g -O 2 -w all" ;;
        Release)        echo "-O 2 -w all" ;;
        *)              return 1 ;;
    esac
}

# Every export is declared inside EXTERN "rtlib", which reproduces FBCALL on all
# three targets. Measured, not assumed -- PROBE-1, 2026-08-28:
#
#   extern "rtlib"    win32 _fb_Probe@8   win64 fb_Probe   linux fb_Probe   CORRECT
#   extern "c"        win32 _fb_Probe     -- no @N, wrong on win32
#   extern "windows"  win32 _fb_Probe@8   -- right by accident, wrong in meaning
#
# There is no flag for this; it is a source rule, checked by lint.sh.

# ------------------------------------------------------------------ helpers

rt_die( ) { echo "tiko-rt: $*" >&2; exit 2; }

rt_check_tools( ) {
    [ -x "$TKORT_FBC" ] || rt_die "stage0 compiler not found at $TKORT_FBC (set TKORT_FBC)"
    [ -x "$CLANG" ]     || rt_die "clang not found at $CLANG (set CLANG)"
    [ -x "$TKORT_AR" ]  || rt_die "llvm-ar not found at $TKORT_AR (set TKORT_AR)"
    [ -d "$FBC_TREE" ]  || rt_die "fbc-modern tree not found at $FBC_TREE (set FBC_TREE)"
}

# Source list: one module path per line, relative to src/, '#' comments allowed.
#
# The '|| true' is not defensive clutter. Until S2 the list is empty, grep exits
# 1, and under 'set -e' the caller's assignment inherits that status and the
# script dies with NO OUTPUT AT ALL -- which reads as "nothing to do" rather than
# as a failure. An empty source list is a legitimate state; grep's exit code is
# not the way to learn about it.
rt_sources( ) {
    grep -v '^[[:space:]]*#' "$RT_ROOT/build/sources.txt" 2>/dev/null \
        | grep -v '^[[:space:]]*$' || true
}
