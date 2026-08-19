"""The targets every gate measures against, in one place.

Imported by the tools/gen truth generators and checkers. They run as scripts from this
directory, so a plain 'import fbxtargets' finds it.

win32 comes from a DIFFERENT fbc, because fbc-modern has no 32-bit build. That is a
cross-version comparison and it is controlled rather than assumed: 'control.py' runs
each generator's win64 half through the 1.10.1 compiler and diffs it against the
fbc-modern file. Where the two agree, 1.10.1 win32 is usable ground truth; where they do
not, the win32 expectations say so.
"""
import os
from pathlib import Path

TC64 = Path(r"C:\dev\fbc-modern\toolchains\fbc-modern-windows")
TC32 = Path(r"C:\dev\tiko_editor\toolchains\FreeBASIC-1.10.1-winlibs-gcc-9.3.0")

# FBX_CONTROL_FBC64 points the win64 half at a different compiler, which is how
# control.py measures whether the two releases agree. Nothing else sets it.
FBC64 = Path(os.environ.get("FBX_CONTROL_FBC64", str(TC64 / "fbc64.exe")))
FBC32 = TC32 / "fbc32.exe"

# The 1.10.1 64-bit compiler, used only to CONTROL the cross-version comparison.
FBC64_OLD = TC32 / "fbc64.exe"


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
    """(label, truth, fbx-args) per target, given the win64 truth path."""
    return [
        ("win64", truth, []),
        ("win32", truth.with_name(truth.stem + "-win32" + truth.suffix),
         ["-target", "win32"]),
    ]
