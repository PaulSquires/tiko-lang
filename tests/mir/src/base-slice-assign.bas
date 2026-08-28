'' 'cast( BaseT, this ) = u' IS THE BASE SLICE, and 'this' denotes the OBJECT. Measured
'' -- fbc emits '__builtin_memcpy( THIS, U2, 8 )' for the member below, and it is a
'' real distinction: 'cast( Base, *p )' over a derived OBJECT is accepted while
'' 'cast( Base, p )' over the POINTER is fbc error 20.
type udt2
	dim as integer i21
end type

type udt3 extends udt2
	dim as integer i31
	declare sub m( byref u2 as udt2 )
end type

sub udt3.m( byref u2 as udt2 )
	cast( udt2, this ) = u2
end sub

dim x as udt3
dim y as udt2
y.i21 = 7
x.m( y )
print x.i21
