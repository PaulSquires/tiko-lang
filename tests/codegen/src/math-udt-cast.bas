type F
    v as double
    declare operator cast( ) as double
end type
operator F.cast( ) as double
    return v
end operator
type G
    v as long
    declare operator cast( ) as long
    declare operator cast( ) as string
end type
operator G.cast( ) as long
    return v
end operator
operator G.cast( ) as string
    return "g"
end operator
dim as F f1 = ( 2.5 )
dim as F f2 = ( -3.75 )
dim as G g1 = ( -9 )
print sqr( f1 )
print abs( f2 ); int( f2 ); fix( f2 ); frac( f2 ); sgn( f2 )
print abs( g1 ); sgn( g1 ); sqr( abs( g1 ) )
print exp( f1 ); log( f1 ); atn( f1 )
print sqr( f1 ) + 1; atan2( 1.0, f1 ); atan2( f2, 2 )
type S
    v as single
    declare operator cast( ) as single
end type
operator S.cast( ) as single
    return v
end operator
dim as S s1 = ( 2.5 )
print sqr( s1 ); abs( s1 ); int( s1 )
dim as double r = sqr( f1 )
print r
