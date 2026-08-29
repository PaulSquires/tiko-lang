'' __FB_UNQUOTE__ re-lexes the string literal's VALUE, so a DOUBLED quote inside it is
'' one quote. Taking the text between the first and the last quote left the doubling in
'' place and s was initialised to the EMPTY string; fbc prints 'freebasic'.
__FB_UNQUOTE__( "dim s as string = ""freebasic""" )
print s

'' A '$' prefix is part of the literal, not of its value. QUOTE of a QUOTE yields the
'' inner literal's SOURCE TEXT, '$"freebasic"', so unquoting that gives a literal again
'' rather than the bare identifier that unquoting '$"freebasic"' written by hand gives.
print __FB_UNQUOTE__( __FB_QUOTE__( __FB_QUOTE__( freebasic ) ) )
