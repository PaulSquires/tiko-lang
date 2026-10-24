# toolchain.sh -- WHERE THE EXTERNAL TOOLS ARE, sourced by every script that needs one.
#
#   . "$ROOT/build/toolchain.sh"
#
# One answer per tool (review BLD-12, 2026-10-24). Each script used to find clang its own
# way -- six of them, two of which ignored TKO_CLANG -- and five hard-coded the oracle fbc.
# An environment variable already set always wins; this only fills in what is unset:
#
#   TKO_ORACLE_ROOT  the fbc-modern toolchain directory (fbc64.exe / bin/fbc, inc/)
#   TKO_ORACLE_FBC   the oracle compiler itself
#   TKO_CLANG        clang; then TKO_AR (llvm-ar) and TKO_NM (llvm-nm) beside it or on PATH
#
# THE SKIP CODE IS 77, automake's. A script that cannot run because a tool is missing
# exits 77 through tko_need_oracle, and check-all reports it as SKIPPED -- not as a
# failure, which teaches people to ignore the gate, and not as a pass, which is a lie.
TKO_SKIP=77

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        : "${TKO_ORACLE_ROOT:=/c/dev/fbc-modern/toolchains/fbc-modern-windows}"
        : "${TKO_ORACLE_FBC:=$TKO_ORACLE_ROOT/fbc64.exe}"
        if [ -z "${TKO_CLANG:-}" ]; then
            TKO_CLANG=$(command -v clang 2>/dev/null || echo "/c/Program Files/LLVM/bin/clang.exe")
            case $TKO_CLANG in *.exe) ;; *) TKO_CLANG="$TKO_CLANG.exe" ;; esac
        fi
        _tko_llvm_bin=$(dirname "$TKO_CLANG")
        : "${TKO_AR:=$(command -v llvm-ar 2>/dev/null || echo "$_tko_llvm_bin/llvm-ar.exe")}"
        : "${TKO_NM:=$(command -v llvm-nm 2>/dev/null || echo "$_tko_llvm_bin/llvm-nm.exe")}"
        ;;
    *)
        if [ -z "${TKO_ORACLE_ROOT:-}" ]; then
            for _r in /c/dev/fbc-modern/toolchains/fbc-modern-linux \
                      /mnt/c/dev/fbc-modern/toolchains/fbc-modern-linux; do
                [ -d "$_r" ] && { TKO_ORACLE_ROOT=$_r; break; }
            done
        fi
        if [ -z "${TKO_ORACLE_FBC:-}" ]; then
            if [ -n "${TKO_ORACLE_ROOT:-}" ] && [ -x "$TKO_ORACLE_ROOT/bin/fbc" ]; then
                TKO_ORACLE_FBC=$TKO_ORACLE_ROOT/bin/fbc
            else
                TKO_ORACLE_FBC=$(command -v fbc 2>/dev/null || echo fbc)
            fi
        fi
        : "${TKO_CLANG:=$(command -v clang 2>/dev/null || echo clang)}"
        : "${TKO_AR:=$(command -v llvm-ar 2>/dev/null || command -v ar 2>/dev/null || echo ar)}"
        : "${TKO_NM:=$(command -v llvm-nm 2>/dev/null || command -v nm 2>/dev/null || echo nm)}"
        ;;
esac
export TKO_ORACLE_ROOT TKO_ORACLE_FBC TKO_CLANG TKO_AR TKO_NM

# tko_need_oracle <who> -- exit 77 with a SKIPPED line when the oracle fbc cannot run.
tko_need_oracle( ) {
    if [ ! -x "$TKO_ORACLE_FBC" ] && ! command -v "$TKO_ORACLE_FBC" > /dev/null 2>&1; then
        echo "$1: SKIPPED -- no oracle fbc at $TKO_ORACLE_FBC (set TKO_ORACLE_FBC)"
        exit $TKO_SKIP
    fi
}
