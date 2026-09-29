'' A GENERIC INSTANTIATED WITH A PRELUDE TYPEDEF -- 'FB.Array( of int32 )'. The prelude is parsed
'' after the unit, so 'int32' still held its placeholder when the unit's type was instantiated:
'' the instance was never built and the variable was typed as the TEMPLATE. 'MyArray( a )' was a
'' false TKO0698, 'a.Count( )' linked against a FB::ARRAY::COUNT never emitted, and 'for each'
'' over it lowered to nothing. 'of long' worked. See src/symbols/resolvetype.bas.
#include once "fb/array.bi"

function MyArray( byref b as FB.Array( of int32 ) ) as int32
    dim as int32 s = 0
    for each v in b
        s += v
    next
    b.Push( 100 )
    return s
end function

dim a as FB.Array( of int32 )
dim as FB.Array( of int64 ) w
a.Push( 1 ) : a.Push( 2 ) : a.Push( 3 )
w.Push( 5 )
print "sum " & MyArray( a )
print "count " & a.Count( ) & " " & w.Count( )
for each i in a
    print i
next
