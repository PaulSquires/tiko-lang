'' The type-name argument uses fbc accepts: a UDT name with a constructor builds one, and
'' sizeof, len, cast and an enum member take a type. fbc prints ' 7 7 8 4 2 0'.
type HFOO as any ptr
type M as long
enum E : A : end enum
type U
    as integer v
    declare constructor ( )
end type
constructor U ( ) : v = 7 : end constructor
dim shared as integer total
sub Bar ( byref x as U )
    total += x.v
end sub
function g ( byval n as integer ) as integer : return n : end function
Bar U
Bar( U )
print total \ 2; total \ 2; g( sizeof( HFOO ) ); g( len( M ) ); g( cast( M, 2 ) ); g( E.A )
