/* app.h -- includes: a header beside it, one below it, one through -I, system headers. */
#ifndef APP_H
#define APP_H

#include <stdint.h>             /* freestanding: built into tiko */
#include "base.h"               /* beside it */
#include "sub/util.h"           /* below it */
#include <lib/extra.h>          /* through -I: still written relative to this header */

#ifdef _WIN32
#include <stdio.h>              /* tiko's crt/stdio.bi: FILE may now be named */
int app_log(FILE *f, base_id id);
#include <windows.h>            /* windows.bi: every Win32 name may be */
int app_window(HWND w, DWORD flags);
#endif

#include <stdatomic.h>          /* no tiko counterpart: a TODO */

int app_run(base_id id, util_flags f, extra_mode m);

#endif
