sub zfoo( byref z as zstring )
	print "[" & z & "]"
end sub
dim s as string = "Test"
dim z10 as zstring* 10 = "Test"
dim w10 as wstring * 10 = "Test"
dim pw as wstring ptr = @w10
zfoo( "Test" ) : zfoo( s ) : zfoo( z10 ) : zfoo( w10 ) : zfoo( *pw )
