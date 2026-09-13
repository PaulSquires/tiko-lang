'' A RENDERED NUMBER IN A USTRING CHAIN IS NARROW. fbc's C, n = 25, w = "ab", a = "k":
''
''     dim v as ustring = w & n        fb_LongintToStr, fb_UStrConcatUA into TMP, fb_UStrInit
''     dim v as ustring = n & w        fb_UStrConcatAU, fb_UStrInit
''     dim v as ustring = w & "z" & n  fb_UStrConcat, fb_UStrConcatUA, fb_UStrInit
''     v = w & n                       fb_UStrAssign( v, w ), fb_StrToUStr( n ), ConcatAssign
''     v = n & w                       fb_UStrAssignFromA( v, n ), ConcatAssign w
''     v = w & "z" & n                 assign, ConcatAssign "z", fb_StrToUStr( n ), ConcatAssign
''     a = a & n & "z"                 fb_UStrConcatUA, fb_UStrConcat, fb_UStrAssign
''     a = a & "z" & n                 fb_UStrConcat, fb_UStrConcatUA, fb_UStrAssign
''
'' 'a &= n' is left out: fbc concat-assigns the narrow digits unconverted, and the half
'' character it leaves is read past the buffer -- its bytes change with -O2.
''
'' tiko concat-assigned the narrow digits into the UTF-16 buffer for every row, so '25'
'' came out as U+3532 -- and fbsqlite's "(expected N, got M)" messages were unreadable.
'' 'a += str( n )' is left out: fbc concat-assigns that one unconverted too, and tiko does
'' not yet (HANDOFF).
sub bytesU( byref label as string, byref u as ustring )
	dim as string s = u
	print label; " len="; len( u ); " [";
	for i as integer = 0 to len( s ) - 1
		print hex( s[i], 2 ); " ";
	next
	print "]"
end sub
dim as longint n = 25
dim as ustring w = "ab"
dim as ustring d1 = w & n
bytesU( "dim w&n", d1 )
dim as ustring d2 = n & w
bytesU( "dim n&w", d2 )
dim as ustring d3 = w & "z" & n
bytesU( "dim w&z&n", d3 )
dim as ustring v1
v1 = w & n
bytesU( "v=w&n", v1 )
dim as ustring v2
v2 = n & w
bytesU( "v=n&w", v2 )
dim as ustring v3
v3 = w & "z" & n
bytesU( "v=w&z&n", v3 )
dim as ustring a1 = "k"
a1 = a1 & n & "z"
bytesU( "a=a&n&z", a1 )
dim as ustring a2 = "k"
a2 = a2 & "z" & n
bytesU( "a=a&z&n", a2 )
