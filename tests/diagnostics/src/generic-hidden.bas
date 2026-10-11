'' See tests/diagnostics/generic-hidden.test.
namespace GenFirst
    function H( of K )( byref x as K ) as long : return 3 : end function
    function H overload ( byval v as long ) as long : return 1 : end function
end namespace
function P( byval v as long ) as long : return v : end function

dim as string s = "ab"
print GenFirst.H( 5 )
print GenFirst.H( s )
print GenFirst.H( of long )( 3 )
print P( of long )( 3 )
