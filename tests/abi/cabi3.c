/* cabi3.c -- C's __int128 against tiko's int128 / uint128 (fabi3.bas).
   Every value crosses the boundary in both directions: as an argument, as a result, in a
   16-aligned struct field, through a struct passed and returned by value, after the
   argument registers run out, and back into tiko through a callback. gcc for SysV
   (build/abilane.sh), clang for x86_64-pc-windows-msvc (the same script's win64 half). */

#include <stdarg.h>

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

/* varargs both ways: an __int128 read with va_arg after a 64-bit one, and a tiko variadic
   (T3_VSUM, cva_arg) called from C. win64 passes the 16-byte ones by address. */
i128 c3_vmix( int n, ... )
{
    va_list ap;
    va_start( ap, n );
    long long k = va_arg( ap, long long );
    i128 s = k;
    for( int i = 1; i < n; i++ ) s += va_arg( ap, i128 );
    va_end( ap );
    return s;
}

extern i128 T3_VSUM( int n, ... );

i128 c3_calls_vsum( void ) { return T3_VSUM( 3, (i128)1 << 100, (i128)-5, (i128)7 ); }

/* six: the GP save area runs out, so the later ones come from the 16-aligned overflow area */
i128 c3_calls_vsum6( void ) { return T3_VSUM( 6, (i128)1 << 100, (i128)-5, (i128)7, (i128)1 << 90, -((i128)1 << 70), (i128)11 ); }
