'' 'f( byval p )' AGAINST A BYREF PARAMETER SUPPLIES THE REFERENCE ITSELF. Measured --
'' fbc's C for 'fz( byval 0 )' over 'byref z as zstring' is 'FZ( (char*)0ll )'.
function fz( byref z as zstring ) as zstring ptr
	function = @z
end function

sub g( byref a as long, byref b as long )
	a = b
end sub

dim as zstring * 8 zz = "ab"
dim as zstring ptr p1 = fz( zz )
dim as zstring ptr p2 = fz( byval 0 )
dim as zstring ptr p3 = fz( byval 123 )
print p1, p2, p3

dim as long x, y = 7
dim as long ptr px = @x
g( x, y )
g( byval px, y )
print x
