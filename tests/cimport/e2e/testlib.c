#include <stdarg.h>
#include "testlib.h"

int tl_counter = 41;
const char *tl_name = "testlib";

tl4_t  tl_make4(int a) { tl4_t r = { a }; tl_counter++; return r; }
tl8_t  tl_make8(int a, int b) { tl8_t r = { a, b }; return r; }
tl12_t tl_make12(int a, int b, int c) { tl12_t r = { a, b, c }; return r; }
tl16_t tl_make16(double x, int n) { tl16_t r = { x, n }; return r; }
tl24_t tl_make24(double x, double y, double z) { tl24_t r = { x, y, z }; return r; }

int    tl_sum4(tl4_t v) { return v.a; }
int    tl_sum8(tl8_t v) { return v.a + v.b; }
int    tl_sum12(tl12_t v) { return v.a + v.b + v.c; }
double tl_sum16(tl16_t v) { return v.x + v.n; }
double tl_sum24(tl24_t v) { return v.x + v.y + v.z; }

int tl_apply(tl_callback cb, void *user, int from, int to) {
    int total = 0;
    for (int i = from; i <= to; i++) total += cb(i, user);
    return total;
}

int tl_sumv(int count, ...) {
    va_list ap;
    int total = 0;
    va_start(ap, count);
    for (int i = 0; i < count; i++) total += va_arg(ap, int);
    va_end(ap);
    return total;
}
