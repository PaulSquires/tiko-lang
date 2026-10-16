'' hex, oct, bin and their wide halves over a string: each line is fbc-modern's error 58 or 99.
dim as zstring ptr z = @"ab"
dim as string s = "ab"
dim as zstring * 4 fz = "ab"
dim as string * 4 fs = "ab"
dim as wstring ptr w = @wstr( "ab" )
print oct( *z )
print bin( z[0] )
print whex( s )
print woct( fz )
print wbin( fs )
print hex( *w )
print hex( "ab" )
print hex( s, 4 )
print hex( z[0], 2 )
'' Accepted by fbc and by tiko: a number, a character code, a pointer, a boolean.
dim as any ptr p = z
print hex( 255 ), oct( 8, 4 ), bin( z[0] + 0 ), whex( 7 ), hex( asc( *z ) ), hex( p ), hex( true )
