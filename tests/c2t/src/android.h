/* android.h -- Android's passes beside Windows, Linux and macOS: Android's own branch, what
   Linux and Android share, and what differs between Android's two architectures. */
#ifndef ANDROID_H
#define ANDROID_H

#include <stdint.h>

/* The same on every target: written once. */
int an_shared(int32_t n);

/* Android's own branch comes first: Android defines __linux__ too. */
#if defined(__ANDROID__)
typedef struct an_lock { int32_t w[10]; } an_lock;      /* Bionic's: 40 bytes, 4-aligned */
#elif defined(__linux__)
typedef struct an_lock { int64_t w[5]; } an_lock;       /* glibc's: 40 bytes, 8-aligned */
#else
typedef struct an_lock { void *p; } an_lock;
#endif
int an_lock_init(an_lock *l);

/* A Linux kernel, Linux's and Android's alike: tiko says both. */
#ifdef __linux__
int an_kernel_fn(void);
#endif
#ifndef __unix__
int an_not_unix_fn(void);
#endif

/* glibc's alone: clang defines no __gnu_linux__ for Android. */
#ifdef __gnu_linux__
int an_glibc_fn(void);
#endif

/* An architecture inside Android: the header's own #if selects. */
#if defined(__ANDROID__) && defined(__aarch64__)
int an_android_arm64_fn(void);
#endif

/* The merge: long on Linux and Android, long long on Windows and macOS -- a union guard. */
typedef __INT64_TYPE__ an_i64;

/* A plain char is unsigned on aarch64 Android alone: guarded by the architecture. */
typedef struct an_chr { char c; int n; } an_chr;

/* Android's API level has no tiko name: the conditional stays C. */
#if defined(__ANDROID_API__) && __ANDROID_API__ >= 26
int an_api26_fn(void);
#endif

#endif
