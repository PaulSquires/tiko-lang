sub f() static
	dim n as integer
	dim s as string
	n += 1
	s &= "x"
	print n; " "; s
end sub
f : f : f
function g( byval k as integer ) as integer static
	dim acc as integer
	acc += k
	return acc
end function
print g( 1 ), g( 2 ), g( 3 )
