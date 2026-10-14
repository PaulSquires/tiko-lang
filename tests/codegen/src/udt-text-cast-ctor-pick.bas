'' A UDT whose 'operator cast' yields text, passed where a type constructible from
'' several text types is wanted. Every pick here is fbc-modern's, measured; the losing
'' constructors are declared FIRST, so a fallback to the chain's head shows.

type CS
    as long x
    declare operator cast( ) as string
end type
operator CS.cast( ) as string
    return "s" & x
end operator

type CU
    as long x
    declare operator cast( ) as ustring
end type
operator CU.cast( ) as ustring
    return "u" & x
end operator

type CW
    as long x
    declare operator cast( ) byref as wstring
end type
operator CW.cast( ) byref as wstring
    static w as wstring * 8 = "w"
    return w
end operator

type CZ
    as long x
    declare operator cast( ) byref as zstring
end type
operator CZ.cast( ) byref as zstring
    static z as zstring * 8 = "z"
    return z
end operator

type CP
    as long x
    declare operator cast( ) as zstring ptr
end type
operator CP.cast( ) as zstring ptr
    return @"p"
end operator

'' string, ustring and boolean: a string cast takes 'string' -- with boolean first in the
'' chain this was an internal compiler error, with ustring first an EMPTY ustring.
type A1
    as ustring v
    as long k
    declare constructor( byval b as boolean )
    declare constructor( byref s as const ustring )
    declare constructor( byref s as const string )
end type
constructor A1( byval b as boolean ) : k = 1 : v = "bool" : end constructor
constructor A1( byref s as const ustring ) : k = 2 : v = s : end constructor
constructor A1( byref s as const string ) : k = 3 : v = s : end constructor

'' ustring and zstring: a string cast prefers 'zstring', a ustring cast 'ustring'.
type A2
    as string v
    as long k
    declare constructor( byref s as const ustring )
    declare constructor( byref s as const zstring )
end type
constructor A2( byref s as const ustring ) : k = 4 : v = s : end constructor
constructor A2( byref s as const zstring ) : k = 5 : v = s : end constructor

'' string and zstring: a ustring cast prefers 'zstring', a zstring cast 'zstring'.
type A3
    as string v
    as long k
    declare constructor( byref s as const string )
    declare constructor( byref s as const zstring )
end type
constructor A3( byref s as const string ) : k = 6 : v = s : end constructor
constructor A3( byref s as const zstring ) : k = 7 : v = s : end constructor

'' string, ustring, wstring: a zstring cast prefers 'string', a wstring cast 'wstring'.
type A4
    as string v
    as long k
    declare constructor( byref s as const wstring )
    declare constructor( byref s as const ustring )
    declare constructor( byref s as const string )
end type
constructor A4( byref s as const wstring ) : k = 8 : v = s : end constructor
constructor A4( byref s as const ustring ) : k = 9 : v = s : end constructor
constructor A4( byref s as const string ) : k = 10 : v = s : end constructor

'' boolean and a BYVAL string: a ustring or wstring cast is CONVERTED into the string --
'' tiko lowered the UDT's own bytes, declined, and stopped (TKO0994).
type A5
    as string v
    as long k
    declare constructor( byval b as boolean )
    declare constructor( byval s as string )
end type
constructor A5( byval b as boolean ) : k = 11 : v = "bool" : end constructor
constructor A5( byval s as string ) : k = 12 : v = s : end constructor

'' a 'zstring ptr' cast reaches 'byval as const zstring ptr' -- tiko refused it (TKO0698).
type A6
    as string v
    as long k
    declare constructor( byref s as const string )
    declare constructor( byval p as const zstring ptr )
end type
constructor A6( byref s as const string ) : k = 13 : v = s : end constructor
constructor A6( byval p as const zstring ptr ) : k = 14 : v = *p : end constructor

sub T1( byref tag as const string, byref a as const A1 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
sub T2( byref tag as const string, byref a as const A2 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
sub T3( byref tag as const string, byref a as const A3 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
sub T4( byref tag as const string, byref a as const A4 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
sub T5( byref tag as const string, byref a as const A5 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
sub T6( byref tag as const string, byref a as const A6 ) : print tag & "=" & a.k & "[" & a.v & "]" : end sub
function F1( byref a as const A1 ) as ustring
    return a.v
end function

dim as CS vs = ( 1 )
dim as CU vu = ( 2 )
dim as CW vw
dim as CZ vz
dim as CP vp

T1( "T1s", vs )
print "F1=[" & F1( vs ) & "]"
T2( "T2s", vs )
T2( "T2u", vu )
T3( "T3u", vu )
T3( "T3z", vz )
T4( "T4z", vz )
T4( "T4w", vw )
T5( "T5u", vu )
T5( "T5w", vw )
T6( "T6p", vp )
