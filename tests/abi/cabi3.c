/* cabi3.c -- C's __int128 against tiko's int128 / uint128 (fabi3.bas).
   Every value crosses the boundary in both directions: as an argument, as a result, in a
   16-aligned struct field, through a struct passed and returned by value, after the
   argument registers run out, and back into tiko through a callback. gcc for SysV
   (build/abilane.sh), clang for x86_64-pc-windows-msvc (the same script's win64 half). */

typedef __int128 i128;
typedef unsigned __int128 u128;

i128 c3_mul( i128 a, i128 b, int k ) { return a * b + k; }

u128 c3_shr( u128 x, int n ) { return x >> n; }

/* the int128s land after an int, beside a double, before an int64 */
i128 c3_mix( int a, i128 b, double d, i128 c, long long e ) { return a + b + (i128)d + c + e; }

/* five of them: SysV runs out of GPR pairs and puts the rest on the stack */
i128 c3_many( i128 a, i128 b, i128 c, i128 d, i128 e ) { return a - b + c - d + e; }

struct S3 { char c; i128 v; };

i128 c3_field( struct S3 *p ) { return p->v; }

struct S3 c3_make( i128 v ) { struct S3 s; s.c = 7; s.v = v; return s; }

i128 c3_take( struct S3 s ) { return s.v + s.c; }

extern i128 T3_TWICE( i128 v );

i128 c3_calls( i128 v ) { return T3_TWICE( v ) + 1; }

int c3_sizeof( void ) { return (int)sizeof( struct S3 ); }

int c3_offsetof( void ) { return (int)__builtin_offsetof( struct S3, v ); }
