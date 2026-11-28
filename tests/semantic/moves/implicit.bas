'' implicit.bas -- RFC 0018 P0: a "data structure" with NO structors written by hand.
''
'' L holds a dynamic array, a string and one counting T. Its copy, let and destructor are
'' all implicit, so the only visible trace of a deep copy of L is the copy of its T
'' (fbc's implicit copy is default ctor + let). The array's ubound and the string are
'' printed after each case to prove the data arrived intact.

#include once "count.bi"

type L
    items( any ) as long
    name as string
    tag as T
end type

function Build( byval n as long ) as L
    dim as L r
    redim r.items( n - 1 )
    for i as long = 0 to n - 1 : r.items( i ) = i : next
    r.name = "list" & n
    return r
end function

sub TakeL( byval x as L )
    print "  (in TakeL: ubound=" & ubound( x.items ) & " name=" & x.name & ")"
end sub

print "I1 dim a = Build( )"
scope
    dim as L a = Build( 1000 )
    print "  a: ubound=" & ubound( a.items ) & " last=" & a.items( 999 ) & " name=" & a.name
end scope
Report "I1"

print "I2 b = Build( )"
scope
    dim as L b
    b = Build( 1000 )
    print "  b: ubound=" & ubound( b.items ) & " name=" & b.name
end scope
Report "I2"

print "I3 TakeL( Build( ) )"
scope
    TakeL( Build( 10 ) )
end scope
Report "I3"

print "I4 b = a  (an lvalue, still needed)"
scope
    dim as L a = Build( 5 ), b
    b = a
    print "  a: ubound=" & ubound( a.items ) & "  b: ubound=" & ubound( b.items )
end scope
Report "I4"

'' P: NOTHING WRITTEN BY HAND ANYWHERE -- no T inside -- so no count can see a copy. What a
'' move shows instead is that the caller ends up with THE SAME BUFFERS the callee built:
'' the string's data pointer and the array's first element, compared, not printed.
type P
    items( any ) as long
    name as string
end type

dim shared as any ptr seenName, seenItems

function BuildP( byval n as long ) as P
    dim as P r
    redim r.items( n - 1 )
    for i as long = 0 to n - 1 : r.items( i ) = i * 2 : next
    r.name = "plain" & n
    seenName = strptr( r.name ) : seenItems = @r.items( 0 )
    return r
end function

print "I5 dim a = BuildP( )  (no structors written anywhere)"
scope
    dim as P a = BuildP( 100 )
    print "  same buffers: " & iif( strptr( a.name ) = seenName andalso @a.items( 0 ) = seenItems, "yes", "NO, copied" ) & "  " & a.name & " " & a.items( 99 )
end scope

print "I6 b = BuildP( )  (assignment, no structors written anywhere)"
scope
    dim as P b = BuildP( 3 )
    b = BuildP( 50 )
    print "  same buffers: " & iif( strptr( b.name ) = seenName andalso @b.items( 0 ) = seenItems, "yes", "NO, copied" ) & "  " & b.name & " " & b.items( 49 )
end scope

print "-- end of main"
