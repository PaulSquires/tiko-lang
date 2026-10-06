dim shared as integer dtors, lets
type UDT
	i as integer
	declare destructor( )
	declare operator let( byref rhs as UDT )
end type
destructor UDT( )
	dtors += 1
end destructor
operator UDT.let( byref rhs as UDT )
	lets += 1
end operator
function f( byval x as UDT ) as integer
	function = x.i
end function
scope
	dim x as UDT
	x.i = 123
	print f( x ), dtors, lets
end scope
print dtors, lets
dtors = 0
scope
	print f( type( 123 ) ), dtors, lets
end scope
print dtors, lets
