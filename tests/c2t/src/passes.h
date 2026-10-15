/* passes.h -- what differs between Windows and Linux, and between --pass configurations. */
#ifndef PASSES_H
#define PASSES_H

#include <stddef.h>

/* The same on both targets: written once. */
typedef long native_t;                  /* clong is the target's width already */
int shared_fn(native_t n);

/* A different spelling per target: guarded by the merge. */
typedef struct WideCell {
    wchar_t ch;                         /* 2 bytes on Windows, 4 on Linux */
    int     attr;
} WideCell;

/* The header's own platform split: tiko's #ifdef does the selecting. */
#ifdef _WIN32
typedef void *native_handle;
int win_only_fn(native_handle h);
#else
typedef int native_handle;
int posix_only_fn(native_handle fd);
#endif

/* A compiler's identity: the group stays a TODO, and what it holds is guarded by target. */
#if defined(_MSC_VER)
int msvc_only_fn(void);
#endif

/* A feature switch, translated with --pass "-DWITH_EXTRAS". */
#ifdef WITH_EXTRAS
int extras_fn(int level);
#endif

#endif
