"""dgen.py <seed> <out.bas> -- a random, deterministic, DEFINED program for build/difflane.sh.

Covers every integer width/signedness, mixed-width expressions, shifts, \\, mod, comparisons,
int<->float conversions, c* casts, bit ops, iif, nested calls with byval/byref args, local
arrays, string building. Every statement prints a labelled line so a diff names the site.
Defined-ness rules: divisors are never 0 and never -1; shift counts 0..63; float->int only
for values in range of the target; signed 64-bit wraparound IS generated (fbc gas64 wraps;
a tiko difference there is reported separately as category WRAP).
"""
import random, sys

seed = int(sys.argv[1]); out = sys.argv[2]
NOWRAP = len(sys.argv) > 3 and sys.argv[3] == "nowrap"
R = random.Random(seed)

TYPES = {  # name: (bits, signed)
    "byte": (8, True), "ubyte": (8, False), "short": (16, True), "ushort": (16, False),
    "long": (32, True), "ulong": (32, False), "longint": (64, True), "ulongint": (64, False),
    "integer": (64, True), "uinteger": (64, False),
}
TN = list(TYPES)
CAST = {"byte": "cbyte", "ubyte": "cubyte", "short": "cshort", "ushort": "cushort",
        "long": "clng", "ulong": "culng", "longint": "clngint", "ulongint": "culngint",
        "integer": "cint", "uinteger": "cuint"}

def rng(t):
    b, s = TYPES[t]
    return (-(1 << (b - 1)), (1 << (b - 1)) - 1) if s else (0, (1 << b) - 1)

def lit(t, v):
    b, s = TYPES[t]
    if b == 64 and not s:
        return "%dull" % v
    if b == 64 and v == -(1 << 63):
        return "(-9223372036854775807ll - 1)"
    if b == 64:
        return "%dll" % v
    # UNSUFFIXED 2^31..2^32-1 is UINTEGER in fbc -- and in tiko since audit F-15, which this
    # generator found; left unsuffixed so the lane keeps testing it.
    return str(v)

def val(t):
    lo, hi = rng(t)
    r = R.random()
    if r < 0.35:
        return R.choice([lo, hi, 0, 1, lo + 1, hi - 1, max(lo, -1), min(hi, 2), hi // 2, hi // 2 + 1])
    if r < 0.7:
        return R.randint(max(lo, -300), min(hi, 300))
    return R.randint(lo, hi)

lines = []
def emit(s, ind=1):
    lines.append("\t" * ind + s)

label = [0]
def lab():
    label[0] += 1
    return '"L%d "' % label[0]

class Scope:
    def __init__(self):
        self.vars = []   # (name, type)
        self.arrs = []   # (name, type, n)

def int_atom(sc, depth):
    r = R.random()
    if sc.vars and r < 0.65:
        return R.choice(sc.vars)[0]
    if sc.arrs and r < 0.75:
        a, t, n = R.choice(sc.arrs)
        return "%s((%s) and %d)" % (a, int_atom(sc, depth + 1), n - 1)
    t = R.choice(TN)
    if R.random() < 0.5:
        return lit(t, val(t))
    return "%s(%s)" % (CAST[t], lit(t, val(t)))

def int_expr(sc, depth=0):
    if depth > 3 or R.random() < 0.3:
        return int_atom(sc, depth)
    k = R.random()
    a = int_expr(sc, depth + 1)
    b = int_expr(sc, depth + 1)
    if k < 0.25:
        op = R.choice(["+", "-", "*"])
        if NOWRAP:
            return "((%s) and 65535) %s ((%s) and 65535)" % (a, op, b)
        return "(%s %s %s)" % (a, op, b)
    if k < 0.40:
        op = R.choice(["and", "or", "xor"])
        return "(%s %s %s)" % (a, op, b)
    if k < 0.50:
        op = R.choice(["\\", "mod"])
        if R.random() < 0.7:
            return "(%s %s (((%s) and 63) + 1))" % (a, op, b)
        return "(%s %s -cint(((%s) and 63) + 2))" % (a, op, b)
    if k < 0.60:
        op = R.choice(["shl", "shr"])
        return "(%s %s ((%s) and %d))" % (a, op, b, R.choice([7, 15, 31, 63]))
    if k < 0.68:
        op = R.choice(["<", ">", "=", "<>", "<=", ">="])
        return "(%s %s %s)" % (a, op, b)
    if k < 0.74:
        t = R.choice(TN)
        return "iif(%s %s %s, %s(%s), %s(%s))" % (a, R.choice(["<", ">", "="]), b,
                                                  CAST[t], int_expr(sc, depth + 1), CAST[t], int_expr(sc, depth + 1))
    if k < 0.82:
        t = R.choice(TN)
        return "%s(%s)" % (CAST[t], a)
    if k < 0.86:
        return "(not %s)" % a
    if k < 0.89:
        return R.choice(["(-cint(%s))", "(0 - %s)", "(-clng(%s))"]) % a
    if k < 0.93 and FUNCS:
        return call_expr(sc, depth + 1)
    if k < 0.96:
        return "abs(%s)" % (CAST[R.choice(["long", "short", "byte", "integer"])] + "(" + a + ")")
    return "sgn(%s(%s))" % (R.choice(["cint", "clng", "cshort"]), a) if not a.lstrip("-").isdigit() and "ul" not in a else "(%s)" % a

def dbl_expr(sc, depth=0):
    # small exact-ish doubles; magnitudes kept < 2^31 so any int conversion is in range
    k = R.random()
    a = int_expr(sc, depth + 1)
    if k < 0.3:
        return "(cdbl((%s) and 4095) / %d)" % (a, R.choice([2, 4, 8, 3, 10]))
    if k < 0.5:
        return "(cdbl(%s(%s)) / %d)" % (R.choice(["cshort", "cbyte"]), a, R.choice([2, 4, 8, 3]))
    if k < 0.7:
        return "(csng((%s) and 1023) * 0.5)" % a
    if k < 0.85:
        return "(cdbl(%s(%s)) * 1.5 - 0.25)" % (R.choice(["cshort", "cbyte", "cubyte"]), a)
    return "(%s(%s) + 0.5)" % (R.choice(["cdbl", "csng"]), CAST[R.choice(["byte", "ubyte", "short", "ushort"])] + "(" + a + ")")

FUNCS = []  # pure: all byval, no global writes
EFF = []    # effect: byref params written; statement-level calls only

def call_expr(sc, depth, pool=None):
    name, rt, params = R.choice(pool or FUNCS)
    args = []
    for mode, t in params:
        if mode == "byref":
            cands = [v for v in sc.vars if v[1] == t]
            if not cands:
                return int_atom(sc, depth)
            args.append(R.choice(cands)[0])
        else:
            args.append(int_expr(sc, depth + 1) if depth < 4 else int_atom(sc, depth))
    return "%s(%s)" % (name, ", ".join(args))

def str_expr(sc):
    k = R.random()
    e = int_expr(sc, 2)
    if k < 0.3:
        return "str(%s)" % e
    if k < 0.5:
        return "hex(%s)" % e
    if k < 0.6:
        return "hex(%s, %d)" % (e, R.randint(1, 16))
    if k < 0.7:
        return "oct(%s)" % e
    if k < 0.8 and sc.vars:
        return "hex(%s)" % R.choice(sc.vars)[0]
    if k < 0.9 and sc.vars:
        return "str(%s)" % R.choice(sc.vars)[0]
    return "chr(65 + ((%s) and 15))" % e

def stmt(sc, ind, depth, out_vars_ok=True):
    k = R.random()
    if k < 0.12:
        t = R.choice(TN)
        n = "v%d" % len(lines)
        emit("dim as %s %s = %s" % (t, n, lit(t, val(t))), ind)
        sc.vars.append((n, t))
        emit("print %s; %s" % (lab(), n), ind)
    elif k < 0.30 and sc.vars:
        n, t = R.choice(sc.vars)
        if R.random() < 0.15:
            b, sg = TYPES[t]
            d = dbl_expr(sc)
            if not sg: d = "abs(%s)" % d
            if b == 8: d = "(%s / 512)" % d
            elif b == 16: d = "(%s / 4)" % d
            emit("%s = %s" % (n, d), ind)
        else:
            emit("%s = %s" % (n, int_expr(sc)), ind)
        emit("print %s; %s" % (lab(), n), ind)
    elif k < 0.33 and sc.vars:
        n, t = R.choice(sc.vars)
        emit("%s %s= %s" % (n, R.choice(["+", "-", "and", "or", "xor"]), int_expr(sc)), ind)
        emit("print %s; %s" % (lab(), n), ind)
    elif k < 0.55:
        emit("print %s; %s" % (lab(), int_expr(sc)), ind)
    elif k < 0.62:
        tgt = R.choice(["cint", "clng", "cshort", "cbyte", "clngint", "cuint", "culng", "cubyte", "cushort", "culngint", "int", "fix"])
        d = dbl_expr(sc)
        if tgt in ("cuint", "culng", "cubyte", "cushort", "culngint"):
            d = "abs(%s)" % d
        if tgt in ("cbyte", "cubyte"):
            d = "(%s / 512)" % d
        if tgt in ("cshort", "cushort"):
            d = "(%s / 4)" % d
        emit("print %s; %s(%s)" % (lab(), tgt, d), ind)
    elif k < 0.67:
        emit("print %s; %s" % (lab(), dbl_expr(sc)), ind)
    elif k < 0.75:
        sv = "s%d" % len(lines)
        emit("dim as string %s = %s" % (sv, str_expr(sc)), ind)
        for _ in range(R.randint(1, 3)):
            emit("%s &= %s" % (sv, R.choice([str_expr(sc), '"-"', int_expr(sc, 3)])), ind)
        e = int_expr(sc, 3)
        emit('print %s; "["; %s; "]"; len(%s)' % (lab(), sv, sv), ind)
        emit('print %s; left(%s, (%s) and 15); "|"; right(%s, (%s) and 15); "|"; mid(%s, ((%s) and 15), (%s) and 7)'
             % (lab(), sv, e, sv, int_expr(sc, 3), sv, int_expr(sc, 3), int_expr(sc, 3)), ind)
        emit('print %s; %s & %s' % (lab(), str_expr(sc), int_expr(sc, 3)), ind)
    elif k < 0.80 and depth < 3:
        t = R.choice(TN); n = 8
        a = "a%d" % len(lines)
        emit("dim as %s %s(0 to %d)" % (t, a, n - 1), ind)
        kv = "k%d" % len(lines)
        emit("for %s as integer = 0 to %d" % (kv, n - 1), ind)
        sc.vars.append((kv, "integer"))
        emit("%s(%s) = %s" % (a, kv, int_expr(sc, 2)), ind + 1)
        sc.vars.pop()
        emit("next", ind)
        sc.arrs.append((a, t, n))
        emit("print %s; %s(0); %s(%d); %s(%s)" % (lab(), a, a, R.randint(1, n - 1), a, "(%s) and 7" % int_expr(sc, 3)), ind)
    elif k < 0.88 and depth < 3:
        emit("if %s %s %s then" % (int_expr(sc, 1), R.choice(["<", ">", "=", "<>", "<=", ">="]), int_expr(sc, 1)), ind)
        stmt_block(sc, ind + 1, depth + 1, R.randint(1, 3))
        if R.random() < 0.6:
            emit("else", ind)
            stmt_block(sc, ind + 1, depth + 1, R.randint(1, 2))
        emit("end if", ind)
    elif k < 0.92 and depth < 3:
        kv = "k%d" % len(lines)
        emit("for %s as long = %d to %d" % (kv, R.randint(-2, 1), R.randint(0, 3)), ind)
        sc.vars.append((kv, "long"))
        nsave = len(sc.vars)
        stmt_block(sc, ind + 1, depth + 1, R.randint(1, 2), no_assign=kv)
        sc.vars.remove((kv, "long"))
        emit("next", ind)
    elif k < 0.97 and EFF:
        emit("print %s; %s" % (lab(), call_expr(sc, 1, EFF)), ind)
        # show byref effects
        emit("print %s; %s" % (lab(), "; \" \"; ".join(v[0] for v in sc.vars[-4:]) or "0"), ind)
    else:
        emit("select case %s" % int_expr(sc, 2), ind)
        for _ in range(R.randint(1, 3)):
            t = R.choice(TN)
            emit("case %s" % lit(t, val(t)), ind)
            emit("print %s; 1" % lab(), ind + 1)
        emit("case is < 0", ind)
        emit("print %s; 2" % lab(), ind + 1)
        emit("case else", ind)
        emit("print %s; 3" % lab(), ind + 1)
        emit("end select", ind)

def stmt_block(sc, ind, depth, n, no_assign=None):
    sv = list(sc.vars); sa = list(sc.arrs)
    if no_assign:
        # loop counter must not be assigned: hide it from assignment targets by a scope copy
        inner = Scope(); inner.vars = [v for v in sc.vars if v[0] != no_assign]; inner.arrs = sc.arrs
        inner_ro = (no_assign, "long")
        for _ in range(n):
            # reads of the counter allowed through a temp
            stmt(inner, ind, depth)
        sc.vars[:] = sv; sc.arrs[:] = sa
        return
    for _ in range(n):
        stmt(sc, ind, depth)
    sc.vars[:] = sv; sc.arrs[:] = sa

lines.append("'' dgen seed %d" % seed)
# globals
gsc = Scope()
for i in range(R.randint(2, 5)):
    t = R.choice(TN)
    n = "g%d" % i
    lines.append("dim shared as %s %s = %s" % (t, n, lit(t, val(t))))
    gsc.vars.append((n, t))

# functions
def mkfunc(name, pure):
    rt = R.choice(TN)
    params = []
    for pi in range(R.randint(1, 4)):
        params.append(("byval" if pure else R.choice(["byval", "byref", "byref"]), R.choice(TN)))
    plist = ", ".join("%s p%d as %s" % (m, i, t) for i, (m, t) in enumerate(params))
    lines.append("function %s(%s) as %s" % (name, plist, rt))
    sc = Scope()
    ro = list(gsc.vars)
    sc.vars = [("p%d" % i, t) for i, (m, t) in enumerate(params)]
    rd = Scope(); rd.vars = ro + sc.vars; rd.arrs = sc.arrs
    for _ in range(R.randint(1, 4)):
        k = R.random()
        if k < 0.5:
            n, t = R.choice(sc.vars)
            emit("%s = %s" % (n, int_expr(rd, 1)))
        elif k < 0.7:
            t = R.choice(TN); n = "l%d" % len(lines)
            emit("dim as %s %s = %s" % (t, n, int_expr(rd, 1)))
            sc.vars.append((n, t)); rd.vars.append((n, t))
        else:
            t = R.choice(TN); a = "la%d" % len(lines)
            emit("dim as %s %s(3)" % (t, a))
            emit("%s((%s) and 3) = %s" % (a, int_expr(rd, 2), int_expr(rd, 2)))
            sc.arrs.append((a, t, 4))
    emit("return %s" % int_expr(rd, 1))
    lines.append("end function")
    (FUNCS if pure else EFF).append((name, rt, params))

for fi in range(R.randint(2, 4)):
    mkfunc("fp%d" % fi, True)
for fi in range(R.randint(1, 3)):
    mkfunc("fe%d" % fi, False)

lines.append("sub body()")
sc = Scope(); sc.vars = list(gsc.vars)
for _ in range(R.randint(25, 60)):
    stmt(sc, 1, 0)
lines.append("end sub")
lines.append("body()")
lines.append('print "done"')

with open(out, "w", newline="\n") as fh:
    fh.write("\n".join(lines) + "\n")
