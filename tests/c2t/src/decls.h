/* decls.h -- the declarations c2t P2 translates, and the ones it leaves as TODOs. */
#ifndef DECLS_H
#define DECLS_H

#include <stddef.h>
#include <stdint.h>

/* ---- typedefs */
typedef unsigned int  u32;          /* a scalar */
typedef const char   *cstr;         /* a pointer */
typedef size_t        count_t;      /* a system typedef c2t spells itself */
typedef uint8_t       byte_t;
typedef long          native_t;     /* clong: the target's width */
typedef int (*compare_fn)(const void *a, const void *b);   /* a function pointer */
typedef void handler_fn(int code);  /* a function type, not a pointer: a TODO */

/* ---- records */
struct Later;                       /* defined below: pointers to it are Later__fwd ptr */
typedef struct Opaque Opaque;       /* never defined: pointers to it are Opaque ptr */

typedef struct {
    char    name[16];   /* a string field */
    int     grid[2][3];
    float   scale;
    struct Later *next; /* defined further down */
} Holder;

union Value {
    int    i;
    double d;
};

struct Later {
    Holder *owner;
    struct Later *self; /* itself: Later ptr */
};

typedef struct Packed { char c; int i; } __attribute__((packed)) Packed;   /* P3 */
struct Bits { unsigned a : 3; unsigned b : 5; };                           /* P3 */

/* ---- enums */
enum Mode { MODE_A, MODE_B = 4, MODE_C };
enum { ANON_X = 1, ANON_Y = 2 };
typedef enum { BIG = 0x80000000u } Big;

/* ---- variables */
extern int lib_counter;
extern const char *lib_names[4];

/* ---- functions */
int  print(const char *fmt, ...);              /* 'print' is a tiko word */
void configure(int width,                      /* first */
               // a comment line between parameters
               int height);                    /* last */
void opaque_use(Opaque *o, struct Later *l, Holder h);
compare_fn pick(count_t n, native_t m, u32 flags);
inline int inc(int v);
int legacy();
max_align_t *aligned_block(void);             /* a system type: a TODO */
void use_packed(Packed *p);                    /* a record left as a TODO: Packed ptr */

_Static_assert(sizeof(u32) == 4, "u32");

#endif /* DECLS_H */
