type UDT
	i as integer
end type
dim shared as integer globalarray(0 to 3) = { 1, 2, 3, 4 }
function f( array() as integer ) as integer
	function = type( array(3) )
end function
function g( byval k as integer ) as integer
	return type( k + 1 )
end function
function h( array() as integer ) as UDT
	function = type( array(2) )
end function
function hr( byval k as integer ) as UDT
	return type( k * 2 )
end function
dim as double d = type( 2.5 )
dim as integer n
n = type( 41 + 1 )
dim as UDT u = type( 9 )
print f( globalarray() ), g( 7 ), d, n
print h( globalarray() ).i, hr( 5 ).i, u.i
