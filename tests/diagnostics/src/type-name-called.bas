'' See tests/diagnostics/type-name-called.test.
type SOCK as uinteger
enum E
    A
end enum
type U
    v as long
    declare constructor( byval x as long )
end type
constructor U( byval x as long )
    v = x
end constructor
sub g( byval n as long )
end sub
dim s as SOCK

s = sock( 1, 2, 3 )
print sock( 1 )
g sock( 1 )
dim e1 as long = E( 1 )
dim i as long = int32( 5 )
sock( 1 )

'' legal: a UDT's name called is its constructor
dim u1 as U = U( 4 )
print u1.v
