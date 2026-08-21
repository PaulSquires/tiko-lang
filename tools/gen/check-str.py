#!/usr/bin/env python3
"""Compare fbx's float rendering with the text fbc's STR( ) produces.

    python tools/gen/check-str.py

Truth from tools/gen/str-truth.py, which measured every row by compiling and RUNNING a
probe -- and which separately proved, on both targets, that fbc's compile-time DATA
folding renders a float identically to its runtime STR( ). That is the fact this gate is
protecting: `data 1.5` is stored as the TEXT "1.5", so a rendering difference is a READ
that returns a different number with nothing to say so.

fbx's side comes from tools/gen/strfmt.bas, compiled against src/support/fbstr.bas with
the stage0 compiler. Rows are keyed by BIT PATTERN, so neither side's literal parser can
get into the measurement.

win64 is EXACT and this gate fails on a single mismatch.

win32 IS NOT, deliberately, and the shortfall is named rather than fitted away. fbc32
folds DATA with the legacy msvcrt renderer: three-digit exponents, '1.#INF' / '1.#QNAN'
/ '-1.#IND' for the specials, ties rounded half-AWAY-from-zero rather than half-to-even,
and a residue of last-digit errors that come from an internal 17-digit intermediate and
follow no rule that could be reimplemented. fbx renders one way on both targets; the
count below says exactly what that costs, and the breakdown says which part of it is a
rule fbx could adopt and which part is msvcrt being wrong.
"""
import re
import struct
import subprocess
import sys
from decimal import Context, Decimal, ROUND_HALF_EVEN, ROUND_HALF_UP
from pathlib import Path

import fbxtargets

ROOT = Path(__file__).resolve().parents[2]
TRUTH = ROOT / "tests/expected/fbc-str.txt"
WORK = ROOT / "build/.str"
STAGE0 = fbxtargets.TC / "fbc64.exe"


def rows(path):
    out = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.strip():
            kind, bits, text = line.split("\t", 2)
            out.append((kind, bits, text))
    return out


def two_digit_exponent(t):
    m = re.match(r"^(.*)e([+-])0*(\d+)$", t)
    if not m:
        return t
    return "%se%s%02d" % (m.group(1), m.group(2), int(m.group(3)))


def build():
    WORK.mkdir(parents=True, exist_ok=True)
    exe = WORK / "strfmt.exe"
    if exe.exists():
        # A stale .exe yields a believable number, never an error.
        exe.unlink()
    r = subprocess.run([str(STAGE0),
                        str(ROOT / "tools/gen/strfmt.bas"),
                        str(ROOT / "src/support/fbstr.bas"),
                        "-i", str(ROOT / "src"), "-w", "all",
                        "-x", str(exe)],
                       capture_output=True, text=True)
    if r.returncode != 0 or not exe.exists():
        print("check-str: could not build the formatter probe\n%s%s"
              % (r.stdout, r.stderr), file=sys.stderr)
        return None
    if r.stdout.strip() or r.stderr.strip():
        print("check-str: stage0 warnings building the probe:")
        print(r.stdout + r.stderr)
    return exe


def fbx_rows(exe, truth):
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


SPECIALS = ("#INF", "#QNAN", "#IND")


def half_up(bits, kind):
    """The row's exact expansion rounded half-AWAY-from-zero, or None if not a tie.

    Decimal(float) is the exact value, so this distinguishes 'fbc32 uses a different
    tie rule' -- which IS a rule, and one fbx could adopt if win32 ever had to match --
    from 'msvcrt got the last digit wrong', which is not.
    """
    if kind == "d":
        x = struct.unpack("<d", struct.pack("<Q", int(bits, 16)))[0]
        prec = 16
    else:
        x = struct.unpack("<f", struct.pack("<I", int(bits, 16)))[0]
        prec = 7
    exact = Decimal(x)
    ctx = Context(prec=prec, rounding=ROUND_HALF_EVEN)
    even = ctx.plus(exact)
    ctx.rounding = ROUND_HALF_UP
    away = ctx.plus(exact)
    return None if even == away else away


def digits_of(t):
    """The significant digits of a rendering, with sign, point and exponent removed."""
    d = t.split("e")[0].lstrip("-").replace(".", "").lstrip("0")
    return d.rstrip("0") or "0"


def classify(bits, kind, want, got):
    """Which of win32's known departures a row belongs to."""
    if any(s in want for s in SPECIALS):
        return "specials spelled the msvcrt way"
    if two_digit_exponent(want) == two_digit_exponent(got):
        return "exponent padded to three digits"
    away = half_up(bits, kind)
    away_digits = ("".join(str(x) for x in away.as_tuple().digits).rstrip("0") or "0"
                   ) if away is not None else None
    if away_digits is not None and away_digits == digits_of(want):
        return "exact tie rounded half-AWAY-from-zero, not half-to-even"
    return "msvcrt's last digit, no rule behind it"


def main() -> int:
    if not TRUTH.exists():
        print("check-str: no truth file; run tools/gen/str-truth.py", file=sys.stderr)
        return 3
    if not STAGE0.exists():
        print("check-str: stage0 compiler not found at %s" % STAGE0, file=sys.stderr)
        return 3
    exe = build()
    if exe is None:
        return 3
    got = fbx_rows(exe, TRUTH)
    if got is None:
        return 3

    rc = 0
    for label, truth, _ in fbxtargets.check_targets(TRUTH):
        if not truth.exists():
            print("check-str: %s: no truth file; run tools/gen/str-truth.py" % label,
                  file=sys.stderr)
            return 3
        want = rows(truth)
        if len(want) != len(got):
            print("check-str: %s: %d truth rows against %d from fbx -- the two truth "
                  "files are out of step" % (label, len(want), len(got)),
                  file=sys.stderr)
            return 3

        bad = [(w[0], w[1], w[2], g[2]) for w, g in zip(want, got) if w[2] != g[2]]
        n = len(want)
        if label == "win64":
            print("check-str: win64 %d/%d renderings identical to fbc" % (n - len(bad), n))
            for _, bits, w, g in bad[:20]:
                print("    %s  fbc=%s  fbx=%s" % (bits, w, g))
            if bad:
                rc = 1
        else:
            print("check-str: win32 %d/%d identical; the %d that are not are fbc32's "
                  "legacy msvcrt renderer, NOT reproduced (see the module header)"
                  % (n - len(bad), n, len(bad)))
            buckets = {}
            for kind, bits, w, g in bad:
                buckets.setdefault(classify(bits, kind, w, g), []).append((bits, w, g))
            for name in sorted(buckets, key=lambda k: -len(buckets[k])):
                rowset = buckets[name]
                bits, w, g = rowset[0]
                print("    %5d  %s   e.g. %s fbc32=%s fbx=%s"
                      % (len(rowset), name, bits, w, g))
    return rc


if __name__ == "__main__":
    sys.exit(main())
