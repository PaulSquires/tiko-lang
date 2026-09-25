'' Two arguments that bind one type parameter to different types -- fbc's error 340 on
'' lines 13 to 16 (fbc-modern 1.20): long + long is INTEGER, and a literal 2 is INTEGER.
'' Lines 18 to 20 agree, or say which, and are accepted.
function Max( of T )( byval a as T, byval b as T ) as T
    if a > b then return a
    return b
end function
dim as long v = 21
dim as double d = 1.5
dim as short s = 2
dim as long r

print Max( v + v, v )
print Max( v, 2 )
print Max( d, v )
print Max( 1.5, 2 )

print Max( v, v )
print Max( s, s )
print Max( of long )( v + v, v )
