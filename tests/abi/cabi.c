#include <stdarg.h>
#include <stdio.h>

typedef struct { signed char a; } S1;
typedef struct { short a; } S2;
typedef struct { signed char a, b, c; } S3;
typedef struct { float f; } S4f;
typedef struct { signed char a[5]; } S5;
typedef struct { float a, b; } S8f;
typedef struct { double d; } S8d;
typedef struct { float a; int b; } S8m;
typedef struct { signed char a[9]; } S9;
typedef struct { float a, b, c; } S12f;
typedef struct { int a, b, c; } S12i;
typedef struct { double a, b; } S16d;
typedef struct { double a; long long b; } S16m;
typedef struct { float a; float b; double c; } S16ffd;
typedef struct { signed char a[17]; } S17;
typedef struct { double a, b, c; } S24;
typedef union { int i; float f; } U4;
typedef union { double d; long long q; } U8;
typedef struct { float a[3]; int b; } SArr;
typedef struct { signed char a[13]; } S13;
typedef struct { short a[3]; } S6;

#define DEF1(T, op) T mod_##T(int k, T x) { op; return x; }
DEF1(S1, x.a += k)
DEF1(S2, x.a += k)
DEF1(S3, x.a += k; x.b += k; x.c += k)
DEF1(S4f, x.f += k)
DEF1(S5, for (int i = 0; i < 5; i++) x.a[i] += k)
DEF1(S6, for (int i = 0; i < 3; i++) x.a[i] += k)
DEF1(S8f, x.a += k; x.b += k)
DEF1(S8d, x.d += k)
DEF1(S8m, x.a += k; x.b += k)
DEF1(S9, for (int i = 0; i < 9; i++) x.a[i] += k)
DEF1(S12f, x.a += k; x.b += k; x.c += k)
DEF1(S12i, x.a += k; x.b += k; x.c += k)
DEF1(S13, for (int i = 0; i < 13; i++) x.a[i] += k)
DEF1(S16d, x.a += k; x.b += k)
DEF1(S16m, x.a += k; x.b += k)
DEF1(S16ffd, x.a += k; x.b += k; x.c += k)
DEF1(S17, for (int i = 0; i < 17; i++) x.a[i] += k)
DEF1(S24, x.a += k; x.b += k; x.c += k)
DEF1(U4, x.i += k)
DEF1(U8, x.q += k)
DEF1(SArr, x.a[0] += k; x.a[1] += k; x.a[2] += k; x.b += k)

double fmix(float a, double b, int c, float d, signed char e, short f, float g, double h, float i)
{
    return a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000.0 + g * 1e6 + h * 1e7 + i * 1e8;
}

double vsum(int n, ...)
{
    va_list ap; va_start(ap, n);
    double s = 0;
    for (int i = 0; i < n; i++) s += va_arg(ap, double);
    va_end(ap);
    return s;
}

long long vsumi(int n, ...)
{
    va_list ap; va_start(ap, n);
    long long s = 0;
    for (int i = 0; i < n; i++) s = s * 10 + va_arg(ap, int);
    va_end(ap);
    return s;
}

typedef S12f (*cb12)(S12f, float, S3);
double call_cb(cb12 f)
{
    S12f a = { 1.5f, 2.5f, 3.5f };
    S3 b = { 1, 2, 3 };
    S12f r = f(a, 0.25f, b);
    return r.a * 100 + r.b * 10 + r.c;
}

typedef S16d (*cb16)(int, S16d, S5);
double call_cb16(cb16 f)
{
    S16d a = { 1.0, 2.0 };
    S5 b = { {1, 2, 3, 4, 5} };
    S16d r = f(7, a, b);
    return r.a * 1000 + r.b;
}

/* many args: register pressure past 6 int / 8 sse regs */
double many(S16d a, S16d b, S16d c, S16d d, S16d e, S12f f, S8f g, int h)
{
    return a.a + b.b * 10 + c.a * 100 + d.b * 1000 + e.a * 10000 + f.c * 100000.0 + g.b * 1e6 + h * 1e7;
}
