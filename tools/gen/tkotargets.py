"""The targets every gate measures against, in one place.

X86-64 IS THE ARCHITECTURE (D14). win32 was removed 2026-09-04 -- these two
functions returned a win64/win32 pair, and shrinking them here is what removed it
from every Python gate at once. FBC32 is kept below because control.py uses it to
compare fbc RELEASES, which is a different question from which targets are built.

Imported by the tools/gen truth generators and checkers. They run as scripts from this
directory, so a plain 'import tkotargets' finds it.

Both targets now come from ONE fbc release, which they did not always: fbc-modern had no
32-bit build for a while and the win32 expectations were measured with fbc 1.10.1
instead. Re-measuring them against fbc-modern's own fbc32 changed nothing -- all twelve
files came back byte-identical -- so that substitution was sound. It is recorded because
it was believed on evidence before it was proved.

'control.py' produced that evidence and stays as a release-difference detector: it
regenerates every expectation with a DIFFERENT fbc and reports what moved. Worth running
after a toolchain rebuild, when "did anything change?" is otherwise answered by a gate
failing much later.
"""
import os
from pathlib import Path

# THE ORACLE, as build/toolchain.sh resolves it: TIKO_ORACLE_ROOT / TIKO_ORACLE_FBC win.
TC = Path(os.environ.get("TIKO_ORACLE_ROOT", r"C:\dev\fbc-modern\toolchains\fbc-modern-windows"))

# TIKO_CONTROL_FBC64 / _FBC32 point one half at a different compiler, which is how
# control.py measures whether two releases agree. Nothing else sets them.
FBC64 = Path(os.environ.get("TIKO_CONTROL_FBC64", os.environ.get("TIKO_ORACLE_FBC", str(TC / "fbc64.exe"))))

# THE SKIP CODE, build/toolchain.sh's: a truth script with no oracle to ask exits with it,
# and check-all reports SKIPPED rather than a failure (review BLD-12).
SKIP = 77
FBC32 = Path(os.environ.get("TIKO_CONTROL_FBC32", str(TC / "fbc32.exe")))

# The previous release, for control.py to compare against. Any fbc install would serve.
TC_OLD = Path(r"C:\dev\tiko_editor\toolchains\FreeBASIC-1.10.1-winlibs-gcc-9.3.0")
FBC64_OLD = TC_OLD / "fbc64.exe"
FBC32_OLD = TC_OLD / "fbc32.exe"


def truth_targets(out, work):
    """(label, fbc, out, work) per target, given the win64 paths.

    ONE ENTRY since win32 was removed. The shape is kept as a list because it is what
    every caller iterates, and because ARM64 would be a second entry rather than a
    rewrite -- see tiko-rt RFC-0007 section 9.
    """
    return [
        ("win64", FBC64, out, work),
    ]


def check_targets(truth):
    """(label, truth, tiko-lang-args) per target, given the win64 truth path."""
    return [
        ("win64", truth, []),
    ]
