#define P 1, 2
#define NumList 0, 1, 2, 3
#define GetNumList() NumList
#define CONCAT_INT( x, y... ) x, y
#define CONCAT( x, y... ) CONCAT_INT( x, y )
#define L2 1, 2
#define L3 CONCAT( L2, 3 )

dim as long a = __FB_ARG_COUNT__( P )
dim as long b = __FB_ARG_COUNT__( P, 9 )
dim as long c = __FB_ARG_EXTRACT__( 0, P, 9 )
dim as long d = __FB_ARG_EXTRACT__( 2, P, 9 )
'' ...through a function-like macro, and through one CONCAT level.
dim as long e_ = __FB_ARG_EXTRACT__( 3, GetNumList( ) )
dim as long f = __FB_ARG_EXTRACT__( 2, L3 )
'' ...and forwarded through a variadic parameter.
#macro nx( n, args... )
    dim as long g = __FB_ARG_EXTRACT__( n, args )
#endmacro
nx( 1, 7, 8, 9 )

print a, b, c, d, e_, f, g
