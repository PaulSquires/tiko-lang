'' swap of fixed-length strings: each side's tagged length and fill -1, as fbc passes them
dim as long guardA = 1
dim as string * 4 f4 = "abcd"
dim as long guardB = 2
dim as string * 8 f8 = "12345678"
dim as long guardC = 3
swap f4, f8
print "[" & f4 & "][" & f8 & "]"; guardA; guardB; guardC
dim as string s = "str"
swap s, f8
print "[" & s & "][" & f8 & "]"; len( s )
dim as zstring * 6 z6 = "zz"
swap z6, f4
print "[" & z6 & "][" & f4 & "]"; guardA; guardB; guardC
