'' explicit.bas -- RFC 0018 P2: 'move( x )' at every sink, and what x holds afterwards.
''
'' TIKO-ONLY: 'move' is a tiko builtin; fbc has none.
''
'' Each case moves from a named object and then prints it: a move RESETS its source, so a T
'' reads back as a fresh default-constructed one (a new serial, s = "t<serial>") and a P as
'' empty. The string and the array are compared by ADDRESS against where they were before
'' the move: "same buffers: yes" means nothing was copied.

#include once "count.bi"

type P
    items( any ) as long
    name as string
end type

dim shared as any ptr seenName, seenItems

sub NoteBuffers( byref x as P )
    seenName = strptr( x.name ) : seenItems = @x.items( 0 )
end sub

function SameBuffers( byref x as P ) as string
    if ( strptr( x.name ) = seenName ) andalso ( @x.items( 0 ) = seenItems ) then return "yes"
    return "NO, copied"
end function

function FillP( byval n as long ) as P
    dim as P r
    redim r.items( n - 1 )
    for i as long = 0 to n - 1 : r.items( i ) = i + 1 : next
    r.name = "list" & n
    return r
end function

sub TakeT( byval x as T )
    print "  (in TakeT #" & x.id & " " & x.s & ")"
end sub

sub TakeP( byval x as P )
    print "  (in TakeP: same buffers: " & SameBuffers( x ) & ", " & x.name & ")"
end sub

function PassOn( byval x as T ) as T
    return move( x )
end function

function GiveBack( ) as T
    dim as T r = T( 50 )
    dim as T keep = T( 51 )
    if keep.id > 0 then return move( r )
    return keep
end function

print "X1 dim b = move( a )"
scope
    dim as T a = T( 1 )
    dim as T b = move( a )
    print "  b=#" & b.id & " " & b.s & "  a=#" & a.id & " " & a.s
end scope
Report "X1"

print "X2 b = move( a )  (T has a written let; move skips it)"
scope
    dim as T a = T( 2 ), b = T( 3 )
    b = move( a )
    print "  b=#" & b.id & " " & b.s & "  a=#" & a.id & " " & a.s
end scope
Report "X2"

print "X3 TakeT( move( a ) )"
scope
    dim as T a = T( 4 )
    TakeT( move( a ) )
    print "  a=#" & a.id & " " & a.s
end scope
Report "X3"

print "X4 return move( p ), p a byval parameter (RFC M5)"
scope
    dim as T a = T( 5 )
    dim as T b = PassOn( a )
    print "  b=" & b.s & "  a=" & a.s
end scope
Report "X4"

print "X5 return move( r ) on one path, return keep on the other"
scope
    dim as T b = GiveBack( )
    print "  b=" & b.s
end scope
Report "X5"

print "X6 a = move( a )  (moved onto itself)"
scope
    dim as T a = T( 6 )
    a = move( a )
    print "  a=" & a.s
end scope
Report "X6"

print "X7 element and field sources"
scope
    dim as T arr( 0 to 1 )
    arr( 1 ).s = "element"
    dim as T e = move( arr( 1 ) )
    print "  e=" & e.s & "  arr(1)=#" & arr( 1 ).id & " " & arr( 1 ).s
end scope
Report "X7"

print "X8 P: no structors written anywhere"
scope
    dim as P a = FillP( 100 )
    NoteBuffers( a )
    dim as P b = move( a )
    print "  dim:    same buffers: " & SameBuffers( b ) & "  " & b.name & " " & b.items( 99 ) & "  a: ubound=" & ubound( a.items ) & " name=""" & a.name & """"
    dim as P c
    c = move( b )
    print "  assign: same buffers: " & SameBuffers( c ) & "  b: ubound=" & ubound( b.items ) & " name=""" & b.name & """"
    TakeP( move( c ) )
    print "  arg:    c: ubound=" & ubound( c.items ) & " name=""" & c.name & """"
    a.name = "reused" : redim a.items( 2 )
    print "  a is usable again: " & a.name & " ubound=" & ubound( a.items )
end scope

print "X9 *p and a byref parameter as sources"
sub Steal( byref src as T, byref dst as T )
    dst = move( src )
end sub
scope
    dim as T a = T( 9 ), b
    dim as T ptr pa = @a
    Steal( *pa, b )
    print "  b=" & b.s & "  a=#" & a.id & " " & a.s
end scope
Report "X9"

print "-- end of main"
