/* enummacro.h -- enumerators a function-like macro writes, numbered as clang numbers them. */
#define OPTTYPE_LONG 0
#define OPTTYPE_STRING 10000
#define OPT(na, t, nu) na = t + nu

typedef enum {
    OPT(OPT_PORT, OPTTYPE_LONG, 3),
    OPT(OPT_URL, OPTTYPE_STRING, 2),
    OPT_NEXT,
    OPT_LAST = 20000
} Option;
