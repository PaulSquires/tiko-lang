'' uniqueptr.bas -- RFC 0018 P4: std/memory's UniquePtr( of T ), a move-only owner.
''
'' TIKO-ONLY: it imports std/memory and std/containers and moves.
''
'' Res counts its live objects, so every line says how many exist; a leak or a double
'' delete shows as a wrong count at the end. A copy of a UniquePtr anywhere would fail to
'' compile -- the copies that must be refused are tests/diagnostics/move-uniqueptr.test.

#import "std/memory"
#import "std/containers"

dim shared as long live

type Res
    as long id
    declare constructor( )
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor Res( ) : live += 1 : end constructor
constructor Res( byval n as long ) : id = n : live += 1 : end constructor
destructor Res( ) : live -= 1 : end destructor

function OpenRes( byval n as long ) as memory.UniquePtr( of Res )
    dim as memory.UniquePtr( of Res ) r = memory.UniquePtr( of Res )( new Res( n ) )
    return r
end function

sub Use( byval u as memory.UniquePtr( of Res ) )
    print "  (Use owns " & u.Ref( ).id & ", live " & live & ")"
end sub

scope
    dim as memory.UniquePtr( of Res ) a = OpenRes( 1 )
    print "U1 returned: " & a.Ref( ).id & "  live " & live
    dim as memory.UniquePtr( of Res ) b = move( a )
    print "U2 b = move( a ): b " & b.Ref( ).id & ", a null " & a.IsNull( ) & "  live " & live
    Use( move( b ) )
    print "U3 after Use( move( b ) ): b null " & b.IsNull( ) & "  live " & live
    dim as memory.UniquePtr( of Res ) c = memory.MakeUnique( of Res )( )
    c.Ref( ).id = 4
    c.Reset( new Res( 5 ) )
    print "U4 Reset: " & c.Ref( ).id & "  live " & live
    dim as Res ptr raw = c.Release( )
    print "U5 Release: c null " & c.IsNull( ) & ", raw " & raw->id & "  live " & live
    delete raw
    dim as containers.Array( of memory.UniquePtr( of Res ) ) owners
    for i as long = 1 to 20
        owners.Push( OpenRes( 100 + i ) )
    next
    dim as memory.UniquePtr( of Res ) d = OpenRes( 7 )
    owners.Push( move( d ) )
    print "U6 Array of 21 owners: last " & owners[ 20 ].Ref( ).id & ", d null " & d.IsNull( ) & "  live " & live
    owners.RemoveSwap( 0 )
    owners.SetCount( 10 )
    print "U7 after RemoveSwap and SetCount( 10 ): count " & owners.Count( ) & "  live " & live
end scope
print "U8 live after scope: " & live
