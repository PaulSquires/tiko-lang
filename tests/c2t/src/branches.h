/* branches.h -- what the corpus found: #pragma once, a taken branch that opens with a
   false nested #if (glfw3.h's APIENTRY), MinGW conditions, directives inside a body. */
#pragma once

#if !defined(_WIN32) && (defined(__WIN32__) || defined(__MINGW32__))
 #define _WIN32
#endif

#if !defined(BR_ENTRY)
 #if defined(_WIN32)
  #define BR_ENTRY_WIN 1
 #else
  #define BR_ENTRY_WIN 0
 #endif
 #define BR_ENTRY_DEFINED
#endif

int br_init(void);

/* raymath.h's shape: a directive inside an inline function's body is the body's. */
inline int br_equals(float x, float y)
{
#if !defined(BR_EPSILON)
    #define BR_EPSILON 0.000001f
#endif
    return (x - y) < BR_EPSILON;
}

static inline int br_twice(int x)
{
#ifdef BR_SLOW
    return x + x;
#else
    return x * 2;
#endif
}

/* sqlite3.h's shape: an #undef no pass reaches is written when the #if around it is, and
   stays a TODO under one that is not. */
#ifdef BR_VERSION
# undef BR_VERSION
#endif
#if defined(BR_NEVER) && (BR_NEVER / 0)
# undef BR_NEVER
#endif
/* ...and never one of a tiko keyword, reached or not: it would remove the keyword. */
#ifdef BR_OMIT_FLOAT
# undef double
#endif
#undef integer
