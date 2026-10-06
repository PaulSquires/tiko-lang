type bar
	as integer v
	declare constructor( byval x as integer )
	declare destructor( )
end type
constructor bar( byval x as integer )
	v = x * 10 : print "ctor"; x
end constructor
destructor bar( )
	print "dtor"; v
end destructor
dim shared as bar b1(1 to 3) = { bar(1), bar(2), bar(3) }
print b1(1).v; b1(2).v; b1(3).v
type UDT
	as string s
	declare constructor( byref t as string )
end type
constructor UDT( byref t as string )
	s = t
end constructor
dim shared g_array(0) as UDT = { UDT( "string1" ) }
print g_array(0).s
type dq
	as integer v
	declare constructor( )
	declare constructor( byval x as integer )
end type
constructor dq( )
	v = -1
end constructor
constructor dq( byval x as integer )
	v = x
end constructor
dim shared as dq q(0 to 3) = { dq( 5 ), dq( 6 ) }
print q(0).v; q(1).v; q(2).v; q(3).v
