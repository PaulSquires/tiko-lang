'' std/containers (RFC-0009): generic types and procedures through the facade, beside
'' containers.bi included directly -- a containers.Array IS an FB.Array.
#import "std/containers"
#include once "containers.bi"
private function Total( byref a as FB.Array( of long ) ) as long
    dim as long t = 0
    for each x as long in a
        t += x
    next
    return t
end function
dim as containers.Array( of long ) a
a.Push( 3 ) : a.Push( 1 ) : a.Push( 2 )
containers.Sort( a )
print a[0]; a[1]; a[2]; Total( a )
dim as containers.Map( of string, long ) m
m.Put( "k", 7 )
dim as containers.Set( of long ) s
s.Add( 5 )
print m.Count( ); m["k"]; " "; containers.Contains( of long )( a, 2 ); " "; s.Contains( 5 ); " "; containers.HashOf( 1 ) = FB.HashOf( 1 )
