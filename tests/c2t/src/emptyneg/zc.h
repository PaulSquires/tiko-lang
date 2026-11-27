/* zc.h -- zconf.h's test of _LARGEFILE64_SOURCE, which an includer may define empty. */
#if defined(_LARGEFILE64_SOURCE) && -_LARGEFILE64_SOURCE - -1 == 1
#  define ZC_ZERO 1
#elif defined(_LARGEFILE64_SOURCE) && -_LARGEFILE64_SOURCE - -1 == -1
#  define ZC_EMPTY 1
#endif
int zc_f(void);
