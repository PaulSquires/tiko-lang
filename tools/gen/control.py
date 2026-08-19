#!/usr/bin/env python3
"""Control the cross-version comparison the win32 expectations rest on.

    python tools/gen/control.py

fbc-modern has no 32-bit build, so every win32 truth file is measured with fbc 1.10.1
while the win64 half comes from fbc-modern 1.20.0. That is only sound where the two
RELEASES agree, and this measures whether they do: it regenerates each gate's win64 half
with the 1.10.1 compiler and diffs it against the committed fbc-modern file.

A gate that comes back identical is one where 1.10.1 win32 is usable ground truth. A gate
that does not is one whose win32 expectations mix a target difference with a release
difference, and it says so rather than being quietly trusted.
"""
import filecmp
import shutil
import subprocess
import sys
from pathlib import Path

import fbxtargets

ROOT = Path(__file__).resolve().parents[2]
GEN = ROOT / "tools/gen"

# The generators whose win64 half can be re-measured by pointing FBC elsewhere.
GATES = [
    ("promo", "tests/types/expected/fbc-promotion.txt"),
    ("overload", "tests/types/expected/fbc-overload.txt"),
    ("assign", "tests/types/expected/fbc-assign.txt"),
    ("udt", "tests/types/expected/fbc-udt.txt"),
    ("array", "tests/types/expected/fbc-array.txt"),
    ("conv", "tests/types/expected/fbc-conv.txt"),
    ("callconv", "tests/types/expected/fbc-callconv.txt"),
    ("ptr", "tests/types/expected/fbc-ptr.txt"),
    ("const", "tests/types/expected/fbc-const.txt"),
]


def main() -> int:
    if not fbxtargets.FBC64_OLD.exists():
        print(f"control: no old fbc at {fbxtargets.FBC64_OLD}", file=sys.stderr)
        return 3

    same, differ = [], []
    for gate, rel in GATES:
        committed = ROOT / rel
        if not committed.exists():
            print(f"control: {gate}: no committed expectations", file=sys.stderr)
            continue
        keep = committed.with_suffix(".committed")
        shutil.copyfile(committed, keep)
        try:
            # FBX_CONTROL makes the generator use the OLD 64-bit compiler for win64.
            env = {"FBX_CONTROL_FBC64": str(fbxtargets.FBC64_OLD)}
            proc = subprocess.run(
                [sys.executable, str(GEN / f"{gate}-truth.py")],
                capture_output=True, text=True, cwd=str(ROOT),
                env={**__import__("os").environ, **env})
            if proc.returncode not in (0,):
                print(f"control: {gate}: generator failed\n" + (proc.stderr or ""),
                      file=sys.stderr)
            if filecmp.cmp(committed, keep, shallow=False):
                same.append(gate)
            else:
                differ.append(gate)
        finally:
            shutil.copyfile(keep, committed)
            keep.unlink()

    print(f"control: {len(same)}/{len(same) + len(differ)} gates give the SAME win64 "
          f"answers on fbc 1.10.1 and fbc-modern")
    if same:
        print("control: agree  -> " + ", ".join(same))
    if differ:
        print("control: DIFFER -> " + ", ".join(differ))
        print("control: those gates' win32 expectations mix a target difference with a")
        print("control: release difference; a 32-bit fbc-modern would separate them.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
