#!/usr/bin/env python3
"""Compare tiko-lang's float rendering with the text fbc's STR( ) produces.

    python tools/gen/check-str.py

Truth from tools/gen/str-truth.py, which measured every row by compiling and RUNNING a
probe -- and which separately proved, on both targets, that fbc's compile-time DATA
folding renders a float identically to its runtime STR( ). That is the fact this gate is
protecting: `data 1.5` is stored as the TEXT "1.5", so a rendering difference is a READ
that returns a different number with nothing to say so.

tiko-lang's side comes from tools/gen/strfmt.bas, compiled against src/support/fbstr.bas with
the stage0 compiler -- the one build/build.sh uses, so the renderer is measured as the shipped
compiler has it: the seed. Rows are keyed by BIT PATTERN, so
neither side's literal parser can get into the measurement.

THE GATE IS EXACT AND FAILS ON A SINGLE MISMATCH.

It was not always. Until 2026-09-04 win32 was measured too and DELIBERATELY not
matched: fbc32 folds DATA with the legacy msvcrt renderer -- three-digit exponents,
'1.#INF' / '1.#QNAN' / '-1.#IND' for the specials, ties rounded half-AWAY-from-zero,
and a residue of last-digit errors following no rule that could be reimplemented. The
gate bucketed that shortfall rather than fitting to it. x86-64 is now the only
architecture (D14), so the exception, its classifier and its buckets are gone and
every supported target is held to the exact standard.
"""
import os
import re
import struct
import subprocess
import sys
from pathlib import Path

import tkotargets

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/expected/fbc-str.txt"
WORK = ROOT / "build/.str"


def stage0():
    """(compiler, is_tiko): TKO_SEED, else build/defaultseed.sh's
    pick -- the order build/build.sh chooses in, so the probe and the compiler agree."""
    if os.environ.get("TKO_SEED"):
        return Path(os.environ["TKO_SEED"]), True
    r = subprocess.run(["sh", "-c", '. build/defaultseed.sh && default_seed "$PWD" %s'
                        % ("1" if os.name == "nt" else "0")],
                       cwd=ROOT, capture_output=True, text=True)
    if r.returncode != 0 or not r.stdout.strip():
        return None, True
    return Path(r.stdout.strip()), True


def rows(path):
    out = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            kind, bits, text = line.split("\t", 2)
            out.append((kind, bits, text))
    return out


def build():
    WORK.mkdir(parents=True, exist_ok=True)
    exe = WORK / "strfmt.exe"
    if exe.exists():
        # A stale .exe yields a believable number, never an error.
        exe.unlink()
    cc, is_tiko = stage0()
    if cc is None:
        print("check-str: no seed compiler (seed/fetch-seed.sh, or TKO_SEED)",
              file=sys.stderr)
        return None
    args = [str(cc), str(ROOT / "tools/gen/strfmt.bas"), str(ROOT / "src/support/fbstr.bas"),
            "-i", str(ROOT / "src")]
    env = dict(os.environ)
    if is_tiko:
        # The seed's own spelling, and the tree's headers -- as build.sh gives them.
        args += ["-o", str(exe)]
        env["TKO_INCLUDE"] = str(ROOT / "inc")
    else:
        args += ["-i", str(ROOT / "inc"), "-w", "all", "-x", str(exe)]
    r = subprocess.run(args, capture_output=True, text=True, env=env)
    if r.returncode != 0 or not exe.exists():
        print("check-str: could not build the formatter probe\n%s%s"
              % (r.stdout, r.stderr), file=sys.stderr)
        return None
    if r.stdout.strip() or r.stderr.strip():
        print("check-str: stage0 warnings building the probe:")
        print(r.stdout + r.stderr)
    return exe


def tiko_rows(exe, truth):
    r = subprocess.run([str(exe), str(truth)], capture_output=True, text=True)
    if r.returncode != 0:
        print("check-str: formatter probe exited %d\n%s" % (r.returncode, r.stdout),
              file=sys.stderr)
        return None
    out = []
    for line in r.stdout.splitlines():
        if line.strip():
            kind, bits, text = line.split("\t", 2)
            out.append((kind, bits, text))
    return out


def main() -> int:
    if not TRUTH.exists():
        print("check-str: no truth file; run tools/gen/str-truth.py", file=sys.stderr)
        return 3
    cc, _ = stage0()
    if cc is None or not cc.exists():
        print("check-str: stage0 compiler not found (%s)" % (cc or "no seed"), file=sys.stderr)
        return 3
    exe = build()
    if exe is None:
        return 3
    got = tiko_rows(exe, TRUTH)
    if got is None:
        return 3

    rc = 0
    for label, truth, _ in tkotargets.check_targets(TRUTH):
        if not truth.exists():
            print("check-str: %s: no truth file; run tools/gen/str-truth.py" % label,
                  file=sys.stderr)
            return 3
        want = rows(truth)
        if len(want) != len(got):
            print("check-str: %s: %d truth rows against %d from tiko-lang -- the two truth "
                  "files are out of step" % (label, len(want), len(got)),
                  file=sys.stderr)
            return 3

        bad = [(w[0], w[1], w[2], g[2]) for w, g in zip(want, got) if w[2] != g[2]]
        n = len(want)
        print("check-str: %s %d/%d renderings identical to fbc" % (label, n - len(bad), n))
        for _, bits, w, g in bad[:20]:
            print("    %s  fbc=%s  tiko-lang=%s" % (bits, w, g))
        if bad:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
