/* inline.h -- inline functions (RFC-0001 D15). */
#ifndef INLINE_H
#define INLINE_H

inline int twice(int x);                          /* links only if the library exports it */

static inline int clamp(int v, int lo, int hi)    /* no symbol: a TODO with its body */
{
    /* the body is quoted whole */
    return v < lo ? lo : (v > hi ? hi : v);
}

static int helper(void);                          /* static, no body here: a TODO too */
int plain(int v);

#endif
