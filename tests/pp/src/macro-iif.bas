'' __FB_IIF__( cond, a, b ) -- the PREPROCESSOR's conditional.
''
'' Not the language's IIF: measured with 'fbc -pp', ONLY the selected arm appears in
'' the output, so the other one need not even be well formed. The condition is a
'' constant expression on expanded tokens, the same input '#if' is given.
''
'' It was absent, so every use expanded to nothing -- which is what makes
'' pointers/procptr-low-level-delegate.bas decline forty statements: its whole
'' call_delegate macro is one __FB_IIF__ on the argument count.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

#define A 1
#define B 2
#define C 3
#define Q 7

assert_( __FB_IIF__(  0, 1, 2 ) = 2 )
assert_( __FB_IIF__( -1, 1, 2 ) = 1 )
assert_( __FB_IIF__(  1, 1, 2 ) = 1 )

assert_( __FB_IIF__( A    , 1, 2 ) = 1 )
assert_( __FB_IIF__( A+B  , 1, 2 ) = 1 )
assert_( __FB_IIF__( C-B-A, 1, 2 ) = 2 )

'' The chosen arm is expanded like anything else.
assert_( __FB_IIF__( A, Q, 2 ) = 7 )

'' A multi-token arm passes through whole -- and is EXPANDED like anything else,
'' which is why the tokens here are ones no #define above claims.
assert_( __FB_QUOTE__( __FB_IIF__( 0, p1 p2, p3 p4 ) ) = "p3 p4" )

'' AN EMPTY ARM IS NOT ALLOWED. Measured: '__FB_IIF__( 1, , zz )' is fbc error 1,
'' "Argument count mismatch, expanding: __FB_IIF__" -- an empty argument does not
'' count as one, so the invocation reads as two arguments rather than three.

'' The arm NOT taken is never looked at -- 'this is not an expression' would be a
'' syntax error if it reached the parser.
assert_( __FB_IIF__( 1, 4, this is not an expression ) = 4 )
