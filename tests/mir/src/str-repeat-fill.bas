'' 'string( n, x )' AND 'wstring( n, x )' over everything fbc accepts for x -- a code, a string
'' of the call's own width, a chain of one, a conversion. None is TKO0832, and each lowers:
'' 'wstring( 3, w & "x" )' declined before -- the chain is typed STRING, so the fill looked
'' numeric. Measured, fbc-modern prints BBB, WWW, CCC, qqq, WWW, aaa, BBB, SSS, FFF and 555.
dim as wstring * 8 w = "W"
dim as string s = "S"
print wstring( 3, 66 )
print wstring( 3, w )
print wstring( 3, wchr( 67 ) )
print wstring( 3, wstr( "q" ) )
print wstring( 3, w & "x" )
print string( 3, "ab" )
print string( 3, 66 )
print string( 3, s & "x" )
print string( 3, chr( 70 ) )
print string( 3, str( 5 ) )
