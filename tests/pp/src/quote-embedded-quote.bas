'' __FB_QUOTE__ OF AN ARGUMENT THAT CONTAINS A QUOTE.
''
'' A quote inside the argument has to be DOUBLED or it closes the literal early. This
'' expanded through a naive wrap -- '"' & argument & '"' -- so '__FB_QUOTE__( "2,3" )'
'' came back as an EMPTY string plus two stray tokens, and whatever consumed it
'' declined. The same fix was made for '#' long ago and never applied here; the two now
'' share one helper.
''
'' pp/macro-arg-extract.bas declined 27 statements for it, every one an argument that
'' happened to be a string literal.
''
'' Measured with 'fbc -pp': the expansion is '$'-prefixed and the inner quotes are
'' doubled, so a backslash in the argument stays a backslash.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' A '#define' rather than a '#macro': a #macro expanded in EXPRESSION position is
'' a separate gap -- its body carries the EOLs that bracket it, so the statement
'' splits in two -- and this file is about the stringize, not about that.
#define m( a ) __FB_QUOTE__( a )

assert_( m( 5 ) = "5" )
assert_( m( "2,3" ) = """2,3""" )
assert_( __FB_QUOTE__( "x" ) = """x""" )
assert_( __FB_QUOTE__( a b ) = "a b" )

'' A BACKSLASH SURVIVES, which is what the '$' prefix is for.
assert_( len( __FB_QUOTE__( "a\b" ) ) = 5 )
