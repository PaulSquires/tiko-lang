'' A SYNTHESISED DIRECTIVE CONTINUES ON THE LINE THAT INVOKED IT.
''
'' '__FB_UNQUOTE__( "#define n1 " ) __FB_QUOTE__( 42 )' re-lexes the first half into an
'' EXPANSION FRAME that ends immediately after 'n1' -- and fbc defines n1 as '"42"',
'' reading on into the rest of the invoking line. Measured: it prints 42 and 7 below.
''
'' Stopping at the frame's end instead defined n1 EMPTY and left the quoted half behind
'' as a stray expression -- 76 declines in pp/macro-arg-extract.bas, which is the file
'' that exists to test exactly this.
''
'' Only an EXPANSION frame is crossed. A FILE frame ends the line whatever follows it: a
'' directive must not run past the end of the file it was written in.
__FB_UNQUOTE__( "#define n1 " ) __FB_QUOTE__( 42 )
print n1

'' ...and from inside a macro, which is how the corpus writes it.
#macro mk( v )
	__FB_UNQUOTE__( "#define n2 " ) __FB_QUOTE__( v )
#endmacro

mk( 7 )
print n2

'' An ordinary directive is unaffected: its own EOL still ends it.
#define plain 5
print plain
