'' 'operator cast( ) as boolean' MEETING A NUMBER widens like a plain boolean: true is -1.
type UB : as long v : declare operator cast( ) as boolean : end type
operator UB.cast( ) as boolean : return true : end operator
type UF : as long v : declare operator cast( ) as boolean : end type
operator UF.cast( ) as boolean : return false : end operator
sub sl( byval x as long ) : print "arg long"; x : end sub
sub su( byval x as ubyte ) : print "arg ubyte"; x : end sub
sub sd( byval x as double ) : print "arg double"; x : end sub
function rl( byref b as UB ) as long : return b : end function
dim as UB b
dim as UF f
dim as boolean pb = true
dim as ubyte u255 = 255
sl( b ) : su( b ) : sd( b ) : sl( f )
dim as long k = b : print "init long"; k
dim as ulong ul = b : print "init ulong"; ul
dim as single sg = b : print "init single"; sg
k = 0 : k = b : print "asgn long"; k
print "ret long"; rl( b )
print "b = -1"; b = -1
print "b = u255"; b = u255
print "b and 3"; b and 3
print "b = pb"; b = pb
print "not b"; not b
