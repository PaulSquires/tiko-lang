'' See tests/driver/generic-mixed-set.test.

'' ORDINARY FIRST: the generic takes every call it is offered.
namespace OrdFirst
    function H overload ( byval v as long ) as ulongint : return 1000 + v : end function
    function H overload ( byref v as const string ) as ulongint : return 2000 + len( v ) : end function
    function H( of K )( byref x as K ) as ulongint : return 3000 + sizeof( K ) : end function
end namespace

'' ...the shape that ICEd: the generic is the only one that fits.
type MyKey
    as long id
    declare function H( ) as ulongint
end type
function MyKey.H( ) as ulongint : return id * 10 : end function

function H overload ( byval v as long ) as ulongint : return 1000 + v : end function
function H overload ( byref v as const string ) as ulongint : return 2000 + len( v ) : end function
function H( of K )( byref k as K ) as ulongint : return k.H( ) : end function

function Use( of K )( byref k as K ) as ulongint : return H( k ) : end function

'' GENERIC FIRST: an ordinary overload after it hides it.
namespace GenFirst
    function H( of K )( byref k as K ) as ulongint : return 3000 : end function
    function H overload ( byval v as long ) as ulongint : return 1000 + v : end function
    function H overload ( byref v as string ) as ulongint : return 2000 + len( v ) : end function
end namespace

dim k as MyKey : k.id = 4
dim as long l = 7
dim as string s = "abcd"
dim as double d = 1.5
print "key"; H( k ); Use( k )
print "ordfirst"; OrdFirst.H( l ); OrdFirst.H( 5 ); OrdFirst.H( s ); OrdFirst.H( "ab" ); OrdFirst.H( d )
print "written"; OrdFirst.H( of short )( 5 )
print "genfirst"; GenFirst.H( l ); GenFirst.H( 5 ); GenFirst.H( s ); GenFirst.H( d )
