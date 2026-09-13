'' A USTRING RVALUE PASSED TO 'byref as ustring' IS COPIED FIRST. fbc's C, for every row:
''
''     vr = fb_UStrUcase( &U )      (or Lcase, Trim, LTrim, RTrim, LeftD, RightD, Mid, Concat)
''     fb_UStrAssign( &TMP, -1, vr, -1, 0 )
''     TAKE( &TMP )
''     fb_UStrDelete( &TMP )
''
'' tiko passed vr itself. Take's first ustring assignment ('dim s as string = u') consumed that
'' runtime temporary, so the len( u ) after it read 0, and nothing ever released it. The
'' same holds for fb/string.bi's runtime-aliased declarations (FB.Contains and the rest).
'' fbc prints: 6 [  AB  ] / 6 [  ab  ] / 2 [Ab] / 4 [Ab  ] / 4 [  Ab] / 3 [  A] / 3 [b  ] /
'' 2 [Ab] / 7 [  Ab  x]
sub Take( byref u as ustring )
	dim as string s = u
	print len( u ); " ["; s; "]"
end sub
dim as ustring u = "  Ab  "
Take( ucase( u ) )
Take( lcase( u ) )
Take( trim( u ) )
Take( ltrim( u ) )
Take( rtrim( u ) )
Take( left( u, 3 ) )
Take( right( u, 3 ) )
Take( mid( u, 3, 2 ) )
Take( u & "x" )
