'' A UDT WITH NO POINTER CAST FOR A POINTER PARAMETER. Measured on fbc-modern: a type casting to
'' string into 'zstring ptr' and 'any ptr', and one casting to long into 'long ptr', are error 58
'' (lines 18-20); a literal into 'zstring ptr' compiles (21).
type S1
    as long q
    declare operator cast( ) as string
end type
operator S1.cast( ) as string : return "ab" : end operator
type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : return 3 : end operator
sub kz( byval x as zstring ptr ) : end sub
sub ka( byval x as any ptr ) : end sub
sub kl( byval x as long ptr ) : end sub
dim as S1 sv : dim as M1 mv
kz( sv )
ka( sv )
kl( mv )
kz( "abc" )
