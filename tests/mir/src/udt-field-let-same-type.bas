'' A SYNTHESISED LET CALLS THE FIELD'S SAME-TYPE LET, NOT ITS FIRST-DECLARED ONE.
'' 'b = a' over a UDT with no written let, whose field type declares a converting
'' 'let( byref as const zstring )' BEFORE 'let( byref as Fld )'. tiko took the head of the
'' let chain and handed the converting overload the source field's ADDRESS, so the copy
'' read the field's own bytes as text. AfxNova's DWSTRING has exactly this shape.
''
'' fbc prints: let: abc / copy: abc / array: abc xyz / nested: abc / result: abc
type Fld
	p as zstring ptr
	declare constructor( )
	declare constructor( byref o as Fld )
	declare operator let( byref s as const zstring )
	declare operator let( byref o as Fld )
	declare destructor( )
end type
constructor Fld( )
	p = callocate( 1 )
end constructor
constructor Fld( byref o as Fld )
	p = callocate( len( *o.p ) + 1 )
	*p = *o.p
end constructor
operator Fld.let( byref s as const zstring )
	deallocate( p )
	p = callocate( len( s ) + 1 )
	*p = s
end operator
operator Fld.let( byref o as Fld )
	if( @this = @o ) then exit operator
	deallocate( p )
	p = callocate( len( *o.p ) + 1 )
	*p = *o.p
end operator
destructor Fld( )
	deallocate( p )
end destructor

type Holder
	f as Fld
	n as long = -1
end type

type Pair
	f( 0 to 1 ) as Fld
end type

type Outer
	h as Holder
end type

function MakeH( ) as Holder
	dim as Holder h
	h.f = "abc"
	return h
end function

sub Probe( )
	dim as Holder a
	a.f = "abc"

	dim as Holder b
	b = a
	print "let: "; *b.f.p

	dim as Holder c = a
	print "copy: "; *c.f.p

	dim as Pair p1, p2
	p1.f( 0 ) = "abc"
	p1.f( 1 ) = "xyz"
	p2 = p1
	print "array: "; *p2.f( 0 ).p; " "; *p2.f( 1 ).p

	dim as Outer o1, o2
	o1.h.f = "abc"
	o2 = o1
	print "nested: "; *o2.h.f.p

	dim as Holder r
	r = MakeH( )
	print "result: "; *r.f.p
end sub

Probe( )
