'' See ../bydesc-udt-builtin.test.
type D
    as long lo, mid_, hi_, flags
end type
type E
    as longint v
end type
sub f( a( ) as longint )
end sub
sub g( a( ) as D )
end sub
sub k overload ( a( ) as longint )
end sub
sub k overload ( a( ) as string )
end sub
dim w( 0 to 1 ) as D
dim e8( 0 to 1 ) as E
dim l( 0 to 1 ) as longint
dim s( 0 to 1 ) as string
f( w( ) )
f( e8( ) )
g( l( ) )
g( s( ) )
k( w( ) )
f( l( ) )
g( w( ) )
k( l( ) )
k( s( ) )
