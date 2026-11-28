'' library.bas -- RFC 0018 P4: what std/containers' sinks copy.
''
'' TIKO-ONLY: it imports std/containers. The .p0-trace is the P0 compiler over master's pkg
'' (byref sinks, copying); from P4 on, a sink takes its value BY VALUE and swaps it in, so a
'' temporary costs no copy and an lvalue exactly one.

#import "std/containers"
#include once "count.bi"

function Make( byval n as long ) as T
    dim as T r = T( n )
    return r
end function

print "L1 Array.Push( Make( ) ), Push( T( n ) )"
scope
    dim as containers.Array( of T ) a
    a.Reserve( 4 )
    Report "  (reserve)", -1
    a.Push( Make( 1 ) )
    a.Push( T( 2 ) )
    Report "L1", -1
end scope
Report "L1 end", -1

print "L2 Array.Push( lvalue ): one copy, and the caller keeps its own"
scope
    dim as containers.Array( of T ) a
    a.Reserve( 4 )
    dim as T x = T( 3 )
    Report "  (setup)", -1
    a.Push( x )
    print "  x still " & x.s
    Report "L2", -1
end scope
Report "L2 end", -1

print "L3 Array.Insert( 0, Make( ) )"
scope
    dim as containers.Array( of T ) a
    a.Reserve( 4 )
    a.Push( Make( 4 ) )
    Report "  (setup)", -1
    a.Insert( 0, Make( 5 ) )
    Report "L3", -1
end scope
Report "L3 end", -1

print "L4 Map.Put( k, Make( ) ), Put over an existing key"
scope
    dim as containers.Map( of long, T ) m
    m.Put( 1, Make( 6 ) )
    m.Put( 1, Make( 7 ) )
    print "  m[1] = " & m[ 1 ].s
    Report "L4", -1
end scope
Report "L4 end", -1

print "L5 Deque.PushBack / PushFront, LinkedList.PushBack( Make( ) )"
scope
    dim as containers.Deque( of T ) d
    d.Reserve( 4 )
    Report "  (reserve)", -1
    d.PushBack( Make( 8 ) )
    d.PushFront( Make( 9 ) )
    dim as containers.LinkedList( of T ) l
    l.PushBack( Make( 10 ) )
    Report "L5", -1
end scope
Report "L5 end", -1
ReportAll( )
print "-- end of main"
