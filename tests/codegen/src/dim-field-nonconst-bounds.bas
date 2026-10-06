dim shared as integer a = 10
type UDT
	dim array1(a to a) as integer
	redim array2(20 to 20, 30 to 30) as integer
	array3(iif( a > 5, 1, 2 ) to 3) as integer
end type
print sizeof( UDT )
scope
	dim x as UDT
	print lbound( x.array1 ), ubound( x.array1 ), x.array1(10)
	print lbound( x.array2, 2 ), ubound( x.array2, 1 )
	print lbound( x.array3 ), ubound( x.array3 )
end scope
a = 4
scope
	dim x as UDT
	print lbound( x.array1 ), ubound( x.array1 ), x.array1(4)
	print lbound( x.array3 ), ubound( x.array3 )
end scope
