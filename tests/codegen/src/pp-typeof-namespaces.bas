#macro chk( a, b, tag )
	#if typeof( a ) = typeof( b )
		print tag; " ";
	#else
		print "-"; " ";
	#endif
#endmacro
type T
	__ as long = 1
end type
namespace N1
	type T
		__ as long = 2
	end type
	sub p1()
		chk( T, N1.T, "a" )
		chk( T, ..T, "b" )
	end sub
end namespace
namespace N2
	using N1
	sub p2()
		chk( T, ..T, "c" )
		chk( N2.T, N1.T, "d" )
	end sub
end namespace
namespace N3
	using N1
	type T
		__ as long = 3
	end type
	sub p3()
		chk( T, N3.T, "e" )
		chk( T, N1.T, "f" )
	end sub
end namespace
sub m()
	chk( N1.T, N1.T, "g" )
	chk( T, ..T, "h" )
	using N3
	chk( T, ..T, "i" )
end sub
N1.p1 : N2.p2 : N3.p3 : m
print
