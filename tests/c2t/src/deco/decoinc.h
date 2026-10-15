/* decoinc.h -- includes a decoration-only pair (begin/end) and a macros-only header. */
#pragma once
#include "deco/limits.h"
#include "deco/begin.h"

DECO_API void *DECO_CALL deco_malloc(int size) DECO_MALLOC;   /* a function, not the macro */
DECO_API int DECO_CALL deco_level(void);

#include "deco/end.h"
