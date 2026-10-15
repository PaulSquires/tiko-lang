/* reinc.h -- g.h again, after a.h has included it: clang does not enter it twice. */
#pragma once
#include "sub/a.h"
#include "sub/g.h"
int ri_f(g_id x);
