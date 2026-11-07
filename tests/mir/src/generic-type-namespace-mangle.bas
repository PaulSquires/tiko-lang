'' ONE GENERIC TYPE NAME IN A NAMESPACE AND AT MODULE LEVEL. Each instantiation took the
'' member definitions of BOTH generics ('get' twice, TKO0677), and both Get methods were
'' _ZN4CellIiE3GETEv. Now each takes its own, and the namespace's is nested under it.
namespace NS
    type Cell( of T )
        as T v
        declare function Get( ) as T
    end type
    function Cell( of T ).Get( ) as T
        return v + 1
    end function
end namespace
type Cell( of T )
    as T v
    declare function Get( ) as T
end type
function Cell( of T ).Get( ) as T
    return v + 2
end function
sub Show overload( byref c as NS.Cell( of long ) ) : print "ns"; c.Get( ) : end sub
sub Show( byref c as Cell( of long ) ) : print "top"; c.Get( ) : end sub
dim a as NS.Cell( of long ) : a.v = 10
dim b as Cell( of long ) : b.v = 10
Show( a ) : Show( b )
