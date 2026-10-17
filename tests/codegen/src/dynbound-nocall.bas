'' The hot shapes of LBOUND / UBOUND over a dynamic array -- a field read through BYREF, a
'' BYREF array parameter, a local, dimension 0 and a dimension past the rank -- none of which
'' may call the runtime.
type Box
    v(any) as long
end type

function Cap( byref b as Box ) as integer
    return ubound( b.v ) - lbound( b.v ) + 1
end function

function Span( a() as long ) as integer
    return ubound( a, 1 ) - lbound( a, 1 ) + ubound( a, 0 ) + lbound( a, 3 )
end function

dim a() as long
redim a( 0 to 9 )
dim b as Box
print Cap( b ); Span( a() ); ubound( a ); lbound( a )
