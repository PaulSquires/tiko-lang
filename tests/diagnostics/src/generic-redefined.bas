'' A SECOND GENERIC PROCEDURE OF THE SAME NAME IN THE SAME SCOPE -- fbc-modern's error 4,
'' "Duplicated definition", whatever its arity or type-parameter count. Each was chained in
'' silence and every call reached the first.
function F( of T )( byval a as T ) as long
    return 1
end function
function F( of T )( byval a as T, byval b as T ) as long      '' 4
    return 2
end function
function K( of T )( byval a as T ) as long
    return 1
end function
function K( of T, U )( byval a as T, byval b as U ) as long   '' 4
    return 2
end function
namespace NS
    function P( of T )( byval a as T ) as long
        return 1
    end function
end namespace
namespace NS
    function P( of T )( byval a as T ) as long                '' 4: the namespace reopened
        return 2
    end function
end namespace
'' Fine: two namespaces, and a generic beside an ordinary procedure (genericset.tiko).
namespace NA
    function Q( of T )( byval a as T ) as long
        return 1
    end function
end namespace
namespace NB
    function Q( of T )( byval a as T ) as long
        return 2
    end function
end namespace
function H( byval a as long ) as long
    return 2
end function
function H( of T )( byval a as T ) as long
    return 1
end function
print F( 1 ), K( 1 ), NS.P( 1 ), NA.Q( 1 ), H( 1 )
