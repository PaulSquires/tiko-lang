#!/usr/bin/env python3
"""Regenerate tests/expected/fbc-str.txt -- the exact TEXT fbc's STR() gives a float.

    python tools/gen/str-truth.py

tiko-lang must reproduce this rendering at COMPILE TIME. `data 1.5` is constant-folded by fbc
and stored as the TEXT "1.5" (docs/internals/phase-6-print-using-and-data.md, "Item
values are constant-folded and re-rendered as text"), so a READ of a float datum
diverges the moment tiko-lang renders a digit differently.

Measured, not transcribed. Two probes are compiled and RUN:

  1. the STR() probe -- values fed in as BIT PATTERNS, never as decimal literals, so a
     row measures fbc's FORMATTER and can never measure its literal parser instead.
     That also lets a positive quiet NaN and both infinities be named exactly, which no
     literal can do.
  2. the DATA probe -- the same values written as source literals, folded by fbc into
     DATA text, and READ back at run time. That is the rendering tiko-lang actually has to
     match; the STR() probe is only usable as truth because this one proves the two
     agree.

Both targets are measured, as every other gate does. win32's rows land in
fbc-str-win32.txt.

WHAT THIS MEASUREMENT COST, recorded because it changes what the answer means: fbc
1.10.1 and fbc-modern DISAGREE on this rendering -- 1.10.1 writes three-digit exponents
('1e-020'), '1.#INF' and '-1.#IND', and rounds the last digit differently in several
rows. So "fbc's STR()" is not one thing. The truth of record here is fbc-modern, which
is what every other gate in this tree measures against.
"""
import math
import random
import struct
import subprocess
import sys
from pathlib import Path

import tkotargets

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "tests/expected/fbc-str.txt"
WORK = ROOT / "build/.str"


def dbits(x):
    return struct.unpack("<Q", struct.pack("<d", x))[0]


def sbits(x):
    return struct.unpack("<I", struct.pack("<f", x))[0]


def doubles():
    """Bit patterns for the double set. Adversarial by construction, not by sampling."""
    v = [0.0, -0.0, 1.0, -1.0, 0.1, 0.2, 0.3, 1.0 / 3.0, 2.0 / 3.0, 1.5, -1.5, 2.5,
         0.5, 0.0001, 0.00001, 3.14159265358979, 2.718281828459045, 0.1 + 0.2]
    # every exact power of ten the type can hold, both signs of exponent
    for e in range(-320, 309):
        v.append(float("1e%d" % e))
    # the fixed/exponential boundary, and either side of it
    for e in range(13, 20):
        v.append(float("1e%d" % e))
        v.append(float("9.999999999999999e%d" % e))
    for e in range(-30, 31):
        v.append(float("-1e%d" % e))
        v.append(float("1.2345678901234567e%d" % e))
        v.append(float("9.999999999999999e%d" % e))
    # integers stored in doubles, including the exactly-representable ceiling
    for n in [1, 2, 3, 7, 9, 10, 15, 16, 17, 99, 100, 123456789,
              10 ** 15, 10 ** 16, 10 ** 17, 2 ** 53, 2 ** 53 + 2, 2 ** 62]:
        v.append(float(n))
        v.append(-float(n))
    # denormals, the normal/subnormal boundary, and the extremes
    v += [5e-324, 1e-323, 2.2250738585072014e-308, 2.225073858507201e-308,
          1.7976931348623157e308, 123456789012345678.0, 1e21, 1e22, 1e23]
    # EXACT TIES. m * 2^-k has a terminating decimal expansion, so these are the rows
    # where the 17th significant digit is a 5 with nothing after it -- the only rows
    # that can tell round-half-even from round-half-down. 2^-23 and 2^-24 give 17-digit
    # expansions; odd and even multipliers put an odd and an even digit before the tie.
    for k in (23, 24, 26, 27):
        for m in (1, 3, 5, 7, 9, 11, 13):
            v.append(float(m) * 2.0 ** -k)
    random.seed(7)
    for _ in range(150):
        d = struct.unpack("<d", struct.pack("<Q", random.getrandbits(64)))[0]
        if not math.isnan(d):
            v.append(d)
    for _ in range(80):
        v.append(random.uniform(-1e6, 1e6))
        v.append(random.uniform(-1.0, 1.0))
    bits = []
    seen = set()
    for x in v:
        b = dbits(x)
        if b not in seen:
            seen.add(b)
            bits.append(b)
    # inf, -inf, and BOTH NaNs. A literal cannot name a positive quiet NaN, which is
    # why the probe is fed bits: '0.0/0.0' produces the negative one and a probe built
    # from expressions would leave the positive one unmeasured.
    for b in (0x7FF0000000000000, 0xFFF0000000000000,
              0x7FF8000000000000, 0xFFF8000000000000,
              0x7FF0000000000001, 0x7FFFFFFFFFFFFFFF):
        if b not in seen:
            seen.add(b)
            bits.append(b)
    return bits


def singles():
    v = [0.0, -0.0, 1.0, -1.0, 0.1, 1.0 / 3.0, 16777217.0, 16777216.0, 1e-20, 1.5, 0.5]
    for e in range(-45, 39):
        v.append(struct.unpack("<f", struct.pack("<f", float("1e%d" % e)))[0])
    for n in [1, 2, 3, 7, 9, 10, 99, 123456, 10 ** 6, 10 ** 7, 10 ** 8,
              2 ** 24, 2 ** 24 + 2, 2 ** 30]:
        v.append(float(n))
        v.append(-float(n))
    v += [1.4012984643e-45, 1.1754943508e-38, 1.1754942107e-38, 3.4028234663852886e38]
    # exact ties at the 8th significant digit -- see the note in doubles()
    for k in (9, 10, 11, 13, 14):
        for m in (1, 3, 5, 7, 9, 11):
            v.append(float(m) * 2.0 ** -k)
    random.seed(11)
    for _ in range(150):
        f = struct.unpack("<f", struct.pack("<I", random.getrandbits(32)))[0]
        if not math.isnan(f):
            v.append(f)
    bits = []
    seen = set()
    for x in v:
        try:
            b = sbits(x)
        except OverflowError:
            continue
        if b not in seen:
            seen.add(b)
            bits.append(b)
    for b in (0x7F800000, 0xFF800000, 0x7FC00000, 0xFFC00000, 0x7F800001):
        if b not in seen:
            seen.add(b)
            bits.append(b)
    return bits


def str_probe(dl, sl):
    """A probe that formats BIT PATTERNS. No decimal literal appears in it."""
    L = ["dim as ulongint qd",
         "dim as ulong qs",
         "dim as double d",
         "dim as single s"]
    for b in dl:
        L.append("qd = &h%016Xull : d = *cptr( double ptr, @qd )" % b)
        L.append('print "d" + chr(9) + hex( qd, 16 ) + chr(9) + str( d )')
    for b in sl:
        L.append("qs = &h%08Xul : s = *cptr( single ptr, @qs )" % b)
        L.append('print "s" + chr(9) + hex( qs, 8 ) + chr(9) + str( s )')
    return "\n".join(L) + "\n"


def dlit(x):
    """A source literal for a double, or None where no literal can name the value."""
    if math.isnan(x) or math.isinf(x):
        return None
    r = repr(x)
    if r in ("0.0", "-0.0"):
        return "-0.0d" if math.copysign(1.0, x) < 0 else "0.0d"
    if "e" in r:
        m, e = r.split("e")
        if "." not in m:
            m += ".0"
        return "%sd%s%d" % (m, "+" if int(e) >= 0 else "-", abs(int(e)))
    if "." not in r:
        r += ".0"
    return r + "d"


def slit(x):
    if math.isnan(x) or math.isinf(x):
        return None
    r = repr(struct.unpack("<f", struct.pack("<f", x))[0])
    if r in ("0.0", "-0.0"):
        return "-0.0f" if math.copysign(1.0, x) < 0 else "0.0f"
    if "e" in r:
        m, e = r.split("e")
        if "." not in m:
            m += ".0"
        # 'e' is the exponent marker and 'f' the SUFFIX. Written as '1.5f-21' the 'f'
        # ends the number and the rest reads as a subtraction -- fbc accepts it and
        # DATA silently records the difference.
        return "%se%s%df" % (m, "+" if int(e) >= 0 else "-", abs(int(e)))
    if "." not in r:
        r += ".0"
    return r + "f"


def data_probe(rows):
    """DATA lines fbc folds at compile time, read back and compared to runtime STR().

    Both sides are fed the SAME literal, so the two compile-time literal-to-float
    conversions cancel. Comparing the folded text against a truth row measured from
    BIT PATTERNS instead would fail wherever fbc's literal parser and its runtime
    strtod disagree -- they do, on win32, for subnormals -- and that is a different
    question from the one this cross-check is asking.
    """
    L = ["dim as string t", "dim as double dv", "dim as single sv"]
    for _, lit, _ in rows:
        L.append("data " + lit)
    for _, lit, kind in rows:
        var = "dv" if kind == "d" else "sv"
        L.append("read t : %s = %s : print t + chr(9) + str( %s )" % (var, lit, var))
    return "\n".join(L) + "\n"


def run(fbc, work, name, src, extra):
    work.mkdir(parents=True, exist_ok=True)
    bas = work / (name + ".bas")
    exe = work / (name + ".exe")
    bas.write_text(src, encoding="utf-8", newline="\n")
    if exe.exists():
        # A stale .exe yields a believable number, never an error.
        exe.unlink()
    r = subprocess.run([str(fbc)] + extra + [str(bas), "-x", str(exe)],
                       capture_output=True, text=True)
    if r.returncode != 0 or not exe.exists():
        print("str-truth: fbc failed on %s\n%s%s" % (bas, r.stdout, r.stderr),
              file=sys.stderr)
        return None
    r = subprocess.run([str(exe)], capture_output=True, text=True)
    if r.returncode != 0:
        print("str-truth: %s exited %d" % (exe, r.returncode), file=sys.stderr)
        return None
    return [ln.rstrip("\r\n") for ln in r.stdout.splitlines()]


def literal_rows(dl, sl, rows):
    """(expected text, literal, kind) for every value a source literal can name."""
    out = []
    for i, b in enumerate(dl):
        x = struct.unpack("<d", struct.pack("<Q", b))[0]
        lit = dlit(x)
        if lit is not None:
            out.append((rows[i][2], lit, "d"))
    for j, b in enumerate(sl):
        f = struct.unpack("<f", struct.pack("<I", b))[0]
        lit = slit(f)
        if lit is not None:
            out.append((rows[len(dl) + j][2], lit, "s"))
    return out


def one_target(label, fbc, out, work, extra):
    dl, sl = doubles(), singles()
    lines = run(fbc, work, "strprobe", str_probe(dl, sl), extra)
    if lines is None:
        return 3
    rows = [tuple(ln.split("\t", 2)) for ln in lines]
    if len(rows) != len(dl) + len(sl):
        print("str-truth: %s: probe produced %d rows, wanted %d"
              % (label, len(rows), len(dl) + len(sl)), file=sys.stderr)
        return 3

    # Cross-check: the DATA folding tiko-lang must match, against the STR() recorded here.
    lits = literal_rows(dl, sl, rows)
    folded = run(fbc, work, "dataprobe", data_probe(lits), extra)
    if folded is None:
        return 3
    if len(folded) != len(lits):
        print("str-truth: %s: DATA probe produced %d rows, wanted %d"
              % (label, len(folded), len(lits)), file=sys.stderr)
        return 3
    bad = []
    for (_, lit, _), g in zip(lits, folded):
        fold, live = g.split("\t", 1)
        if fold != live:
            bad.append((lit, live, fold))
    print("str-truth: %s DATA folding matches STR() on %d/%d literals"
          % (label, len(lits) - len(bad), len(lits)))
    for lit, w, g in bad[:20]:
        print("   %s: STR()=%s  DATA=%s" % (lit, w, g))

    out.write_text("".join("%s\t%s\t%s\n" % r for r in rows),
                   encoding="utf-8", newline="\n")
    print("str-truth: %s wrote %d rows to %s" % (label, len(rows), out.name))
    return 0 if not bad else 1


def main() -> int:
    rc = 0
    for label, fbc, out, work in tkotargets.truth_targets(OUT, WORK):
        # fbc32 defaults to -gen gas; every other truth generator here pins -gen gcc
        # for the same reason.
        extra = ["-gen", "gcc"] if label == "win32" else []
        if one_target(label, fbc, out, work, extra) != 0:
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
