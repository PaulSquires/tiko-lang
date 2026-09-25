'' A comparison inside an INSTANTIATED generic body, over a type with no 'operator =' --
'' fbc's error 20 when IsEq is instantiated at NoEq (fbc-modern 1.20, reported on the
'' function's own line 9; tiko points at the comparison on line 10). The same
'' generic over a long, line 14, is accepted.
type NoEq
    as long a
end type
dim as NoEq x, y
function IsEq( of T )( byref a as T, byref b as T ) as boolean
    return a = b
end function

print IsEq( x, y )
print IsEq( 1, 2 )
