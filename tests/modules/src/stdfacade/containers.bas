'' std/containers, a real module: generic types and procedures, a user key type through the
'' Hashable hook, qualified and through 'using'.
#import "std/containers"
private function Total( byref a as containers.Array( of long ) ) as long
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
print m.Count( ); m["k"]; " "; containers.Contains( of long )( a, 2 ); " "; s.Contains( 5 ); " "; containers.HashOf( 1 ) = containers.HashOf( 1 )
type Pt extends containers.Hashable
    as long x, y
    declare function HashOf( ) as ulongint override
end type
function Pt.HashOf( ) as ulongint
    return containers.HashOf( x ) xor ( containers.HashOf( y ) shl 1 )
end function
operator = ( byref p as Pt, byref q as Pt ) as boolean
    return p.x = q.x andalso p.y = q.y
end operator
scope
    using containers
    dim as Map( of Pt, string ) names
    dim as Pt o : o.x = 1 : o.y = 2
    names[o] = "one-two"
    print names.Count( ); " "; names[o]
end scope
