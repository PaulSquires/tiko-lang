dim as ustring u = "u"
dim as string s = "s"
dim as wstring * 5 w = "w"
dim as boolean f
dim as ustring a
a = iif( f, u & "x", s )
a = iif( f, u, "x" )
a = iif( f, u, s )
a = iif( f, w, u )
a = iif( f, s & u, u )
a = iif( f, s, s & u )
a = iif( f, (u & "x"), u )
a = iif( f, s & w, u )
print a
