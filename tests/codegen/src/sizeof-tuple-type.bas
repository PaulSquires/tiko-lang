'' SIZEOF and LEN of a tuple type written inline, beside the same type named by a typedef.
'' The type keyword, PTR and 'name as T' forms reached the expression parser and stopped
'' the build (TKO0994); the bare-name forms and the expressions below always worked.
type P as (int32, string)
type Q as int32

dim as int32 a = 1, b = 2
dim as string s = "x"

print str( sizeof( (int32, string) ) ); " "; str( len( (int32, string) ) ); " "; str( sizeof( P ) )
print str( sizeof( (int32 ptr, string) ) ); " "; str( sizeof( (n as int32, t as string) ) )
print str( sizeof( ((int32, int32), string) ) ); " "; str( sizeof( (integer, double, ubyte) ) )
print str( sizeof( (Q, string) ) ); " "; str( sizeof( (Q, Q) ) ); " "; str( sizeof( (a, s) ) )
print str( len( string( 3, "a" ) ) ); " "; str( sizeof( (cast( integer, a ), b) ) )
