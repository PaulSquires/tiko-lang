'' __FB_ARG_EXTRACT__ re-splits on commas outside strings, and an escaped string skips the character after a backslash
#macro nested1( n, arg0, arg1, arg3 )
	__FB_UNQUOTE__( "#define n1 " ) __FB_QUOTE__( arg1 )
#endmacro
#macro nestedX( n, args... )
	__FB_UNQUOTE__( "#define nx " ) __FB_QUOTE__( __FB_ARG_EXTRACT__( n, args ) )
#endmacro
nested1( 1, 1, !"\\\"""2,3", 3 )
nestedX( 1, 1, !"\\\"""2,3", 3 )
print n1
print nx
print __FB_QUOTE__( !"\\\"""2,3" )
#define n2 $"!""\\\""""""2,3"""
print n2
