'' AN ELIDED SLOT IN A DESTRUCTURING is skipped and still counts toward the offset.
'' Measured: 'let( a, , b ) = f( )' is 'A = *(int32*)TMP' and
'' 'B = *(int32*)((uint8*)TMP + 8)' -- the THIRD element, not the second.
type P
	as long x, y, z
end type
function f( ) as P
	dim as P p
	p.x = 1 : p.y = 2 : p.z = 3
	return p
end function
dim as long a, b
let( a, , b ) = f( )
print a, b
