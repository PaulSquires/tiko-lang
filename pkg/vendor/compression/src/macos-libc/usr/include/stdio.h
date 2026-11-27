/* stand-in <stdio.h> (see ../README): size_t and an incomplete FILE (Darwin's struct __sFILE) --
** all ioapi.h and bzlib.h use. */
#pragma once
#include <stddef.h>
typedef struct __sFILE FILE;
