'' AN UNTYPED WIDE ARGUMENT CHOOSES THE WSTRING OVERLOAD, whatever order the overloads
'' were declared in.
''
'' 'a + " 2027"' over a type that concatenates through 'cast( ) byref as const wstring' --
'' AfxNova's DWSTRING, and HS below -- has no Check type, and ResolveCall_ bound no call
'' with an untyped argument. Lowering then called the FIRST overload, and with
'' 'mk( byval n as long )' declared first that call declined: the declaration emitted
'' nothing, so c was never constructed and was destroyed anyway. 'nk', whose long
'' overload returns a STRING, and the SUB 'sk' declined the same way. Over a real DWSTRING
'' that is 0xC0000374 (Git Bash reports exit 127). Before the fix this printed
''
''    dim bad
''    let ok
''    nk bad
''    sk wide= 0 long= 0
''    hs ctor= 3 copy= 0 let= 1 dtor= 4 double= 0
''    done
''
'' with 3 statements not lowered. fbc's '#print typeof( a + " 2026" )' is WSTRING * 1,
'' and it calls the wstring overload every time:
''
''    _Z2MKRw( &C$1, TMP$15$1 );
''    struct $2HS* vr$13 = _Z2MKRw( &TMP$21$1, TMP$22$1 );
''    _ZN2HSaSERS_( &C$1, vr$13 );
''    _Z2NKRw( &D$1, TMP$29$1 );
''    _Z2SKRw( TMP$35$1 );
''
'' HS records each destroyed block rather than releasing it, as in
'' udt-sret-dim-untyped-arg.bas, so a second destruction is counted instead of crashing.
''
'' fbc-modern prints:
''
''    dim ok
''    let ok
''    nk ok
''    sk wide= 1 long= 0
''    hs ctor= 4 copy= 0 let= 1 dtor= 4 double= 0
''    done

type HS
    p as wstring ptr
    declare constructor( )
    declare constructor( byref w as wstring )
    declare constructor( byref o as HS )
    declare destructor( )
    declare operator let( byref o as HS )
    declare operator cast( ) byref as const wstring
end type
dim shared as long hctor, hcopy, hlet, hdtor, hfree, hdouble
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
operator HS.let( byref o as HS )
    hlet += 1
    *p = *o.p
end operator
operator HS.cast( ) byref as const wstring
    return *p
end operator

'' the long overload FIRST
function mk overload( byval n as long ) as HS
    return "n"
end function
function mk overload( byref s as wstring ) as HS
    return s
end function
'' long first, and a DIFFERENT result type
function nk overload( byval n as long ) as string
    return "n"
end function
function nk overload( byref s as wstring ) as HS
    return s
end function
dim shared as long skw, skn
sub sk overload( byval n as long )
    skn += 1
end sub
sub sk overload( byref s as wstring )
    if s = "Mars 2030" then skw += 1
end sub

scope
    dim as HS a = "Mars"
    dim as HS c = mk( a + " 2027" )
    if *c.p = "Mars 2027" then print "dim ok" else print "dim bad"
    c = mk( a & " 2028" )
    if *c.p = "Mars 2028" then print "let ok" else print "let bad"
    dim as HS d = nk( a + " 2029" )
    if *d.p = "Mars 2029" then print "nk ok" else print "nk bad"
    sk( a + " 2030" )
    print "sk wide="; skw; " long="; skn
end scope
print "hs ctor="; hctor; " copy="; hcopy; " let="; hlet; " dtor="; hdtor; " double="; hdouble
print "done"
