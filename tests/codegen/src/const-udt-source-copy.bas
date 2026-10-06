dim shared as integer ctors, copyctors, lets
type Nested
	i as integer
	declare constructor( )
	declare constructor( byref rhs as const Nested )
	declare operator let( byref rhs as const Nested )
end type
constructor Nested( )
	ctors += 1
end constructor
constructor Nested( byref rhs as const Nested )
	copyctors += 1
end constructor
operator Nested.let( byref rhs as const Nested )
	this.i = rhs.i
	lets += 1
end operator
type UDT
	myfield as Nested
end type
type SU
	s as string
	declare constructor( byref as string )
end type
constructor SU( byref s as string )
	this.s = s
end constructor
scope
	dim x1 as const UDT = UDT( )
	dim x2 as UDT = x1
	print ctors, copyctors, lets
	dim x3 as UDT
	x3 = x1
	print ctors, copyctors, lets
end scope
scope
	dim y1 as const SU = SU( "abc" )
	dim y2 as SU = y1
	print y2.s, strptr( y1.s ) <> strptr( y2.s )
	dim y3 as SU = SU( "foo" )
	y3 = y1
	print y3.s, strptr( y1.s ) <> strptr( y3.s )
end scope
