type fnint as function( byval as integer ) as integer
type fnsng as function( byval as single ) as integer
function proc overload( byval scalar as integer ) as integer
	function = 1
end function
function proc overload( byval scalar as single ) as integer
	function = 3
end function
sub t
	static fint as fnint = @proc
	static fsng as fnsng = @proc
	print fint( 0 ), fsng( 0 )
	dim lsng as fnsng = @proc
	print lsng( 0 )
end sub
t
dim shared gsng as fnsng = @proc
print gsng( 0 )
