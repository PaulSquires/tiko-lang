'' A UDT WHERE FBC TAKES NO CAST. Measured on fbc-modern over M1 (cast to long), S1 (to string), P1
'' (none): 'select case' on any is 24 (lines 18, 21, 24); hex, oct, whex of M1 98 (27-29); chr and
'' wchr of M1 58 (30-31), as is string( )'s fill over S1 (32); over M1 it compiles (33).
type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : return q : end operator
type S1
    as long q
    declare operator cast( ) as string
end type
operator S1.cast( ) as string : return "x" : end operator
type P1
    as long q
end type
dim as M1 a : dim as S1 b : dim as P1 c
select case a
case 1 : print 1
end select
select case b
case else : print 2
end select
select case c
case else : print 3
end select
print hex( a )
print oct( a )
print whex( a )
print chr( a )
print wchr( a )
print string( 2, b )
print string( 65, a )
