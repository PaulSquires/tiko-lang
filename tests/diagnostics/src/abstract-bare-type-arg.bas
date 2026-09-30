'' A bare type( ) for a parameter of an abstract type -- fbc's error 306 on the refused line.
type A extends object
    declare abstract sub f( )
end type
type B extends object
    i as integer
end type
sub foo( byref x as A )
end sub
sub bar( byref x as B )
end sub
foo( type( ) )                                      '' 306
bar( type( ) )                                      '' fine
