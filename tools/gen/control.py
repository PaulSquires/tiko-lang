#!/usr/bin/env python3
"""Does a different fbc RELEASE change any expectation?

    python tools/gen/control.py

Regenerates every gate's truth file with another fbc install and diffs the result
against what is committed, then puts the committed file back. Nothing is left changed.

It exists because the win32 expectations were once measured with fbc 1.10.1, fbc-modern
having had no 32-bit build at the time. This is what said that substitution was sound
before it could be proved: 9 of 9 gates gave identical win64 answers on both releases.
It has since been proved directly -- fbc-modern's own fbc32 reproduces all twelve win32
files byte-for-byte -- and the tool stays for the next toolchain rebuild, when "did
anything change?" is otherwise answered by a gate failing much later.
"""
import filecmp
import os
import shutil
import subprocess
import sys
from pathlib import Path

import fbxtargets

ROOT = Path(__file__).resolve().parents[2]
GEN = ROOT / "tools/gen"

# (generator stem, committed win64 expectations). The win32 file sits beside it and is
# compared too, so one entry covers both targets.
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


def win32_of(p: Path) -> Path:
    return p.with_name(p.stem + "-win32" + p.suffix)


def main() -> int:
    env = dict(os.environ)
    used = []
    if fbxtargets.FBC64_OLD.exists():
        env["FBX_CONTROL_FBC64"] = str(fbxtargets.FBC64_OLD)
        used.append("win64")
    if fbxtargets.FBC32_OLD.exists():
        env["FBX_CONTROL_FBC32"] = str(fbxtargets.FBC32_OLD)
        used.append("win32")
    if not used:
        print(f"control: no other fbc at {fbxtargets.TC_OLD}", file=sys.stderr)
        return 3
    print(f"control: comparing against {fbxtargets.TC_OLD.name} on " + ", ".join(used))

    same, differ = [], []
    for gate, rel in GATES:
        files = [ROOT / rel, win32_of(ROOT / rel)]
        files = [f for f in files if f.exists()]
        if not files:
            print(f"control: {gate}: no committed expectations", file=sys.stderr)
            continue
        saved = []
        for f in files:
            keep = f.with_suffix(".committed")
            shutil.copyfile(f, keep)
            saved.append((f, keep))
        try:
            proc = subprocess.run([sys.executable, str(GEN / f"{gate}-truth.py")],
                                  capture_output=True, text=True, cwd=str(ROOT), env=env)
            if proc.returncode != 0:
                print(f"control: {gate}: generator failed\n" + (proc.stderr or ""),
                      file=sys.stderr)
            for f, keep in saved:
                label = f"{gate}/win32" if f.name.endswith("-win32.txt") else f"{gate}/win64"
                (same if filecmp.cmp(f, keep, shallow=False) else differ).append(label)
        finally:
            for f, keep in saved:
                shutil.copyfile(keep, f)
                keep.unlink()

    total = len(same) + len(differ)
    print(f"control: {len(same)}/{total} expectation files are IDENTICAL across releases")
    if differ:
        print("control: DIFFER -> " + ", ".join(differ))
        print("control: a release changed an answer; read the diff before regenerating.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
