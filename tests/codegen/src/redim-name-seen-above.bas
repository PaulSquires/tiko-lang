dim shared a(any) as integer
type UDT
	a(any) as integer
	declare sub f1( )
	declare sub f2( )
	declare sub f3( )
	declare sub f4( )
	declare sub f5( )
end type
sub UDT.f1( )
	redim a(1 to 1)
end sub
sub UDT.f2( )
	redim a(2 to 2) as integer
end sub
sub UDT.f3( )
	dim a(any) as integer
	redim a(0 to 0)
end sub
sub UDT.f4( )
	redim a(4 to 4)
	dim a(any) as integer
	redim a(0 to 0)
end sub
sub UDT.f5( )
	redim a(0 to 0) as string
end sub
dim x as UDT
x.f1( ) : print lbound( a ), ubound( a ), lbound( x.a ), ubound( x.a )
x.f2( ) : print lbound( a ), ubound( a ), lbound( x.a ), ubound( x.a )
x.f3( ) : print lbound( a ), ubound( a ), lbound( x.a ), ubound( x.a )
x.f4( ) : print lbound( a ), ubound( a ), lbound( x.a ), ubound( x.a )
x.f5( ) : print lbound( a ), ubound( a ), lbound( x.a ), ubound( x.a )
