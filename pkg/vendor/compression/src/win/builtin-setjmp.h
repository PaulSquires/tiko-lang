/* vendor/compression on Windows (claude-docs tiko-vendor RFC-0006 P0; src/build.sh): forced into minizip's zip.c
 * (-include). Its zipAlreadyThere() recovers from allocation failure with setjmp/longjmp
 * (skipset.h). MSVC's <setjmp.h> spells setjmp as _setjmp, which only Visual Studio's
 * libvcruntime.lib defines -- and a tiko program links ucrtbase.dll alone, no Visual Studio.
 * clang's builtins need no runtime at all: the jump stays inside the library. The value
 * longjmp passes is always 1, which is all zip.c reads (it tests setjmp's result for nonzero). */
#include <setjmp.h>
#undef setjmp
#define setjmp(env) __builtin_setjmp((void **)(env))
#define longjmp(env, val) __builtin_longjmp((void **)(env), 1)
