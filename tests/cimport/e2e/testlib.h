/* testlib.h -- a C library used from FreeBASIC through #cinclude, by build/cimporte2e.sh.
   Freestanding. Every struct size the three ABIs pass differently, by value both ways:
   4 and 8 in one register everywhere, 12 and 16 in two on SysV and by pointer on win64,
   24 in memory everywhere. And a callback, a variadic, and globals. */
#ifndef TESTLIB_H
#define TESTLIB_H

typedef struct { int a; } tl4_t;
typedef struct { int a, b; } tl8_t;
typedef struct { int a, b, c; } tl12_t;
typedef struct { double x; int n; } tl16_t;
typedef struct { double x, y, z; } tl24_t;

tl4_t  tl_make4(int a);
tl8_t  tl_make8(int a, int b);
tl12_t tl_make12(int a, int b, int c);
tl16_t tl_make16(double x, int n);
tl24_t tl_make24(double x, double y, double z);

int    tl_sum4(tl4_t v);
int    tl_sum8(tl8_t v);
int    tl_sum12(tl12_t v);
double tl_sum16(tl16_t v);
double tl_sum24(tl24_t v);

typedef int (*tl_callback)(int value, void *user);
int    tl_apply(tl_callback cb, void *user, int from, int to);

int    tl_sumv(int count, ...);

extern int tl_counter;
extern const char *tl_name;

#define TL_VERSION 3

#endif
