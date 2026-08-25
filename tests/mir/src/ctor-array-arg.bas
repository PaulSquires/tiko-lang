type C1
    as integer dummy
    declare constructor( a( ) as integer )
end type
constructor C1( a( ) as integer )
    dummy = a( ubound( a ) )
end constructor
dim shared as integer garr(0 to 3)
dim as C1 b = C1( garr( ) )
sub tester2( byref x as C1 )
    print x.dummy
end sub
tester2( C1( garr( ) ) )
sub tester3( byref x as C1 = C1( garr( ) ) )
    print x.dummy
end sub
tester3( )
