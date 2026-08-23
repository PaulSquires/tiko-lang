"""The targets every gate measures against, in one place.

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

TC = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows")

# TKO_CONTROL_FBC64 / _FBC32 point one half at a different compiler, which is how
# control.py measures whether two releases agree. Nothing else sets them.
FBC64 = Path(os.environ.get("TKO_CONTROL_FBC64", str(TC / "fbc64.exe")))
FBC32 = Path(os.environ.get("TKO_CONTROL_FBC32", str(TC / "fbc32.exe")))

# The previous release, for control.py to compare against. Any fbc install would serve.
TC_OLD = Path(r"C:\dev\tiko_editor\toolchains\FreeBASIC-1.10.1-winlibs-gcc-9.3.0")
FBC64_OLD = TC_OLD / "fbc64.exe"
FBC32_OLD = TC_OLD / "fbc32.exe"


def truth_targets(out, work):
    """(label, fbc, out, work) per target, given the win64 paths.

    The win32 expectations sit beside the win64 ones as '<name>-win32.txt', and each
    target gets its own scratch directory so a half-finished run of one cannot be read
    as the other.
    """
    return [
        ("win64", FBC64, out, work),
        ("win32", FBC32, out.with_name(out.stem + "-win32" + out.suffix),
         work.with_name(work.name + "32")),
    ]


def check_targets(truth):
    """(label, truth, tiko-lang-args) per target, given the win64 truth path."""
    return [
        ("win64", truth, []),
        ("win32", truth.with_name(truth.stem + "-win32" + truth.suffix),
         ["-target", "win32"]),
    ]
