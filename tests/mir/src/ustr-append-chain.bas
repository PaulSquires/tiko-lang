'' A CHAIN APPENDED TO A USTRING IS FOLDED, then assigned once. fbc's C:
''
''     t &= u2 & "x"         fb_UStrConcat( TMP, T, U2 ), fb_UStrConcat( TMP, +"x" ), fb_UStrAssign
''     t &= " [" & op & "]"  three fb_UStrConcat, fb_UStrAssign   (fbsqlite's DbError.ToString)
''     t &= " (" & n & ")"   fb_UStrConcat, fb_UStrConcatUA, fb_UStrConcat, fb_UStrAssign
''     t &= "a" & s2         fb_UStrConcat, fb_UStrConcatUA, fb_UStrAssign
''     nar &= "a" & s2       NARROW destination: two fb_StrConcatAssign in place
''
'' tiko did one fb_UStrConcatAssign of a narrow build of the ustring-only chains, so
'' 't &= u2 & "x"' printed 'Tu' and a NUL. fbc prints the rows below.
sub showU( byref label as string, byref u as ustring )
	dim as string s = u
	print label; " len="; len( u ); " ["; s; "]"
end sub
dim as ustring op = "Execute"
dim as ustring u2 = "u"
dim as string s2 = "s"
dim as longint n = 25
dim as ustring t1 = "T"
t1 &= u2 & "x"
showU( "u&lit", t1 )
dim as ustring t2 = "near"
t2 &= " [" & op & "]"
showU( "lit&u&lit", t2 )
dim as ustring t3 = "T"
t3 &= " (" & n & ")"
showU( "lit&n&lit", t3 )
dim as ustring t4 = "T"
t4 &= "a" & s2
showU( "lit&narrow", t4 )
dim as string nar = "N"
nar &= "a" & s2
print "narrow len="; len( nar ); " ["; nar; "]"
