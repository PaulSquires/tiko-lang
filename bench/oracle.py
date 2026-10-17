"""Reference outputs for the Benchmarks Game programs, computed in Python.

Each function returns the exact bytes a program must print for one size. The
programs in game/ must match these byte for byte. Python floats are IEEE
doubles evaluated in source order, so the floating-point programs here follow
the same arithmetic order as the ports.

Small sizes are cheap enough for every program. At full size only the programs
with a closed form or a fast method are computed here (binary-trees,
fannkuch-redux at 12, n-body, spectral-norm, pidigits); the rest are checked by
agreement between the five languages.
"""

import math
import re
import sys

if hasattr(sys, "set_int_max_str_digits"):
    sys.set_int_max_str_digits(0)

# ----------------------------------------------------------------------- fasta

ALU = ("GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
       "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
       "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
       "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
       "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
       "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
       "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA")

IUB = [("a", 0.27), ("c", 0.12), ("g", 0.12), ("t", 0.27),
       ("B", 0.02), ("D", 0.02), ("H", 0.02), ("K", 0.02),
       ("M", 0.02), ("N", 0.02), ("R", 0.02), ("S", 0.02),
       ("V", 0.02), ("W", 0.02), ("Y", 0.02)]

HOMOSAPIENS = [("a", 0.3029549426680), ("c", 0.1979883004921),
               ("g", 0.1975473066391), ("t", 0.3015094502008)]

LINE = 60


def fasta(n):
    out = []
    seed = [42]

    def rand():
        seed[0] = (seed[0] * 3877 + 29573) % 139968
        return 1.0 * seed[0] / 139968

    def repeat(s, count):
        doubled = s + s[:LINE]
        pos = 0
        while count > 0:
            line = min(count, LINE)
            out.append(doubled[pos:pos + line] + "\n")
            pos += line
            if pos > len(s):
                pos -= len(s)
            count -= line

    def random(table, count):
        cum = []
        p = 0.0
        for _, prob in table:
            p += prob
            cum.append(p)
        chars = [c for c, _ in table]
        last = len(chars) - 1
        while count > 0:
            line = min(count, LINE)
            buf = []
            for _ in range(line):
                r = rand()
                j = 0
                while j < last and r >= cum[j]:
                    j += 1
                buf.append(chars[j])
            out.append("".join(buf) + "\n")
            count -= line

    out.append(">ONE Homo sapiens alu\n")
    repeat(ALU, n * 2)
    out.append(">TWO IUB ambiguity codes\n")
    random(IUB, n * 3)
    out.append(">THREE Homo sapiens frequency\n")
    random(HOMOSAPIENS, n * 5)
    return "".join(out).encode()


# ----------------------------------------------------------------- binary-trees

def binary_trees(n):
    # Every tree of depth d is perfect, so its check is 2^(d+1) - 1.
    def check(d):
        return (1 << (d + 1)) - 1

    min_depth = 4
    max_depth = max(min_depth + 2, n)
    stretch = max_depth + 1
    out = ["stretch tree of depth %d\t check: %d\n" % (stretch, check(stretch))]
    for d in range(min_depth, max_depth + 1, 2):
        iters = 1 << (max_depth - d + min_depth)
        out.append("%d\t trees of depth %d\t check: %d\n" % (iters, d, iters * check(d)))
    out.append("long lived tree of depth %d\t check: %d\n" % (max_depth, check(max_depth)))
    return "".join(out).encode()


# --------------------------------------------------------------- fannkuch-redux

def fannkuch_redux(n):
    if n == 12:
        return b"3968050\nPfannkuchen(12) = 65\n"
    if n > 9:
        return None
    perm1 = list(range(n))
    count = [0] * n
    max_flips = 0
    checksum = 0
    perm_count = 0
    r = n
    while True:
        while r != 1:
            count[r - 1] = r
            r -= 1
        perm = perm1[:]
        flips = 0
        k = perm[0]
        while k != 0:
            perm[:k + 1] = perm[k::-1]
            flips += 1
            k = perm[0]
        max_flips = max(max_flips, flips)
        checksum += flips if perm_count % 2 == 0 else -flips
        while True:
            if r == n:
                return ("%d\nPfannkuchen(%d) = %d\n" % (checksum, n, max_flips)).encode()
            perm0 = perm1[0]
            perm1[:r] = perm1[1:r + 1]
            perm1[r] = perm0
            count[r] -= 1
            if count[r] > 0:
                break
            r += 1
        perm_count += 1


# ------------------------------------------------------------------- mandelbrot

def mandelbrot(n):
    if n > 1000:
        return None
    w = h = n
    out = bytearray(b"P4\n%d %d\n" % (w, h))
    for y in range(h):
        ci = 2.0 * y / h - 1.0
        byte = 0
        bits = 0
        for x in range(w):
            cr = 2.0 * x / w - 1.5
            zr = zi = tr = ti = 0.0
            i = 0
            while i < 50 and tr + ti <= 4.0:
                zi = (zr + zr) * zi + ci
                zr = tr - ti + cr
                tr = zr * zr
                ti = zi * zi
                i += 1
            byte = (byte << 1) | (1 if tr + ti <= 4.0 else 0)
            bits += 1
            if bits == 8:
                out.append(byte)
                byte = 0
                bits = 0
        if bits:
            out.append((byte << (8 - bits)) & 0xFF)
    return bytes(out)


# ----------------------------------------------------------------------- n-body

def n_body(n):
    if n == 50000000:
        return b"-0.169075164\n-0.169059907\n"
    pi = 3.141592653589793
    solar_mass = 4 * pi * pi
    days = 365.24
    bodies = [
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, solar_mass],
        [4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
         1.66007664274403694e-03 * days, 7.69901118419740425e-03 * days,
         -6.90460016972063023e-05 * days, 9.54791938424326609e-04 * solar_mass],
        [8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
         -2.76742510726862411e-03 * days, 4.99852801234917238e-03 * days,
         2.30417297573763929e-05 * days, 2.85885980666130812e-04 * solar_mass],
        [1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
         2.96460137564761618e-03 * days, 2.37847173959480950e-03 * days,
         -2.96589568540237556e-05 * days, 4.36624404335156298e-05 * solar_mass],
        [1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
         2.68067772490389322e-03 * days, 1.62824170038242295e-03 * days,
         -9.51592254519715870e-05 * days, 5.15138902046611451e-05 * solar_mass],
    ]
    nb = len(bodies)

    def energy():
        e = 0.0
        for i in range(nb):
            b = bodies[i]
            e += 0.5 * b[6] * (b[3] * b[3] + b[4] * b[4] + b[5] * b[5])
            for j in range(i + 1, nb):
                c = bodies[j]
                dx = b[0] - c[0]
                dy = b[1] - c[1]
                dz = b[2] - c[2]
                e -= (b[6] * c[6]) / math.sqrt(dx * dx + dy * dy + dz * dz)
        return e

    px = py = pz = 0.0
    for b in bodies:
        px += b[3] * b[6]
        py += b[4] * b[6]
        pz += b[5] * b[6]
    bodies[0][3] = -px / solar_mass
    bodies[0][4] = -py / solar_mass
    bodies[0][5] = -pz / solar_mass

    out = ["%.9f\n" % energy()]
    dt = 0.01
    for _ in range(n):
        for i in range(nb):
            b = bodies[i]
            for j in range(i + 1, nb):
                c = bodies[j]
                dx = b[0] - c[0]
                dy = b[1] - c[1]
                dz = b[2] - c[2]
                d2 = dx * dx + dy * dy + dz * dz
                mag = dt / (d2 * math.sqrt(d2))
                bm = b[6] * mag
                cm = c[6] * mag
                b[3] -= dx * cm
                b[4] -= dy * cm
                b[5] -= dz * cm
                c[3] += dx * bm
                c[4] += dy * bm
                c[5] += dz * bm
        for b in bodies:
            b[0] += dt * b[3]
            b[1] += dt * b[4]
            b[2] += dt * b[5]
    out.append("%.9f\n" % energy())
    return "".join(out).encode()


# ---------------------------------------------------------------- spectral-norm

def spectral_norm(n):
    if n == 5500:
        return b"1.274224153\n"
    if n > 500:
        return None

    def a(i, j):
        return 1.0 / ((i + j) * (i + j + 1) // 2 + i + 1)

    def av(v):
        return [sum(a(i, j) * v[j] for j in range(n)) for i in range(n)]

    def atv(v):
        return [sum(a(j, i) * v[j] for j in range(n)) for i in range(n)]

    u = [1.0] * n
    v = None
    for _ in range(10):
        v = atv(av(u))
        u = atv(av(v))
    vbv = 0.0
    vv = 0.0
    for i in range(n):
        vbv += u[i] * v[i]
        vv += v[i] * v[i]
    return ("%.9f\n" % math.sqrt(vbv / vv)).encode()


# --------------------------------------------------------------------- pidigits

def pidigits(n):
    # Machin's formula in fixed point, with guard digits; not the spigot, so
    # it is an independent check of the programs' output.
    guard = 20
    scale = 10 ** (n + guard)

    def arctan_inv(x):
        total = term = scale // x
        x2 = x * x
        k = 1
        sign = -1
        while term:
            term //= x2
            total += sign * (term // (2 * k + 1))
            sign = -sign
            k += 1
        return total

    pi = 4 * (4 * arctan_inv(5) - arctan_inv(239))
    digits = str(pi)[:n]
    out = []
    for i in range(0, n, 10):
        chunk = digits[i:i + 10]
        out.append("%-10s\t:%d\n" % (chunk, min(i + 10, n)))
    return "".join(out).encode()


# ---------------------------------------------------------- reverse-complement

_COMP = bytes.maketrans(b"ACBDGHKMNSRUTWVYacbdghkmnsrutwvy",
                        b"TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR")


def reverse_complement(data):
    out = []
    for block in data.split(b">")[1:]:
        nl = block.index(b"\n")
        header = block[:nl]
        seq = block[nl + 1:].replace(b"\n", b"")
        rc = seq.translate(_COMP)[::-1]
        out.append(b">" + header + b"\n")
        for i in range(0, len(rc), LINE):
            out.append(rc[i:i + LINE] + b"\n")
    return b"".join(out)


# ----------------------------------------------------------------- k-nucleotide

def k_nucleotide(data):
    start = data.index(b">THREE")
    start = data.index(b"\n", start) + 1
    seq = data[start:].replace(b"\n", b"").upper().decode()
    out = []
    for k in (1, 2):
        counts = {}
        for i in range(len(seq) - k + 1):
            key = seq[i:i + k]
            counts[key] = counts.get(key, 0) + 1
        total = len(seq) - k + 1
        for key, c in sorted(counts.items(), key=lambda kv: (-kv[1], kv[0])):
            out.append("%s %.3f\n" % (key, 100.0 * c / total))
        out.append("\n")
    for frag in ("GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"):
        k = len(frag)
        c = sum(1 for i in range(len(seq) - k + 1) if seq.startswith(frag, i))
        out.append("%d\t%s\n" % (c, frag))
    return "".join(out).encode()


# ------------------------------------------------------------------ regex-redux

VARIANTS = [
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct",
]

SUBST = [
    ("tHa[Nt]", "<4>"),
    ("aND|caN|Ha[DS]|WaS", "<3>"),
    ("a[NSt]|BY", "<2>"),
    ("<[^>]*>", "|"),
    ("\\|[^|][^|]*\\|", "-"),
]


def regex_redux(data):
    seq = data.decode()
    ilen = len(seq)
    seq = re.sub(">.*\n|\n", "", seq)
    clen = len(seq)
    out = []
    for v in VARIANTS:
        out.append("%s %d\n" % (v, len(re.findall(v, seq))))
    for pat, rep in SUBST:
        seq = re.sub(pat, rep, seq)
    out.append("\n%d\n%d\n%d\n" % (ilen, clen, len(seq)))
    return "".join(out).encode()


# ---------------------------------------------------------------------- lookup

BY_SIZE = {
    "binary-trees": binary_trees,
    "fannkuch-redux": fannkuch_redux,
    "fasta": fasta,
    "mandelbrot": mandelbrot,
    "n-body": n_body,
    "pidigits": pidigits,
    "spectral-norm": spectral_norm,
}

BY_INPUT = {
    "k-nucleotide": k_nucleotide,
    "regex-redux": regex_redux,
    "reverse-complement": reverse_complement,
}


def expected(program, size=None, data=None):
    """The bytes `program` must print, or None when Python cannot afford it."""
    if program in BY_SIZE:
        return BY_SIZE[program](size)
    return BY_INPUT[program](data)
