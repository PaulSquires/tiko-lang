function f4 overload( a() as integer, byval x as integer ) as string
	function = "() integer, integer"
end function
function f4 overload( a() as const integer, byval x as double ) as string
	function = "() const integer, double"
end function
function f5 overload( a() as const integer, byval x as integer ) as string
	function = "() const integer, integer"
end function
function f5 overload( a() as integer, byval x as double ) as string
	function = "() integer, double"
end function
dim a(1 to ... ) as integer = {1, 2}
dim ca( 1 to ...) as const integer = {1, 2}
dim i as integer, d as double
print f4( ca(), i )
print f5( ca(), d )
