/* stand-in <sys/types.h> (see ../README): size_t, ssize_t (long), off_t (Darwin's __int64_t,
** long long) -- what zconf.h's z_off_t and the gz* routines use. */
#pragma once
#include <stddef.h>
typedef long ssize_t;
typedef long long off_t;
