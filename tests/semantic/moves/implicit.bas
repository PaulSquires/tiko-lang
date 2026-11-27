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

print "-- end of main"
