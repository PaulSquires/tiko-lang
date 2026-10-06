enum E
	A
	B = 5
	C
	D = B * 2
end enum
#macro chk( cond, tag )
	#if cond
		print tag; " ";
	#else
		print "-"; " ";
	#endif
#endmacro
chk( C = 6, "e1" )
chk( D = 10, "e2" )
chk( A = 0, "e3" )
chk( A < B, "e4" )
chk( C = 5, "e5" )
print
