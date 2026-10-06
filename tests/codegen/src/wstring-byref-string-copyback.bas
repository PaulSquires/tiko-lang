sub copyback( byref s as string )
	s = ucase( s )
end sub
dim w as wstring * 3+1
dim pw as wstring ptr = @w
w = "foo" : copyback( w ) : print w
w = "foo" : copyback( *pw ) : print w
