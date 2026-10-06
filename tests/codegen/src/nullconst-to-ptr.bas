sub a overload( byval p as any ptr )
	print "ptr"; p = 0
end sub
sub a overload( byref s as string )
	print "string"
end sub
function f1 overload( byval p as any ptr ) as string : function = "any ptr" : end function
function f1 overload( byval i as byte ) as string : function = "byte" : end function
a( 0l ) : a( 0ul ) : a( cbyte( 0 ) ) : a( cushort( 0 ) ) : a( 0 )
print f1( cbyte( 0 ) ), f1( cptr( any ptr, 0 ) ), f1( cshort( 0 ) )
