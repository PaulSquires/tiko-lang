#define TWO( a, b ) 2
#if TWO( x, y ) = 2
print "func-like macro expanded"
#endif
#if __FB_ARG_COUNT__( a, b, c ) = 3
print "arg count ok"
#endif
#if sizeof( integer ) = 8
print "integer is 8"
#endif
#if sizeof( long ) = 4
print "long is 4"
#endif
#if typeof( long ) = typeof( long )
print "same type"
#endif
#if typeof( long ) = typeof( double )
print "SHOULD NOT APPEAR"
#endif
