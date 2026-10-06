'' The '#if' evaluator over literal types (tka-probes/phase4/pb): suffix width, unsigned decimals,
'' NOT, '^' and the C* conversions, as __FB_EVAL__ values and as '#if' truths.
print "2147483648& = "; __FB_EVAL__( 2147483648& )
print "2147483648l = "; __FB_EVAL__( 2147483648l )
print "2147483648! = "; __FB_EVAL__( 2147483648! )
print "4294967295& = "; __FB_EVAL__( 4294967295& )
print "4294967295f = "; __FB_EVAL__( 4294967295f )
print "&hFFFFFFFF& = "; __FB_EVAL__( &hFFFFFFFF& )
print "&hFFFFFFFFl = "; __FB_EVAL__( &hFFFFFFFFl )
print "not 1u = "; __FB_EVAL__( not 1u )
print "not 0ul = "; __FB_EVAL__( not 0ul )
print "3000000000 \ -2 = "; __FB_EVAL__( 3000000000 \ -2 )
print "1ul > -1 = "; __FB_EVAL__( 1ul > -1 )
print "2^10 = "; __FB_EVAL__( 2^10 )
print "-2^2 = "; __FB_EVAL__( -2^2 )
print "2^-1 = "; __FB_EVAL__( 2^-1 )
print "2^3^2 = "; __FB_EVAL__( 2^3^2 )
print "2 * 3 ^ 2 = "; __FB_EVAL__( 2 * 3 ^ 2 )
print "cint( 2.5 ) = "; __FB_EVAL__( cint( 2.5 ) )
print "cint( 3.5 ) = "; __FB_EVAL__( cint( 3.5 ) )
print "clng( 4294967295 ) = "; __FB_EVAL__( clng( 4294967295 ) )
print "cuint( -1 ) = "; __FB_EVAL__( cuint( -1 ) )
print "cbyte( 300 ) = "; __FB_EVAL__( cbyte( 300 ) )
print "cushort( -1 ) = "; __FB_EVAL__( cushort( -1 ) )
print "csng( 1 / 3 ) = "; __FB_EVAL__( csng( 1 / 3 ) )
print "1f / 3 = "; __FB_EVAL__( 1f / 3 )
print "1f / 3f = "; __FB_EVAL__( 1f / 3f )
print "1.5f * 2.5f = "; __FB_EVAL__( 1.5f * 2.5f )
print "1.5f + 1.5 = "; __FB_EVAL__( 1.5f + 1.5 )
print "&hFFFFFFFFu and -1 = "; __FB_EVAL__( &hFFFFFFFFu and -1 )
print "-1u = "; __FB_EVAL__( -1u )
print "-3000000000 = "; __FB_EVAL__( -3000000000 )
#if 3000000000 \ -2 = 0
print "if 0 T"
#else
print "if 0 F"
#endif
#if 1ul > -1
print "if 1 T"
#else
print "if 1 F"
#endif
#if 2147483648& < 0
print "if 2 T"
#else
print "if 2 F"
#endif
#if 4294967295 = -1
print "if 3 T"
#else
print "if 3 F"
#endif
#if not 1u > 0
print "if 4 T"
#else
print "if 4 F"
#endif
#if -2^2 = -4
print "if 5 T"
#else
print "if 5 F"
#endif
#if 2^-1 = 0.5
print "if 6 T"
#else
print "if 6 F"
#endif
#if cint( 2.5 ) = 2
print "if 7 T"
#else
print "if 7 F"
#endif
#if clng( 4294967295 ) = -1
print "if 8 T"
#else
print "if 8 F"
#endif
#if 1.1f = 1.1
print "if 9 T"
#else
print "if 9 F"
#endif
#if csng( 1.1 ) = 1.1f
print "if 10 T"
#else
print "if 10 F"
#endif
#if 1u < -1
print "if 11 T"
#else
print "if 11 F"
#endif
