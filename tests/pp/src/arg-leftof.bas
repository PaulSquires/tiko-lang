'' __FB_ARG_LEFTOF__ and __FB_ARG_RIGHTOF__ -- the tokens on one side of a needle.
''
'' Measured by reading 'fbc -pp' output, one probe per row. Three of the rules are not
'' guessable and each is asserted below:
''
''   a needle of more than ONE token never matches, however it is spelled
''   an EMPTY RESULT -- not a missing needle -- is what reaches for the third argument
''   an empty TEXT does not reach for it, even though its result is empty too
''
'' They were absent entirely, so every use expanded to nothing. fbcunit's own
'' 'for each' macro is built out of both of them, which is why gfx/blender-alpha4.bas
'' declined fourteen statements on one line.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

#define A 1
#define B 2
#define C 3
#define X 12
#define E 1 TO 2
#define F TO
#define ZZ 99

assert_( __FB_ARG_LEFTOF__( 1 2 3, 2 ) = 1 )
assert_( __FB_ARG_RIGHTOF__( 1 2 3, 2 ) = 3 )
assert_( __FB_ARG_LEFTOF__( 1 TO 2, TO ) = 1 )

'' The needle is matched CASE-INSENSITIVELY, like every other FreeBASIC name.
assert_( __FB_ARG_LEFTOF__( 1 TO 2, to ) = 1 )

'' Text, needle and fallback are all macro-expanded first.
assert_( __FB_ARG_LEFTOF__( E, F ) = A )
assert_( __FB_ARG_RIGHTOF__( E, F ) = B )
assert_( __FB_ARG_LEFTOF__( X C, C ) = X )
assert_( __FB_ARG_RIGHTOF__( X C, X ) = C )

'' Not found, with and without a fallback.
assert_( __FB_QUOTE__( __FB_ARG_LEFTOF__( A B, C ) ) = "" )
assert_( __FB_ARG_LEFTOF__( A B, C, X ) = 12 )
assert_( __FB_QUOTE__( __FB_ARG_RIGHTOF__( X C, B ) ) = "" )
assert_( __FB_ARG_RIGHTOF__( X C, B, A ) = 1 )

'' FOUND, and the side asked for is empty: the fallback fires here too.
assert_( __FB_ARG_LEFTOF__( a b, a, ZZ ) = 99 )
assert_( __FB_ARG_RIGHTOF__( a b, b, ZZ ) = 99 )

'' A MULTI-TOKEN NEEDLE NEVER MATCHES.
assert_( __FB_ARG_LEFTOF__( a b c, a b, ZZ ) = 99 )
assert_( __FB_QUOTE__( __FB_ARG_RIGHTOF__( a b c d, b c ) ) = "" )

'' The FIRST occurrence, not the last.
assert_( __FB_QUOTE__( __FB_ARG_LEFTOF__( 1 2 1 2, 2 ) ) = "1" )
assert_( __FB_QUOTE__( __FB_ARG_RIGHTOF__( 1 2 1 2, 1 ) ) = "2 1 2" )

'' Parentheses are ordinary tokens here; nothing is unwrapped.
assert_( __FB_QUOTE__( __FB_ARG_LEFTOF__( (1 2) 3, 3 ) ) = "(1 2)" )
