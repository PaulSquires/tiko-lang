'' __FB_EVAL__ RE-EMITS ITS FOLDED VALUE as a canonical literal. Measured against
'' fbc, which answers each of these with:
''
''   "A" + !"\0"          \x41\x00
''   "A" + !"\0" + "B"    \x41\x00\x42
''   !"\\" + "\" + !"\\"  \\
''   !"plain"             plain
''   !"A\tB"              A<tab>B
''
'' -- so a NUL anywhere makes it the hex form for EVERY byte, and everything else is
'' the raw bytes in a '$"..."'. A NUL then ends the string at run time, which is why
'' the first two come back one character long.
dim as string a = __FB_EVAL__( "A" + !"\0" )
dim as string b = __FB_EVAL__( "A" + !"\0" + "B" )
dim as string c = __FB_EVAL__( !"\\" + "\" + !"\\" )
dim as string d = __FB_EVAL__( !"plain" )
dim as string e = __FB_EVAL__( !"A\tB" )
