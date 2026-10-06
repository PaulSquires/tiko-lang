#macro clear_func(__type__)
	sub clear_thing overload ( byref t as __type__ )
		#if typeof(t) = "STRING"
			t = ""
		#else
			t = 0
		#endif
	end sub
#endmacro
clear_func( string )
clear_func( integer )
clear_func( double )
sub show( byval p as long ptr, byref q as single )
	#if typeof( p ) = "LONG PTR"
		print "lp";
	#endif
	#if typeof( q ) = single
		print " sg"
	#endif
end sub
dim as string s = "x"
dim as integer i = 5
dim as double d = 2.5
clear_thing( s ) : clear_thing( i ) : clear_thing( d )
print "[" & s & "]"; i; d
dim as single f
show( 0, f )
