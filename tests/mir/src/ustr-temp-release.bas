'' A USTRING CALL RESULT AGAINST A USTRING PARAMETER, and a chain with no ustring in it
'' assigned to one -- the two shapes that leaked a runtime descriptor per execution.
function Mk( byval n as long ) as ustring
	return "u" & n
end function

sub Take( byref s as const ustring )
	print s
end sub

dim as long n = 42
Take( Mk( 1 ) )
dim as ustring v = n & "x"
dim as ustring w = "a" & n & "b"
dim as ustring u = "a"
u = u & n
print len( Mk( 2 ) ), v, w, u
