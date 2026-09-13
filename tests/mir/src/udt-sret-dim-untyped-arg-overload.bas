'' DIM AS T X = F( <A WIDE ARGUMENT CHECK LEAVES UNTYPED> ) OVER AN OVERLOADED F.
''
'' udt-sret-dim-untyped-arg.bas builds x in place when f has one overload. With a second
'' -- 'mk( byval n as long )' beside 'mk( byref s as wstring )' -- UntypedCallResult_
'' declined, and the declaration took the old double lowering: the call lowered and its
'' result dropped, x default-constructed, the call lowered AGAIN, its bytes stored over x
'' and that temporary destroyed. Over AfxNova's DWSTRING that is 0xC0000374 at the end of
'' the scope (Git Bash reports exit 127). Every overload here returns the same type, so
'' the result is known without deciding which one the argument selects.
''
'' HS records each destroyed block rather than releasing it, as in
'' udt-sret-dim-untyped-arg.bas, so a second destruction is counted instead of crashing.
'' Before the fix this printed
''
''    ws ok
''    ws ctor= 3 copy= 0 dtor= 3
''    hs ok
''    hs ctor= 3 copy= 0 dtor= 3 double= 1
''    done
''
'' fbc builds x in place, the same as for one overload:
''
''    _Z2WKRw( &B$1, TMP$14$1 );
''    _Z2MKRw( &C$1, TMP$26$1 );
''
'' fbc-modern prints:
''
''    ws ok
''    ws ctor= 2 copy= 0 dtor= 2
''    hs ok
''    hs ctor= 2 copy= 0 dtor= 2 double= 0
''    done

type WS
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as wstring )
    declare constructor( byref o as WS )
    declare destructor( )
    declare operator cast( ) byref as const wstring
end type
dim shared as long nctor, ncopy, ndtor
constructor WS( )
    nctor += 1
    buf = ""
end constructor
constructor WS( byref w as wstring )
    nctor += 1
    buf = w
end constructor
constructor WS( byref o as WS )
    ncopy += 1
    buf = o.buf
end constructor
destructor WS( )
    ndtor += 1
end destructor
operator WS.cast( ) byref as const wstring
    return buf
end operator
function wk overload( byref s as wstring ) as WS
    return s
end function
function wk overload( byval n as long ) as WS
    return "n"
end function

type HS
    p as wstring ptr
    declare constructor( )
    declare constructor( byref w as wstring )
    declare constructor( byref o as HS )
    declare destructor( )
    declare operator cast( ) byref as const wstring
end type
dim shared as long hctor, hcopy, hdtor, hfree, hdouble
dim shared as any ptr freed(0 to 15)
constructor HS( )
    hctor += 1
    p = callocate( 256 )
end constructor
constructor HS( byref w as wstring )
    hctor += 1
    p = callocate( 256 )
    *p = w
end constructor
constructor HS( byref o as HS )
    hcopy += 1
    p = callocate( 256 )
    *p = *o.p
end constructor
destructor HS( )
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
operator HS.cast( ) byref as const wstring
    return *p
end operator
function mk overload( byref s as wstring ) as HS
    return s
end function
function mk overload( byval n as long ) as HS
    return "n"
end function

scope
    dim as WS a = "Mars"
    dim as WS b = wk( a + " 2026" )
    if b.buf = "Mars 2026" then print "ws ok" else print "ws bad"
end scope
print "ws ctor="; nctor; " copy="; ncopy; " dtor="; ndtor

scope
    dim as HS a = "Fevrier"
    dim as HS c = mk( a + " 2027" )
    if *c.p = "Fevrier 2027" then print "hs ok" else print "hs bad"
end scope
print "hs ctor="; hctor; " copy="; hcopy; " dtor="; hdtor; " double="; hdouble
print "done"
