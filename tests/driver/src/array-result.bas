'' ARRAY RESULTS -- 'function f( ) as T( )' returns a dynamic array. A tiko extension: fbc has
'' no array result and rejects the spelling. See symbols/arrresult.bas and mir/lowerarrret.bas.
'' Every line below is a value a wrong owner, a missing move or a lost erase would change or
'' crash: the loops at the end run each shape a thousand times, so a double free or a leak of
'' the caller's storage shows as a fault, not as a wrong number.
function foo( ) as integer( )
    return { 10, 20, 30 }
end function

function squares( byval n as long ) as long( )
    dim r( ) as long
    redim r( 0 to n - 1 )
    for i as long = 0 to n - 1
        r( i ) = i * i
    next
    return r
end function

function viaResult( ) as integer( )
    function = { 7, 8 }
end function

function replaced( ) as integer( )
    function = { 1, 2, 3 }
    function = { 4, 5 }
end function

function names( ) as string( )
    return { "alpha", "beta", "gamma" }
end function

function unames( ) as ustring( )
    return { "x", "yy" }
end function

function nothing( ) as integer( )
    exit function
end function

function relay( ) as integer( )
    return foo( )
end function

function ratios( ) as double( )
    return { 0.5, 1.5 }
end function

function pick( byval early as boolean ) as integer( )
    dim r( ) as integer
    if early then return r
    redim r( 0 to 1 )
    r( 0 ) = 11
    r( 1 ) = 12
    return r
end function

sub take( a( ) as integer )
    print "take " & lbound( a ) & " " & ubound( a ) & " " & a( 2 )
end sub

sub show( a( ) as integer )
    print "show " & lbound( a ) & " " & ubound( a ) & " " & a( 1 )
end sub

var i = foo( )
print "var " & i( 0 ) & " " & i( 1 ) & " " & i( 2 ) & " " & ubound( i )

var s = squares( 5 )
print "local " & s( 0 ) & " " & s( 4 ) & " " & ubound( s )

var v = viaResult( )
print "result " & v( 0 ) & " " & v( 1 )

var r = replaced( )
print "replaced " & r( 0 ) & " " & r( 1 ) & " " & ubound( r )

var n = names( )
print "string " & n( 0 ) & " " & n( 2 ) & " " & ubound( n )

var u = unames( )
print "ustring " & u( 0 ) & " " & u( 1 )

var z = nothing( )
print "empty " & ubound( z )

var c = relay( )
print "relay " & c( 0 ) & " " & c( 2 )

var d = ratios( )
print "double " & d( 0 ) & " " & d( 1 )

var p0 = pick( true )
var p1 = pick( false )
print "pick " & ubound( p0 ) & " " & p1( 0 ) & " " & p1( 1 )

take( i( ) )

'' a call's result straight into a by-descriptor parameter, and as a FOR EACH subject
show( foo( ) )
dim as long each_
for each e as integer in foo( )
    each_ += e
next
print "each " & each_

'' assigned over an existing array: a move, the old elements erased
dim as integer m( )
m = foo( )
m = viaResult( )
print "assign " & m( 0 ) & " " & m( 1 ) & " " & ubound( m )

'' an unused result is erased at the end of its statement
foo( )
names( )
print "statement ok"

dim as long total
for k as long = 1 to 1000
    var t = foo( )
    var w = names( )
    var q = squares( 4 )
    total += t( 1 ) + len( w( 0 ) ) + q( 3 )
    foo( )
    m = foo( )
next
print "loop " & total

'' UDT elements: a plain one, one with a constructor and destructor (built ONCE each, so the
'' counts must agree), and one holding a string
dim shared as long ctors, dtors
type Pt
    as long x, y
end type
type Counted
    as long v
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor Counted( byval n as long ) : v = n : ctors += 1 : end constructor
destructor Counted( ) : dtors += 1 : end destructor
type Holder
    as string a
    as long n
end type

function pts( ) as Pt( )
    return { type<Pt>( 1, 2 ), type<Pt>( 3, 4 ) }
end function
function cs( ) as Counted( )
    return { Counted( 5 ), Counted( 6 ) }
end function
function ss( ) as Holder( )
    return { type<Holder>( "one", 1 ), type<Holder>( "two", 2 ) }
end function

var up = pts( )
print "udt " & up( 1 ).x & " " & up( 1 ).y
scope
    var uc = cs( )
    print "ctor " & uc( 0 ).v & " " & uc( 1 ).v
end scope
print "counts " & ctors & " " & dtors
scope
    var us = ss( )
    print "strudt " & us( 0 ).a & us( 1 ).a & us( 1 ).n
end scope

'' an array result as the argument of a call that returns one -- it was left untyped, and the
'' whole statement vanished without a diagnostic
function doubled( a( ) as integer ) as integer( )
    dim r( ) as integer
    redim r( lbound( a ) to ubound( a ) )
    for k as long = lbound( a ) to ubound( a )
        r( k ) = a( k ) * 2
    next
    return r
end function
var dd = doubled( foo( ) )
print "nested " & lbound( dd ) & " " & ubound( dd ) & " " & dd( 0 ) & " " & dd( 2 )
dim as long nsum
for each x as integer in doubled( foo( ) )
    nsum += x
next
print "nestedeach " & nsum
show( doubled( foo( ) ) )
