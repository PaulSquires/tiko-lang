'' A UDT WHERE FBC TAKES NO CAST AT ALL. Measured on fbc-modern over M1 casting to long, S1 to
'' string and P1 with none: 'select case' over any of them is error 24 (lines 18, 21, 24);
'' 'hex', 'oct' and 'whex' of M1 are 98 (27-29); 'chr' and 'wchr' of it 58 (30-31).
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
