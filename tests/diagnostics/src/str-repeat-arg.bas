'' 'string( n, x )' AND 'wstring( n, x )' take a character code or a string of their own
'' width. fbc's error 58 on lines 13 to 20 (fbc-modern 1.20). tiko took each: 'wstring( 3,
'' "a" )' printed three backquotes, and the rest printed nothing.
dim as wstring * 8 w = "W"
dim as string s = "S"
dim as ustring u = "U"
dim as zstring * 8 z = "Z"
dim as wstring ptr pw = @w
dim as zstring ptr pz = @z
dim as string rs
dim as wstring * 16 rw

rw = wstring( 3, "a" )
rw = wstring( 3, s )
rw = wstring( 3, z )
rw = wstring( 3, u )
rw = wstring( 3, *pz )
rs = string( 3, w )
rs = string( 3, u )
rs = string( 3, *pw )
