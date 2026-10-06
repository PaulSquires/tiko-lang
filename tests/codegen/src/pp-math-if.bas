#macro chk( cond, tag )
	#if cond
		print tag; " ";
	#else
		print "-"; " ";
	#endif
#endmacro
chk( frac( 1.5 ) = .5, "m1" )
chk( frac( 2 ) = 0, "m2" )
chk( int( -1.5 ) = -2, "m3" )
chk( fix( -1.5 ) = -1, "m4" )
chk( int( 7 ) = 7, "m5" )
chk( sqr( 16 ) = 4, "m6" )
chk( abs( -2.5 ) = 2.5, "m7" )
chk( sgn( -0.25 ) = -1, "m8" )
chk( frac( -1.25 ) = -.25, "m9" )
print "end"
