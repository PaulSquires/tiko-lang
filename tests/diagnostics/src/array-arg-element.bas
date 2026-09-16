'' THE OTHER HALF: what a bydesc parameter still refuses. Both lines are fbc error 58,
'' "Type mismatch", measured -- an ELEMENT of the member array, and a scalar field
'' beside it. Accepting 'm.arr( )' must not widen into accepting 'm.arr( 0 )'.
type Holder
    arr( any ) as long
    n as long
end type
sub fill_( a( ) as long, byval hi as long )
    redim a( hi )
end sub
dim as Holder m
redim m.arr( 3 )
fill_( m.arr( 0 ), 3 )
fill_( m.n, 3 )
