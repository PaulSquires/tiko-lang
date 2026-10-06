const MAGIC_I = &h1234
sub takeWstringPtr( byval pw as wstring ptr, isfixed as integer )
	print *pw
end sub
dim as string s = "abc"
dim as string * 8 f = "fix"
dim as zstring * 8 z = "zz"
dim as wstring * 8 w = "ww"
takeWstringPtr( s, 0 )
takeWstringPtr( f, 1 )
takeWstringPtr( z, 0 )
takeWstringPtr( w, 0 )
takeWstringPtr( hex( MAGIC_I ), 0 )
takeWstringPtr( whex( MAGIC_I ), 0 )
