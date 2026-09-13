'' DIM AS T X = F( ... ) BUILDS X IN PLACE when F's UDT result travels through the hidden
'' pointer -- a function or a user global operator, with or without a copy constructor.
'' fbc passes the variable itself as the hidden result:
''
''    struct $2WS C$0;
''    VIARETURN( &C$0, &A$0, &TMP$16$0 );
''
'' tiko default-constructed x, called into a separate temporary, stored its bytes over x
'' and, for a function, destroyed the temporary. Before the fix it printed
''
''    ws ctor= 5 dtor= 4 let= 0
''    h ctor= 2 dtor= 3 double= 1
''    cc ctor= 2 copy= 1 dtor= 2
''
'' -- H's block destroyed twice, and 'n' copied out of an operator temporary.
''
'' CC's functions return the raw value through the converting constructor. 'return CC( n )'
'' would count copies of its own: tiko still builds that into a temporary and copies it into
'' the hidden result, where fbc constructs there directly.
''
'' fbc-modern prints:
''
''    Fevrier 2026 / Fevrier 2027
''    ws ctor= 3 dtor= 3 let= 0
''     5 7
''    h ctor= 2 dtor= 2 double= 0
''     7 8
''    cc ctor= 2 copy= 0 dtor= 2
type WS
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as wstring )
    declare destructor( )
    declare operator let( byref w as wstring )
    declare operator cast( ) byref as const wstring
end type
dim shared as long nctor, ndtor, nlet
constructor WS( )
    nctor += 1
    buf = ""
end constructor
constructor WS( byref w as wstring )
    nctor += 1
    buf = w
end constructor
destructor WS( )
    ndtor += 1
end destructor
operator WS.let( byref w as wstring )
    nlet += 1
    buf = w
end operator
operator WS.cast( ) byref as const wstring
    return buf
end operator
operator & ( byref a as WS, byref s as string ) as WS
    dim as wstring * 64 t = a.buf
    t &= s
    return WS( t )
end operator
function viaReturn( byref a as WS, byref s as string ) as WS
    dim as wstring * 64 t = a.buf
    t &= s
    return WS( t )
end function

'' H allocates in its constructor and "frees" in its destructor, and has no copy
'' constructor. The block is recorded rather than released, so no address is reused and
'' a second destruction of one block is counted exactly.
type H
    p as long ptr
    declare constructor( byval v as long )
    declare destructor( )
end type
dim shared as long hctor, hdtor, hfree, hdouble
dim shared as any ptr freed(0 to 15)
constructor H( byval v as long )
    hctor += 1
    p = callocate( sizeof( long ) )
    *p = v
end constructor
destructor H( )
    hdtor += 1
    for i as long = 0 to hfree - 1
        if freed(i) = p then
            hdouble += 1
            exit destructor
        end if
    next
    freed(hfree) = p
    hfree += 1
end destructor
function mkH( byval v as long ) as H
    return H( v )
end function
operator + ( byref a as H, byval v as long ) as H
    return H( *a.p + v )
end operator

'' CC has a copy constructor, as AfxNova's DWSTRING does.
type CC
    v as long
    declare constructor( byval n as long )
    declare constructor( byref o as CC )
    declare destructor( )
end type
dim shared as long cctor, ccopy, cdtor
constructor CC( byval n as long )
    cctor += 1
    v = n
end constructor
constructor CC( byref o as CC )
    ccopy += 1
    v = o.v
end constructor
destructor CC( )
    cdtor += 1
end destructor
function mkC( byval n as long ) as CC
    return n
end function
operator + ( byref a as CC, byval n as long ) as CC
    return a.v + n
end operator

scope
    dim as WS a = "Fevrier"
    dim as WS b = a & " 2026"
    dim as WS c = viaReturn( a, " 2027" )
    print str( b.buf ); " / "; str( c.buf )
end scope
print "ws ctor="; nctor; " dtor="; ndtor; " let="; nlet

scope
    dim as H x = mkH( 5 )
    dim as H y = x + 2
    print *x.p; *y.p
end scope
print "h ctor="; hctor; " dtor="; hdtor; " double="; hdouble

scope
    dim as CC m = mkC( 7 )
    dim as CC n = m + 1
    print m.v; n.v
end scope
print "cc ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
