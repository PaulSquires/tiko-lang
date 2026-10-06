namespace N
	sub val cdecl ()
		print "user val"
	end sub
	private sub reg cdecl () constructor
		dim p as sub cdecl () = procptr( val )
		p( )
		dim q as sub cdecl () = @val
		q( )
	end sub
end namespace
print "main"
