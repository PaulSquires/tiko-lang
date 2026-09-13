'' AN UNTYPED WIDE VALUE INTO A UDT RESULT. 'a + s' reaches '+' through the type's
'' 'cast( ) byref as const wstring' and Check gives it no type; 'wstr( "x" )' is an unbound
'' call and has none either.
''
'' WS is small and has no destructor, so it comes back BY VALUE out of a result slot. There
'' 'operator =' and 'function =' were declined, 'return a + s' was declined, and
'' 'return wstr( "lit" )' stored the wide POINTER over the object and crashed; a typed
'' 'wstring * 64' was copied bitwise where fbc converts it. fbc runs the
'' wstring 'let' for the first two and the converting constructor for the returns.
''
'' WD has a destructor, so its result is the hidden pointer; there only 'return a + s' was
'' still declined.
''
'' fbc-modern prints:
''
''    b: Fevrier 2026
''    c: Fevrier 2027
''    d: Fevrier!
''    g: lit
''    e: wvar
''    f: wasg
''    ws ctor= 13 let= 3
''    h: Fevrier 2028
''    wd ctor= 2 let= 0
type WS
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as wstring )
    declare operator let( byref w as wstring )
    declare operator cast( ) byref as const wstring
end type
type WD
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as wstring )
    declare destructor( )
    declare operator let( byref w as wstring )
    declare operator cast( ) byref as const wstring
end type
dim shared as long nctor, nlet, dctor, dlet
constructor WS( )
    nctor += 1
    buf = ""
end constructor
constructor WS( byref w as wstring )
    nctor += 1
    buf = w
end constructor
operator WS.let( byref w as wstring )
    nlet += 1
    buf = w
end operator
operator WS.cast( ) byref as const wstring
    return buf
end operator
constructor WD( )
    dctor += 1
    buf = ""
end constructor
constructor WD( byref w as wstring )
    dctor += 1
    buf = w
end constructor
destructor WD( )
end destructor
operator WD.let( byref w as wstring )
    dlet += 1
    buf = w
end operator
operator WD.cast( ) byref as const wstring
    return buf
end operator
operator & ( byref a as WS, byref s as string ) as WS
    operator = a + s
end operator
function viaReturn( byref a as WS, byref s as string ) as WS
    return a + s
end function
function viaAssign( byref a as WS ) as WS
    function = a + "!"
end function
function retLit( ) as WS
    return wstr( "lit" )
end function
function retVar( ) as WS
    dim as wstring * 64 w = "wvar"
    return w
end function
function asgVar( ) as WS
    dim as wstring * 64 w = "wasg"
    function = w
end function
function viaReturnD( byref a as WD, byref s as string ) as WD
    return a + s
end function
dim as WS a
a.buf = "Fevrier"
dim as WS b = a & " 2026"
print "b: "; str( b.buf )
dim as WS c = viaReturn( a, " 2027" )
print "c: "; str( c.buf )
dim as WS d = viaAssign( a )
print "d: "; str( d.buf )
dim as WS g = retLit( )
print "g: "; str( g.buf )
dim as WS e = retVar( )
print "e: "; str( e.buf )
dim as WS f = asgVar( )
print "f: "; str( f.buf )
print "ws ctor="; nctor; " let="; nlet
dim as WD ad
ad.buf = "Fevrier"
dim as WD h = viaReturnD( ad, " 2028" )
print "h: "; str( h.buf )
print "wd ctor="; dctor; " let="; dlet
