'' hazards.bas -- RFC 0018 P1: the shapes a relocation could get wrong.
''
'' TIKO-ONLY: H3 uses 'defer', which fbc does not have.
''
'' Every case must BALANCE and every printed value must be right. The counts themselves
'' are recorded, not asserted: P1 changes them on purpose, and the .p0-trace is what the
'' copying compiler printed.

#include once "count.bi"

function Make( byval n as long ) as T
    dim as T r = T( n )
    return r
end function

'' H1: two locals, two returns -- the one NOT returned is still destroyed
function PickOne( byval which as long ) as T
    dim as T a = T( 1 ), b = T( 2 )
    if which = 1 then return a
    return b
end function

'' H2: a return from inside a loop and a nested scope
function FromLoop( ) as T
    dim as T r = T( 3 )
    for i as long = 1 to 3
        scope
            dim as T inner = T( 30 + i )
            if i = 2 then return r
        end scope
    next
    return r
end function

'' H3: a pending defer still sees r, so r is not moved
function WithDefer( ) as T
    dim as T r = T( 4 )
    defer print "  (defer sees r.s=" & r.s & ")"
    return r
end function

'' H4: a guard declared after r touches r in its destructor
type Guard
    as T ptr p
    declare destructor( )
end type
destructor Guard( )
    print "  (guard sees s=""" & p->s & """)"
end destructor
function Guarded( ) as T
    dim as T r = T( 5 )
    dim as Guard g
    g.p = @r
    return r
end function

'' H5: a method returning a local, with 'this' about
type Box
    as T held
    declare function Fresh( ) as T
end type
function Box.Fresh( ) as T
    dim as T r = T( 6 )
    return r
end function

function Combine( byref a as T, byref b as T ) as T
    dim as T r = T( a.id * 100 + b.id )
    r.s = a.s & "+" & b.s
    return r
end function

function Pass2( byval x as T ) as T
    return x
end function

sub Take( byval x as T )
    print "  (in Take #" & x.id & " " & x.s & ")"
end sub

dim shared as T slots( 0 to 1 )

Report "init (shared slots)", 2

print "H1 two returns"
scope
    dim as T x = PickOne( 1 )
    print "  got #" & x.id & " " & x.s
    dim as T y = PickOne( 2 )
    print "  got #" & y.id & " " & y.s
end scope
Report "H1"

print "H2 return from a loop"
scope
    dim as T x = FromLoop( )
    print "  got " & x.s
end scope
Report "H2"

print "H3 pending defer"
scope
    dim as T x = WithDefer( )
    print "  got " & x.s
end scope
Report "H3"

print "H4 guard destroyed after the return"
scope
    dim as T x = Guarded( )
    print "  got " & x.s
end scope
Report "H4"

print "H5 method result"
scope
    dim as Box bx
    dim as T x = bx.Fresh( )
    print "  got " & x.s
end scope
Report "H5"

print "H6 b = Combine( b, a )  (the target is an argument)"
scope
    dim as T a = T( 7 ), b = T( 8 )
    b = Combine( b, a )
    print "  b=" & b.s
end scope
Report "H6"

print "H7 element and field targets"
scope
    slots( 1 ) = Make( 9 )
    print "  slots(1)=" & slots( 1 ).s
    dim as Box bx
    bx.held = Make( 10 )
    print "  bx.held=" & bx.held.s
end scope
Report "H7", 0

print "H8 Take( Pass2( Make( ) ) )"
scope
    Take( Pass2( Make( 11 ) ) )
end scope
Report "H8"

print "H9 the temporary read in an expression"
scope
    print "  len=" & len( Make( 12 ).s )
end scope
Report "H9"

print "-- end of main"
