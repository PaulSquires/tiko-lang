'' An OBJECT-LIKE macro may be redefined with an IDENTICAL token sequence; a
'' FUNCTION-LIKE one may not be redefined at all. Measured, and neither half is
'' obvious -- C allows the identical redefinition for both:
''
''   #define X _Y   twice                    accepted
''   #define X _Y  then  #define X _Z        fbc error 4
''   #define F(a) a  twice                   fbc error 4
''   #define X   _Y  then  #define X _Y      accepted -- TOKENS, not text
''
'' 29 corpus files failed on this one rule: windows.bi defines InterlockedIncrement in
'' winnt.bi and again in winbase.bi, both under '#ifdef __FB_64BIT__' and both genuinely
'' active on win64.

#define X _Y
#define X _Y

'' Spacing is not part of the comparison.
#define S   _T
#define S _T

'' A function-like macro defined once is fine; redefining one is not, so it is not
'' exercised here.
#define F( a ) a

print X, S, F( 1 )
