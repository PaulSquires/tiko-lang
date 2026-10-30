#!/usr/bin/env python3
"""aapcslane.py -- generate the RUNNING AAPCS64 (Apple) ABI lane: tests/abi/apple/lane.c and
lane.tiko, from one table of shapes, so both sides agree by construction.

    python build/aapcslane.py            write both files
    python build/aapcslane.py --check    exit 1 if either file differs from what it would write

The lane is built and run by build/aapcslane.sh. tiko calls C and C calls tiko, with every
shape passed and returned BY VALUE, and C checks every value it is handed or handed back --
so the tiko side needs no runtime at all (no print, no strings): only field stores, integer
arithmetic and calls. Each direction uses its own patterns, so a value that arrives from the
wrong register or stack slot cannot match by accident:

    tiko -> C     tiko passes pattern 1; C returns pattern 2 and tiko hands it back to check
    C -> tiko     C passes pattern 3; tiko hands the argument back to check and returns 4
    callbacks     tiko gives C '@t_take_X' and C calls through it (pattern 3 -> 4); tiko
                  calls c_take_X through a procedure pointer (pattern 1 -> 2)

Element k of a shape (declaration order, arrays and nested fields flattened; a union has its
first member only) under pattern p is base = (10p + k + 1), negated for odd k, then scaled
per type so every byte of a wider field matters: char base, short base*257, int base*65537,
long long base*0x100000001, float base + 0.5, double base + 0.25 -- all exact.

Then the register-exhausting prefixes (an aggregate that no longer fits the registers left
goes WHOLE to the stack, and the next scalar follows it there), and varargs in both
directions (Apple: every variadic argument on the stack). main checks that every expected
call happened, so a call that was skipped cannot pass.
"""

import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_C = os.path.join(ROOT, "tests", "abi", "apple", "lane.c")
OUT_T = os.path.join(ROOT, "tests", "abi", "apple", "lane.tiko")

C_TYPE = {"c": "signed char", "s": "short", "i": "int", "l": "long long", "f": "float", "d": "double"}
T_TYPE = {"c": "byte", "s": "short", "i": "long", "l": "longint", "f": "single", "d": "double"}

# name -> (kind, [(field, type, count)]); a type is a scalar code or an earlier shape's name
SHAPES = {}
ORDER = []


def shape(name, fields, kind="struct"):
    SHAPES[name] = (kind, fields)
    ORDER.append(name)


# the static lane's shapes (tests/abi/apple/sig.c)
shape("C1", [("a", "c", 1)])
shape("C3", [("a", "c", 1), ("b", "c", 1), ("c", "c", 1)])
shape("S3", [("a", "s", 1), ("b", "c", 1)])
shape("HS", [("a", "s", 3)])
shape("I1", [("a", "i", 1)])
shape("I5", [("a", "i", 1), ("b", "c", 1)])
shape("I2", [("a", "i", 1), ("b", "i", 1)])
shape("I3", [("a", "i", 1), ("b", "i", 1), ("c", "i", 1)])
shape("L2", [("a", "l", 1), ("b", "l", 1)])
shape("L12", [("a", "l", 1), ("b", "i", 1)])
shape("L3", [("a", "l", 1), ("b", "l", 1), ("c", "l", 1)])
for n in range(1, 6):
    shape("F%d" % n, [("abcde"[k], "f", 1) for k in range(n)])
for n in range(1, 6):
    shape("D%d" % n, [("abcde"[k], "d", 1) for k in range(n)])
shape("FD", [("a", "f", 1), ("b", "d", 1)])
shape("FI", [("a", "f", 1), ("b", "i", 1)])
shape("FA3", [("a", "f", 3)])
shape("NF4", [("x", "F2", 1), ("y", "F2", 1)])
shape("DA2", [("a", "d", 2)])
shape("UF", [("a", "f", 1), ("b", "f", 1)], "union")
shape("UD", [("a", "d", 1), ("b", "l", 1)], "union")
# every size from 1 to 33 bytes
for n in range(1, 34):
    shape("B%d" % n, [("a", "c", n)])
# mixed and nested
shape("MX", [("a", "c", 1), ("b", "i", 2), ("c", "s", 1)])
shape("ND", [("x", "D2", 1), ("y", "d", 1)])
shape("NFA", [("x", "F2", 1), ("y", "f", 2)])
shape("FFD", [("x", "F2", 1), ("y", "d", 1)])
shape("MIX24", [("a", "d", 1), ("b", "f", 1), ("c", "i", 1), ("d", "l", 1)])

# register-exhausting prefixes: (name, params); a param is a scalar code or a shape name
PREFIXES = [
    ("hfa9", ["d", "d", "d", "d", "d", "d", "D3", "d"]),     # 6 V regs used, D3 needs 3: stack
    ("hfaf", ["f", "f", "f", "f", "f", "f", "f", "F2", "f"]),  # 7 used, F2 needs 2: stack
    ("gpr7", ["l", "l", "l", "l", "l", "l", "l", "L2", "l"]),  # 7 GPRs used, L2 needs 2: stack
    ("mix", ["i"] * 8 + ["d"] * 8 + ["I3", "D2", "i", "d"]),   # everything after on the stack
    ("big", ["i"] * 7 + ["B33", "i", "MIX24"]),                # indirect ones: pointers in x7, stack
]


def elems(name, path):
    """[(access path, scalar code)] in declaration order."""
    kind, fields = SHAPES[name]
    if kind == "union":
        fields = fields[:1]
    out = []
    for fname, ftype, count in fields:
        for j in range(count):
            p = path + [(fname, j if count > 1 else None)]
            if ftype in C_TYPE:
                out.append((p, ftype))
            else:
                out.extend(elems(ftype, p))
    return out


def c_access(p):
    return ".".join(f + ("[%d]" % j if j is not None else "") for f, j in p)


def t_access(p):
    return ".".join(f + ("(%d)" % j if j is not None else "") for f, j in p)


def gen_c():
    L = []
    w = L.append
    w("/* tests/abi/apple/lane.c -- GENERATED by build/aapcslane.py: do not edit; regenerate.")
    w("   The C side of the running AAPCS64 (Apple) lane (build/aapcslane.sh). It owns main and")
    w("   makes every check; lane.tiko calls it and is called by it. */")
    w("#include <stdio.h>")
    w("#include <stdarg.h>")
    w("#include <string.h>")
    w("")
    w("static int checks, fails, calls;")
    w("static long long pb( int p, int k ) { long long b = 10 * p + k + 1; return ( k & 1 ) ? -b : b; }")
    w("static signed char pc( int p, int k ) { return (signed char)pb( p, k ); }")
    w("static short ps( int p, int k ) { return (short)( pb( p, k ) * 257 ); }")
    w("static int pi( int p, int k ) { return (int)( pb( p, k ) * 65537 ); }")
    w("static long long pl( int p, int k ) { return pb( p, k ) * 0x100000001LL; }")
    w("static float pf( int p, int k ) { return (float)pb( p, k ) + 0.5f; }")
    w("static double pd( int p, int k ) { return (double)pb( p, k ) + 0.25; }")
    w("static void ck_i( const char *ctx, const char *f, long long got, long long want ) {")
    w("    checks++;")
    w("    if( got != want ) { fails++; printf( \"FAIL %s .%s: got %lld want %lld\\n\", ctx, f, got, want ); }")
    w("}")
    w("static void ck_d( const char *ctx, const char *f, double got, double want ) {")
    w("    checks++;")
    w("    if( got != want ) { fails++; printf( \"FAIL %s .%s: got %g want %g\\n\", ctx, f, got, want ); }")
    w("}")
    w("static int marker;")
    w("void *c_marker( void ) { return &marker; }")
    w("")
    for name in ORDER:
        kind, fields = SHAPES[name]
        w("typedef %s {" % kind)
        for fname, ftype, count in fields:
            ct = C_TYPE.get(ftype, ftype)
            w("    %s %s%s;" % (ct, fname, "[%d]" % count if count > 1 else ""))
        w("} %s;" % name)
    w("")
    for name in ORDER:
        es = elems(name, [])
        w("static void fill_%s( %s *v, int p ) {" % (name, name))
        w("    memset( v, 0, sizeof *v );")
        for k, (p, t) in enumerate(es):
            w("    v->%s = p%s( p, %d );" % (c_access(p), t, k))
        w("}")
        w("static void ck_%s( const char *ctx, const %s *v, int p ) {" % (name, name))
        for k, (p, t) in enumerate(es):
            fn = "ck_d" if t in "fd" else "ck_i"
            w("    %s( ctx, \"%s\", v->%s, p%s( p, %d ) );" % (fn, c_access(p), c_access(p), t, k))
        w("}")
        w("%s c_take_%s( int n, %s v ) {" % (name, name, name))
        w("    calls++; ck_i( \"c_take_%s\", \"n\", n, 7 ); ck_%s( \"c_take_%s arg\", &v, 1 );" % (name, name, name))
        w("    %s r; fill_%s( &r, 2 ); return r;" % (name, name))
        w("}")
        w("void c_chk_%s( const %s *r ) { calls++; ck_%s( \"c_take_%s result, in tiko\", r, 2 ); }" % (name, name, name, name))
        w("void c_seen_%s( int n, const %s *v ) {" % (name, name))
        w("    calls++; ck_i( \"t_take_%s\", \"n\", n, 7 ); ck_%s( \"t_take_%s arg, in tiko\", v, 3 );" % (name, name, name))
        w("}")
        w("%s t_take_%s( int n, %s v );" % (name, name, name))
        w("void c_cb_%s( %s ( *cb )( int, %s ) ) {" % (name, name, name))
        w("    calls++; %s a; fill_%s( &a, 3 ); %s r = cb( 7, a ); ck_%s( \"callback t_take_%s result\", &r, 4 );" % (name, name, name, name, name))
        w("}")
        w("static void c_call_%s( void ) {" % name)
        w("    %s a; fill_%s( &a, 3 ); %s r = t_take_%s( 7, a ); ck_%s( \"t_take_%s result\", &r, 4 );" % (name, name, name, name, name, name))
        w("}")
    w("")
    # prefixes
    for pname, params in PREFIXES:
        decl = ", ".join("%s a%d" % (C_TYPE.get(t, t), k) for k, t in enumerate(params))
        pdecl = ", ".join(("%s a%d" % (C_TYPE[t], k)) if t in C_TYPE else ("const %s *a%d" % (t, k))
                          for k, t in enumerate(params))
        def body(ctx, pat, deref):
            out = []
            for k, t in enumerate(params):
                if t in C_TYPE:
                    fn = "ck_d" if t in "fd" else "ck_i"
                    out.append("%s( \"%s\", \"a%d\", a%d, %d );" % (fn, ctx, k, k, k + 1))
                else:
                    out.append("ck_%s( \"%s a%d\", %sa%d, %d );" % (t, ctx, k, deref, k, pat))
            return " ".join(out)
        w("void c_%s( %s ) { calls++; %s }" % (pname, decl, body("c_" + pname, 1, "&")))
        w("void c_seen_%s( %s ) { calls++; %s }" % (pname, pdecl, body("t_" + pname + ", in tiko", 3, "")))
        w("void t_%s( %s );" % (pname, decl))
        w("static void c_call_%s( void ) {" % pname)
        args = []
        for k, t in enumerate(params):
            if t in C_TYPE:
                args.append(str(k + 1))
            else:
                w("    %s s%d; fill_%s( &s%d, 3 );" % (t, k, t, k))
                args.append("s%d" % k)
        w("    t_%s( %s );" % (pname, ", ".join(args)))
        w("}")
    w("")
    # varargs
    w("long long c_va( int n, ... ) {")
    w("    va_list ap; va_start( ap, n ); calls++;")
    w("    ck_i( \"c_va\", \"n\", n, 7 );")
    w("    ck_i( \"c_va\", \"long\", va_arg( ap, int ), 11 );")
    w("    ck_i( \"c_va\", \"longint\", va_arg( ap, long long ), 12 );")
    w("    ck_d( \"c_va\", \"double\", va_arg( ap, double ), 13.5 );")
    w("    ck_i( \"c_va\", \"ptr\", (long long)va_arg( ap, void * ), (long long)&marker );")
    w("    ck_d( \"c_va\", \"single (promoted)\", va_arg( ap, double ), 14.5 );")
    w("    ck_i( \"c_va\", \"byte (promoted)\", va_arg( ap, int ), -15 );")
    w("    ck_i( \"c_va\", \"short (promoted)\", va_arg( ap, int ), -16 );")
    w("    ck_i( \"c_va\", \"integer\", va_arg( ap, long long ), 17 );")
    w("    va_end( ap );")
    w("    return 99;")
    w("}")
    w("void c_va_ret( long long r ) { calls++; ck_i( \"c_va\", \"result, in tiko\", r, 99 ); }")
    w("void c_seen_va( int n, int a, long long b, double c, void *p ) {")
    w("    calls++; ck_i( \"t_va\", \"n\", n, 7 ); ck_i( \"t_va\", \"long\", a, 11 );")
    w("    ck_i( \"t_va\", \"longint\", b, 12 ); ck_d( \"t_va\", \"double\", c, 13.5 );")
    w("    ck_i( \"t_va\", \"ptr\", (long long)p, (long long)&marker );")
    w("}")
    w("long long t_va( int n, ... );")
    w("")
    w("void trun_all( void );")
    expected = 7 * len(ORDER) + 2 * len(PREFIXES) + 3
    w("#define EXPECTED_CALLS %d" % expected)
    w("int main( void ) {")
    w("    trun_all( );")
    for name in ORDER:
        w("    c_call_%s( );" % name)
    for pname, _ in PREFIXES:
        w("    c_call_%s( );" % pname)
    w("    ck_i( \"t_va\", \"result\", t_va( 7, 11, 12LL, 13.5, &marker ), 99 );")
    w("    ck_i( \"main\", \"calls\", calls, EXPECTED_CALLS );")
    w("    printf( \"aapcs lane: %d shapes, %d checks, %d failed\\n\", " + str(len(ORDER)) + ", checks, fails );")
    w("    return fails ? 1 : 0;")
    w("}")
    return "\n".join(L) + "\n"


def gen_t():
    L = []
    w = L.append
    w("'' tests/abi/apple/lane.tiko -- GENERATED by build/aapcslane.py: do not edit; regenerate.")
    w("'' tiko's side of the running AAPCS64 (Apple) lane (build/aapcslane.sh). No runtime: C owns")
    w("'' main and makes every check; this file only stores fields and calls.")
    w("")
    for name in ORDER:
        kind, fields = SHAPES[name]
        w("%s %s" % ("type" if kind == "struct" else "union", name))
        for fname, ftype, count in fields:
            tt = T_TYPE.get(ftype, ftype)
            w("    %s%s as %s" % (fname, "(0 to %d)" % (count - 1) if count > 1 else "", tt))
        w("end %s" % ("type" if kind == "struct" else "union"))
    w("")
    w("extern \"C\"")
    w("declare function c_marker( ) as any ptr")
    for name in ORDER:
        w("declare function c_take_%s( byval n as long, byval v as %s ) as %s" % (name, name, name))
        w("declare sub c_chk_%s( byval r as %s ptr )" % (name, name))
        w("declare sub c_seen_%s( byval n as long, byval v as %s ptr )" % (name, name))
        w("declare sub c_cb_%s( byval cb as function( byval n as long, byval v as %s ) as %s )" % (name, name, name))
    for pname, params in PREFIXES:
        decl = ", ".join("byval a%d as %s" % (k, T_TYPE.get(t, t)) for k, t in enumerate(params))
        pdecl = ", ".join(("byval a%d as %s" % (k, T_TYPE[t])) if t in T_TYPE else ("byval a%d as %s ptr" % (k, t))
                          for k, t in enumerate(params))
        w("declare sub c_%s( %s )" % (pname, decl))
        w("declare sub c_seen_%s( %s )" % (pname, pdecl))
    w("declare function c_va cdecl( byval n as long, ... ) as longint")
    w("declare sub c_va_ret( byval r as longint )")
    w("declare sub c_seen_va( byval n as long, byval a as long, byval b as longint, byval c as double, byval p as any ptr )")
    w("")
    w("function tk_pb( byval p as long, byval k as long ) as longint")
    w("    dim as longint b = 10 * p + k + 1")
    w("    if (k and 1) <> 0 then b = -b")
    w("    return b")
    w("end function")
    w("function tk_pc( byval p as long, byval k as long ) as byte")
    w("    return cbyte( tk_pb( p, k ) )")
    w("end function")
    w("function tk_ps( byval p as long, byval k as long ) as short")
    w("    return cshort( tk_pb( p, k ) * 257 )")
    w("end function")
    w("function tk_pi( byval p as long, byval k as long ) as long")
    w("    return clng( tk_pb( p, k ) * 65537 )")
    w("end function")
    w("function tk_pl( byval p as long, byval k as long ) as longint")
    w("    return tk_pb( p, k ) * &h100000001ll")
    w("end function")
    w("function tk_pf( byval p as long, byval k as long ) as single")
    w("    return csng( tk_pb( p, k ) ) + 0.5")
    w("end function")
    w("function tk_pd( byval p as long, byval k as long ) as double")
    w("    return cdbl( tk_pb( p, k ) ) + 0.25")
    w("end function")
    w("")
    for name in ORDER:
        es = elems(name, [])
        w("sub tfill_%s( byref v as %s, byval p as long )" % (name, name))
        for k, (p, t) in enumerate(es):
            w("    v.%s = tk_p%s( p, %d )" % (t_access(p), t, k))
        w("end sub")
        w("function t_take_%s( byval n as long, byval v as %s ) as %s" % (name, name, name))
        w("    c_seen_%s( n, @v )" % name)
        w("    dim as %s r" % name)
        w("    tfill_%s( r, 4 )" % name)
        w("    return r")
        w("end function")
        w("sub trun_%s( )" % name)
        w("    dim as %s v" % name)
        w("    tfill_%s( v, 1 )" % name)
        w("    dim as %s r = c_take_%s( 7, v )" % (name, name))
        w("    c_chk_%s( @r )" % name)
        w("    dim fp as function( byval n as long, byval v as %s ) as %s = @c_take_%s" % (name, name, name))
        w("    dim as %s r2 = fp( 7, v )" % name)
        w("    c_chk_%s( @r2 )" % name)
        w("    c_cb_%s( @t_take_%s )" % (name, name))
        w("end sub")
    w("")
    for pname, params in PREFIXES:
        decl = ", ".join("byval a%d as %s" % (k, T_TYPE.get(t, t)) for k, t in enumerate(params))
        w("sub t_%s( %s )" % (pname, decl))
        w("    c_seen_%s( %s )" % (pname, ", ".join(("a%d" % k) if t in T_TYPE else ("@a%d" % k)
                                                  for k, t in enumerate(params))))
        w("end sub")
        w("sub trun_%s( )" % pname)
        args = []
        for k, t in enumerate(params):
            if t in T_TYPE:
                args.append(str(k + 1))
            else:
                w("    dim as %s s%d" % (t, k))
                w("    tfill_%s( s%d, 1 )" % (t, k))
                args.append("s%d" % k)
        w("    c_%s( %s )" % (pname, ", ".join(args)))
        w("end sub")
    w("")
    w("function t_va cdecl( byval n as long, ... ) as longint")
    w("    dim as cva_list ap")
    w("    cva_start( ap, n )")
    w("    dim as long a = cva_arg( ap, long )")
    w("    dim as longint b = cva_arg( ap, longint )")
    w("    dim as double c = cva_arg( ap, double )")
    w("    dim as any ptr p = cva_arg( ap, any ptr )")
    w("    cva_end( ap )")
    w("    c_seen_va( n, a, b, c, p )")
    w("    return 99")
    w("end function")
    w("")
    w("sub trun_all( )")
    for name in ORDER:
        w("    trun_%s( )" % name)
    for pname, _ in PREFIXES:
        w("    trun_%s( )" % pname)
    w("    c_va_ret( c_va( 7, clng( 11 ), clngint( 12 ), 13.5, c_marker( ), csng( 14.5 ), cbyte( -15 ), cshort( -16 ), 17 ) )")
    w("end sub")
    w("end extern")
    return "\n".join(L) + "\n"


def main():
    check = "--check" in sys.argv[1:]
    rc = 0
    for path, text in ((OUT_C, gen_c()), (OUT_T, gen_t())):
        if check:
            old = open(path, "rb").read().decode() if os.path.exists(path) else ""
            if old != text:
                print("aapcslane: %s is stale (run build/aapcslane.py)" % os.path.relpath(path, ROOT))
                rc = 1
        else:
            with open(path, "wb") as f:
                f.write(text.encode())
    if not check:
        print("aapcslane: %d shapes, %d prefixes -> %s, %s" % (len(ORDER), len(PREFIXES),
              os.path.relpath(OUT_C, ROOT), os.path.relpath(OUT_T, ROOT)))
    return rc


if __name__ == "__main__":
    sys.exit(main())
