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

'' ...AND A WIDE RESULT, which re-emits as '!"\uXXXX"' per character, four UPPERCASE
'' hex digits. Measured -- __FB_EVAL__( wstr( "A" ) ) is '\u0041' -- and the four
'' lengths fbc's own run reports for these are 1, 2, 1 and 3.
dim as wstring * 32 wa = __FB_EVAL__( wstr("A") )
dim as wstring * 32 wb = __FB_EVAL__( wstr("A") + wstr("B") )
dim as wstring * 32 wc = __FB_EVAL__( wstr("A") + wstr(!"\0") )
dim as wstring * 32 wd = __FB_EVAL__( wstr(!"\\") + wstr("\") + wstr(!"\\") )
print len( wa ), len( wb ), len( wc ), len( wd )
