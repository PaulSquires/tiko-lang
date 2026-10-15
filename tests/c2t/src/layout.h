/* layout.h -- records whose bit-fields MSVC and SysV lay out differently: written with
   'extern "c"', tiko lays each out by its target's C rule, and --verify agrees with clang. */
#ifndef LAYOUT_H
#define LAYOUT_H

struct Mixed { char a : 3; int b : 5; };        /* MSVC starts a new unit at 'int' */
struct Plain { unsigned x : 3; unsigned y : 5; char c; };
struct Holds { struct Mixed m; int n; };        /* holds one by value */
void take(struct Mixed *m, struct Plain *p);    /* and a pointer to each */

#endif
