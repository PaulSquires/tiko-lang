typedef struct { double a, b; } P16d;
typedef struct { long long a, b; } P16i;
typedef struct { double a; long long b; } P16m;

/* 7 doubles use xmm0-6; P16d needs two SSE regs and only xmm7 is left, so the
   WHOLE struct goes to memory and z takes xmm7. */
double regx(double a1, double a2, double a3, double a4, double a5, double a6, double a7,
            P16d s, double z)
{
    return a1 + a2 + a3 + a4 + a5 + a6 + a7 + s.a * 100 + s.b * 1000 + z * 10000;
}

/* 5 ints use rdi..r8; P16i needs two GPRs and only r9 is left: memory, and k takes r9. */
long long regi(long long a1, long long a2, long long a3, long long a4, long long a5,
               P16i s, long long k)
{
    return a1 + a2 + a3 + a4 + a5 + s.a * 100 + s.b * 1000 + k * 10000;
}

/* mixed: 5 ints + 8 doubles, then P16m needs one GPR and one SSE: none SSE left -> memory */
double regm(long long i1, long long i2, long long i3, long long i4, long long i5,
            double d1, double d2, double d3, double d4, double d5, double d6, double d7, double d8,
            P16m s, long long k)
{
    return i1 + d1 + d8 + s.a * 100 + s.b * 1000 + k * 10000;
}

typedef double (*cbx)(double, double, double, double, double, double, double, P16d, double);
double call_regx(cbx f)
{
    P16d s = { 2, 3 };
    return f(0, 0, 0, 0, 0, 0, 1, s, 4);
}
