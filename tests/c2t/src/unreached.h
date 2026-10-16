/* unreached.h -- branches no pass takes, translated by forcing each one on. */
#ifndef UNREACHED_H
#define UNREACHED_H

#include <stdint.h>

typedef struct ur_ctx ur_ctx;

/* An untaken #ifdef: a typedef, a function, macros -- one whose value only clang knows. */
#ifdef UR_WITH_EXTRA
typedef int32_t ur_extra_t;
#define UR_EXTRA_MAX   (1 << 4)
#define UR_EXTRA_CAST  ((unsigned char)300)
int ur_extra(ur_ctx *c, ur_extra_t n);
#endif

/* An #elif chain: the first branch is taken, the two after it are not. */
#if defined(_WIN32) || defined(__linux__)
#define UR_KIND 1
#elif defined(__APPLE__)
#define UR_KIND 2
int ur_apple_only(void);
#else
#define UR_KIND 3
int ur_elsewhere(void);
#endif

/* Nested: both branches inside an untaken one are untaken too. */
#ifdef UR_WITH_OUTER
#define UR_OUTER_ON 1
#ifdef UR_WITH_INNER
int ur_inner(int x);
#else
int ur_outer(int x);
#endif
#endif

/* An #error is a branch's way of saying 'not here'; what follows it is translated. */
#ifdef UR_WITH_STRICT
#error "UR_WITH_STRICT is not supported"
int ur_strict(void);
#endif

/* A test of the compiler is the program's to answer: kept as written, every branch
   translated for each target. */
#if defined(_MSC_VER)
typedef unsigned __int64 ur_u64;
#elif defined(__GNUC__) && __GNUC__ >= 4
typedef unsigned long long ur_u64;
#else
typedef unsigned long ur_u64;
#endif
#ifdef __clang__
#define UR_CC 1
#else
#define UR_CC 2
#endif

/* Under a conditional c2t cannot translate, an untaken branch stays C. */
#if defined(UR_UNSTATABLE) && (UR_UNSTATABLE / 0)
#define double long
#endif

/* Headers this host does not have are left out of the parse; the rest is translated. */
#ifdef UR_WITH_MISSING
#include "ur_does_not_exist.h"
#include <ur_sys_does_not_exist.h>
int ur_missing(void);
#endif

/* A branch clang cannot parse even when forced on keeps its TODO. */
#ifdef UR_WITH_CXX
template <class T> T ur_twice(T x);
#endif

#endif
