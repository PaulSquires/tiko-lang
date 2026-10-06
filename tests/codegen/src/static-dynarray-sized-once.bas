sub t1
	dim as integer l = 5, u = 6
	static array2(l to u) as integer
	print lbound( array2 ), ubound( array2 )
end sub
t1
sub f( byval pass as integer ) static
	redim array(1 to 2) as integer
	if( pass = 2 ) then redim array(3 to 4)
	print pass, lbound( array ), ubound( array )
end sub
f 1 : f 2 : f 3
