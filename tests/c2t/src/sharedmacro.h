/* sharedmacro.h -- raylib's shape: a shared-build macro that makes a variable dllimport (D25). */
#ifndef MYLIB_H
#define MYLIB_H
#if defined(_WIN32) && defined(MYLIB_SHARED)
#define MYAPI __declspec(dllimport)
#else
#define MYAPI
#endif
MYAPI extern int mylib_count;
MYAPI int mylib_get(void);
#endif
