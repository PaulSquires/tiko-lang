sub h( byref a as wstring, byref b as wstring, byref c as wstring )
	a = wstr( "1234" ) : b = wstr( "5678" )
	c = iif( -1, a + b, wstr( "" ) )
	print "[" & c & "]", c = a + b
	c = iif( 0, wstr( "" ), a + b )
	print "[" & c & "]", c = a + b
	c = iif( -1, wstr( "1234" ) + b, wstr( "" ) )
	print "[" & c & "]"
end sub
dim as wstring * 33 aa, bb, cc
h( aa, bb, cc )
dim as wstring * 33 a2 = "12", b2 = "34", c2
c2 = iif( -1, a2 + b2, wstr( "" ) )
print "[" & c2 & "]"
