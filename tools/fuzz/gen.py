"""gen.py <seed> <out.bas> -- one random FreeBASIC program for differential testing.

The subset is chosen so that fbc's result is DEFINED: integer arithmetic is kept in range
(no overflow), no division by zero, doubles print through fixed formatting, strings are
built from ASCII only. Every value that is computed is printed, so a miscompile shows up
as an output difference rather than as silence.

Driven by tools/fuzz/run.sh. The same seed always writes the same program, so a finding is
reproduced by its seed alone. History, and what the first campaigns found: HANDOFF
sections 8s and 8t (a parenthesised concatenation as a PRINT item declined silently;
fbc regroups float constants, now modelled).
"""
import random
import sys

seed = int(sys.argv[1])
out = sys.argv[2]
R = random.Random(seed)

lines = []
def emit(s, ind=0):
    lines.append("\t" * ind + s)

INT_T = ["long", "integer", "longint", "short", "ubyte", "ulong"]
RANGE = {"long": (-1000, 1000), "integer": (-100000, 100000), "longint": (-10**9, 10**9),
         "short": (-100, 100), "ubyte": (0, 50), "ulong": (0, 2000)}

vars_ = []  # (name, type)
strs = []
dbls = []
counter = [0]
counters = set()  # FOR counters: read, never assigned

def fresh(prefix):
    counter[0] += 1
    return "%s%d" % (prefix, counter[0])

def int_atom():
    if vars_ and R.random() < 0.6:
        return R.choice(vars_)[0]
    return str(R.randint(-20, 20))

def int_expr(depth=0):
    # stays small: operands are clamped by the generator's own ranges and ops chosen
    # so the magnitude cannot overflow a 32-bit long
    if depth > 2 or R.random() < 0.35:
        return int_atom()
    op = R.choice(["+", "-", "*", "\\", "mod", "and", "or", "xor", "shl", "shr", "cmp"])
    a = int_expr(depth + 1)
    b = int_expr(depth + 1)
    if op in ("\\", "mod"):
        return "(clng(%s) %s (abs(clng(%s)) + 1))" % (a, op, b)
    if op in ("shl", "shr"):
        return "(clng(%s) %s (abs(clng(%s)) mod 5))" % (a, op, b)
    if op == "*":
        return "((clng(%s) mod 100) * (clng(%s) mod 100))" % (a, b)
    if op == "cmp":
        return "iif(clng(%s) %s clng(%s), 1, 0)" % (a, R.choice(["<", ">", "=", "<>", "<=", ">="]), b)
    return "((clng(%s) mod 10000) %s (clng(%s) mod 10000))" % (a, op, b)

# THE DOUBLES STAY BELOW 2^64. Above it FORMAT$ diverges between fbc and tiko-rt --
# fbc's cast of the integer part is undefined behaviour in C and carries its error,
# ours carries zeros past the seventeenth digit (lib/rt/src/str/format.bas). Phase 14's
# first 2,000-seed campaign found four programs of that shape and no compiler fault, so
# the magnitudes are clamped here: a campaign is meant to measure the compiler.
DBL_CLAMP = "(( %s ) - int(( %s ) / 1e18) * 1e18)"

def dbl_expr(depth=0):
    if depth > 2 or R.random() < 0.4:
        if dbls and R.random() < 0.5:
            return R.choice(dbls)
        return "%d.%d" % (R.randint(-50, 50), R.randint(0, 9))
    op = R.choice(["+", "-", "*", "/"])
    a = dbl_expr(depth + 1)
    b = dbl_expr(depth + 1)
    if op == "/":
        return "(%s / (abs(%s) + 1.5))" % (a, b)
    if op == "*":
        # the clamp: a product is where the magnitude ran away
        # fix(), NOT int(): FB's INT is FLOOR, so int( -3.2e-16 ) is -1 and the clamp
        # ADDED 1e18 to a negative product -- the first clamped campaign made values of
        # 4e13 out of small ones that way. fix() truncates toward zero.
        return "(((%s) * (%s)) - fix((((%s) * (%s))) / 1e18) * 1e18)" % (a, b, a, b)
    return "(%s %s %s)" % (a, op, b)

def str_expr(depth=0):
    if depth > 2 or R.random() < 0.4:
        if strs and R.random() < 0.6:
            return R.choice(strs)
        return '"%s"' % "".join(R.choice("abcXYZ019 ") for _ in range(R.randint(0, 6)))
    k = R.choice(["cat", "left", "mid", "ucase", "str", "chr", "trim", "space"])
    if k == "cat":
        return "(%s & %s)" % (str_expr(depth + 1), str_expr(depth + 1))
    if k == "left":
        return "left(%s, abs(clng(%s)) mod 6)" % (str_expr(depth + 1), int_atom())
    if k == "mid":
        return "mid(%s, (abs(clng(%s)) mod 4) + 1, 3)" % (str_expr(depth + 1), int_atom())
    if k == "ucase":
        return "ucase(%s)" % str_expr(depth + 1)
    if k == "str":
        return "str(clng(%s))" % int_expr(depth + 1)
    if k == "chr":
        return "chr(65 + (abs(clng(%s)) mod 26))" % int_atom()
    if k == "trim":
        return "trim(%s)" % str_expr(depth + 1)
    return "space(abs(clng(%s)) mod 4)" % int_atom()

def show_int(e, ind):
    emit("print %s" % e, ind)

def block(ind, depth, n):
    # A block's declarations END WITH IT: FreeBASIC scopes a DIM inside IF/FOR/CASE to that
    # body, so every name made in here is forgotten on the way out.
    saved = (len(vars_), len(strs), len(dbls))
    for _ in range(n):
        stmt(ind, depth)
    del vars_[saved[0]:]
    del strs[saved[1]:]
    del dbls[saved[2]:]

def stmt(ind, depth):
    k = R.choice(["dimint", "dimint", "assign", "dimstr", "dimdbl", "if", "for", "select",
                  "while", "print", "call"])
    if depth > 2 and k in ("if", "for", "select", "while"):
        k = "print"
    if k == "dimint":
        t = R.choice(INT_T)
        lo, hi = RANGE[t]
        n = fresh("i")
        emit("dim as %s %s = %d" % (t, n, R.randint(lo, hi)), ind)
        vars_.append((n, t))
        show_int(n, ind)
    elif k == "assign" and [v for v in vars_ if v[0] not in counters]:
        n, t = R.choice([v for v in vars_ if v[0] not in counters])
        lo, hi = RANGE[t]
        # clamp into the variable's own range so the store is defined
        emit("%s = %d + ((clng(%s) mod %d) + %d) mod %d" % (n, lo, int_expr(), hi - lo + 1, hi - lo + 1, hi - lo + 1), ind)
        show_int(n, ind)
    elif k == "dimstr":
        n = fresh("s")
        emit("dim as string %s = %s" % (n, str_expr()), ind)
        strs.append(n)
        emit('print "["; %s; "]"; len(%s)' % (n, n), ind)
    elif k == "dimdbl":
        n = fresh("d")
        emit("dim as double %s = %s" % (n, dbl_expr()), ind)
        dbls.append(n)
        emit('print format(%s, "0.000000")' % n, ind)
    elif k == "if":
        emit("if clng(%s) %s clng(%s) then" % (int_expr(), R.choice(["<", ">", "=", "<>"]), int_expr()), ind)
        for _ in range(R.randint(1, 3)):
            block(ind + 1, depth + 1, 1)
        emit("else", ind)
        block(ind + 1, depth + 1, 1)
        emit("end if", ind)
    elif k == "for":
        c = fresh("k")
        emit("for %s as long = 0 to %d" % (c, R.randint(0, 4)), ind)
        vars_.append((c, "long"))
        counters.add(c)
        for _ in range(R.randint(1, 2)):
            block(ind + 1, depth + 1, 1)
        emit("next", ind)
        vars_.remove((c, "long"))
    elif k == "select":
        emit("select case clng(%s) mod 4" % int_expr(), ind)
        for v in range(3):
            emit("case %d" % (v - 1), ind)
            block(ind + 1, depth + 1, 1)
        emit("case else", ind)
        block(ind + 1, depth + 1, 1)
        emit("end select", ind)
    elif k == "while":
        c = fresh("w")
        emit("dim as long %s = %d" % (c, R.randint(0, 3)), ind)
        emit("while %s > 0" % c, ind)
        block(ind + 1, depth + 1, 1)
        emit("%s -= 1" % c, ind + 1)
        emit("wend", ind)
    elif k == "call":
        emit("print F%d(clng(%s), %s)" % (R.randint(1, 3), int_expr(), str_expr()), ind)
    else:
        show_int(int_expr(), ind)
        if strs or R.random() < 0.3:
            emit('print "<"; %s; ">"' % str_expr(), ind)

emit("'' generated by gen.py, seed %d" % seed)
emit("#include once \"string.bi\"")
for f in range(1, 4):
    emit("function F%d( byval a as long, byref s as string ) as string" % f)
    emit("\tdim as long r = (a mod 1000) * %d + len( s )" % R.randint(1, 9))
    emit("\tif r > 50 then return ucase( s ) & str( r )")
    emit("\treturn str( r ) & s")
    emit("end function")
for _ in range(R.randint(15, 40)):
    stmt(0, 0)

with open(out, "w", newline="\n") as fh:
    fh.write("\n".join(lines) + "\n")
