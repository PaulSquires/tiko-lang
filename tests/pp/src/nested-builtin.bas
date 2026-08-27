'' A NESTED PP BUILTIN WHOSE ')' IS THE LAST TOKEN OF THE FRAME AROUND IT.
''
'' PeekTok pops exhausted frames until it finds a token, and it had NO FLOOR. When the
'' inner builtin's closing paren ended the macro body, the cascade ran on past that frame
'' and past the enclosing one, deleting both -- so the inner builtin pushed its result
'' onto a stack shorter than the outer walk's own baseDepth. The outer walk stopped
'' immediately and returned an EMPTY string, and the orphaned frame drained into the main
'' output as stray tokens.
''
''     #define q __FB_QUOTE__( __FB_ARG_COUNT__( a, b, c ) )
''     print q       fbc: print $"3"      before: an empty string, then a stray 3
''
'' The boundary is exact and was measured: the same body with anything after the inner
'' ')' -- another token, an operator, a second operand -- was always right. Only "last
'' token of the frame" was wrong, which is why it survived every test until a corpus file
'' wrote a synthesised '#define' that runs to end of line.
#define q __FB_QUOTE__( __FB_ARG_COUNT__( a, b, c ) )
#define r __FB_QUOTE__( __FB_ARG_COUNT__( a, b ) zz )
#define s __FB_QUOTE__( __FB_ARG_COUNT__( a ) ) + ""

print q
print r
print s
