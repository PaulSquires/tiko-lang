/* sysbind.h -- the C headers tiko-rt's libc binding is imported from, by
   lib/rt/build/genbind.sh. The binding keeps only what the runtime names. */

/* glibc hides the POSIX and BSD names behind a feature test under -std=c11:
   popen, fileno, fseeko, strcasecmp. MinGW ignores it. */
#define _DEFAULT_SOURCE 1

/* MinGW turns on its own "ANSI" stdio for any C99-or-later compile against msvcrt, and
   then strtod, printf and the rest are inline wrappers over __mingw_* -- no symbol of
   their own to bind. tiko-rt calls msvcrt's, as it always has. */
#ifdef _WIN32
#define __USE_MINGW_ANSI_STDIO 0
#endif

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <wchar.h>
#include <wctype.h>
#include <ctype.h>
#include <time.h>
#include <errno.h>
#include <math.h>
#include <stdarg.h>

#ifdef __linux__
#include <strings.h>
#include <unistd.h>
#include <pthread.h>
#endif
