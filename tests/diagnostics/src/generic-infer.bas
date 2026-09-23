'' TKO0809: a generic procedure whose type arguments cannot be inferred -- fbc's error 340.
'' The controls at the bottom are accepted by fbc.
sub S( of T )( byval v as T )
    print v
end sub
function G( of T )( byval n as long ) as T
    return n
end function
function Two( of T, U )( byval v as T ) as U
    return v
end function
namespace NS
    function Mk( of T )( byval n as long ) as T
        return n
    end function
end namespace
dim as long b = 3

S b
print G( b )
print Two( b )
print NS.Mk( b )
dim as long r = G( b )

'' Accepted by fbc: parentheses, written type arguments, and every parameter shape a T
'' can be inferred from -- itself, a pointer to it, a generic instance of it.
function Id( of T )( byval v as T ) as T
    return v
end function
function Deref( of T )( byval p as T ptr ) as T
    return *p
end function
type Box( of T )
    as T v
end type
function Unbox( of T )( byref bx as Box( of T ) ) as T
    return bx.v
end function
sub Plain( byval v as long )
    print v
end sub
dim as Box( of long ) bb
S( b )
print G( of long )( b )
print Two( of long, double )( b )
print NS.Mk( of long )( b )
print Id( b ); Deref( @b ); Unbox( bb )
Plain b
