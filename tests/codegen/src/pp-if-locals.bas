#macro chk( cond, tag )
	#if cond
		print tag; " ";
	#else
		print "-"; " ";
	#endif
#endmacro
const SG = "abc"
sub s
	const N1 = 123
	const S1 = "xyz"
	dim i as integer
	chk( N1 = 123, "a" )
	chk( defined( N1 ), "b" )
	chk( defined( i ), "c" )
	chk( "xyz" = S1, "d" )
	chk( "abc" = SG, "e" )
	print
end sub
s
chk( defined( i ), "f" )
chk( defined( N1 ), "g" )
chk( "test", "h" )
chk( &hFFFFFFFFFFFFFFFFull > 0, "i" )
chk( &h8000000000000000ull > 1, "j" )
chk( &hFFFFFFFFFFFFFFFF > 0, "k" )
print
