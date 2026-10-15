/* layout.h -- records tiko lays out differently from clang (MSVC bit-field rules), which
   --verify refuses; what holds one by value goes with it, a pointer to one stays. */
#ifndef LAYOUT_H
#define LAYOUT_H

struct Mixed { char a : 3; int b : 5; };        /* MSVC starts a new unit at 'int' */
struct Plain { unsigned x : 3; unsigned y : 5; char c; };
struct Holds { struct Mixed m; int n; };        /* holds a refused record by value */
void take(struct Mixed *m, struct Plain *p);    /* a pointer to one is fine */

#endif
