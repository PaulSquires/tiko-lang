'' ONE GENERIC NAME IN A NAMESPACE AND AT MODULE LEVEL. Both instances were _Z1FIu7INTEGERES0_
'' -- fbc's spelling, which writes no namespace -- and clang refused the redefinition. The
'' namespace's is nested now.
namespace NS
    function F( of T )( byval a as T ) as long
        return 1
    end function
end namespace
function F( of T )( byval a as T ) as long
    return 2
end function
print NS.F( 1 ), F( 1 )
