'' DIM AS T X = F( <A WIDE ARGUMENT CHECK LEAVES UNTYPED> ) BUILDS X IN PLACE.
''
'' 'a + " 2027"' over a type that concatenates through 'cast( ) byref as const wstring' --
'' AfxNova's DWSTRING, and WS and HS below -- has no Check type, and ResolveCall_ types no
'' call with an untyped argument, so 'mk( a + " 2027" )' had none either. The declaration
'' then took neither the in-place build nor the copy: tiko lowered the call and dropped
'' its result, default-constructed x, lowered the call AGAIN, stored its bytes over x and
'' destroyed that temporary -- so x's block was destroyed twice. Over a real DWSTRING
'' that is 0xC0000374 at the end of the scope (Git Bash reports exit 127).
''
'' HS owns a block as DWSTRING does. Its destructor records the block rather than
'' releasing it, as H in udt-sret-dim-in-place.bas does, so a second destruction is
'' counted instead of crashing. Before the fix this printed
''
''    ws ok
''    ws ctor= 3 copy= 0 dtor= 3
''    hs ok
''    hs ctor= 3 copy= 0 dtor= 3 double= 1
''    done
''
'' fbc builds one wide temporary for the argument and x in place:
''
''    uint16* vr$18 = fb_WstrConcatWA( vr$17, (void*)" 2027", 6ll );
''    TMP$22$1 = vr$18;
''    MK( &C$1, TMP$22$1 );
''    fb_WstrDelete( (uint16*)TMP$22$1 );
''
'' and the same for WS, 'WK( &B$1, TMP$10$1 )'.
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
function wk( byref s as wstring ) as WS
    return s
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
function mk( byref s as wstring ) as HS
    return s
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
