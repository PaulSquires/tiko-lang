/* macrocalls.h -- function-like macros that call functions, declared here or not. */
int twice(int x);
int pair(int a, int b);

#define ALLOC(sz)        malloc(sz)
#define ZALLOC(n, sz)    calloc(n, sz)
#define BOTH(a, b)       pair(twice(a), b + 1)
#define TWO_FREES(p)     free(p), free(p)
#define LENGTH(s)        len(s)
