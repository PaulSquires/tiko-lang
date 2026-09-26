'' TRIM, LTRIM AND RTRIM OF A USTRING WITH A PATTERN -- a second argument WITHOUT 'any', which
'' strips the whole substring. Each was DROPPED in silence, so fbx's fbxOpenFileDialog kept
'' its padding after 'ustrFile = RTRIM( ustrFile, CHR( 32 ) )', and 'ltrim( "  " & u, " " )'
'' printed garbage. Measured, fbc-modern prints [abc], [abc], [abc   ], [abc], [yabcxyxy],
'' [ab] and [q], each on its own line.
dim u as ustring = "abc   "
u = rtrim( u, chr( 32 ) )
print "[" & u & "]"
u = "abc   " : u = rtrim( u, " " )
print "[" & u & "]"
u = ltrim( "  " & u & "   ", chr( 32 ) )
print "[" & u & "]"
dim s as string = rtrim( u, wchr( 32 ) )
print "[" & s & "]"
u = "xyabcxyxy" : u = trim( u, "x" )
print "[" & u & "]"
u = "abab" : u = rtrim( u, "ab" ) & "ab"
print "[" & u & "]"
dim f as ustring * 20 = "zzqzz"
u = trim( f, "z" )
print "[" & u & "]"
