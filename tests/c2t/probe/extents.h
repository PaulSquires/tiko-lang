/* c2t P0 probe 3: cursor extents of top-level declarations. */
#ifndef EXTENTS_H
#define EXTENTS_H

#define EMPTYAPI
#define DLLAPI __declspec(dllimport)
#define ATTRAPI __attribute__((visibility("default")))
#define DECLARE_HANDLE(n) struct n##__ { int unused; }; typedef struct n##__ *n

EMPTYAPI void f_empty(int a);
DLLAPI void f_dll(int a);
ATTRAPI int f_attr(void) __attribute__((deprecated));
void f_multi(int a,
             int b);   /* trailing */

typedef struct S1 { int x; } S1;
typedef struct { int y; } S2;
int va, vb;

DECLARE_HANDLE(HTHING);
_Static_assert(sizeof(int) == 4, "int is 4");

extern int gvar;
struct Fwd;
typedef struct Fwd Fwd;
enum E { E_A, E_B = 3 };
static inline int f_inline(int v) { return v + 1; }

#endif /* EXTENTS_H */
