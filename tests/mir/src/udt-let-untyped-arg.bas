'' X = F( <A WIDE ARGUMENT CHECK LEAVES UNTYPED> ) CALLS X'S ASSIGNMENT OPERATOR.
''
'' 'a + " 2028"' over a type that concatenates through 'cast( ) byref as const wstring' --
'' AfxNova's DWSTRING, and HS below -- has no Check type, so neither has 'mk( a + " 2028" )',
'' and the assignment missed the same-type 'operator let'. It reached the aggregate store
'' instead: the result built in a temporary, its bytes stored over x, the temporary
'' destroyed. x's own block leaked and the new one was destroyed twice -- over a real
'' DWSTRING, 0xC0000374 at the end of the scope. The second assignment calls an OVERLOADED
'' function whose overloads share a result type; see UntypedCallResult_.
''
'' HS records each destroyed block rather than releasing it, as in
'' udt-sret-dim-untyped-arg.bas, so a second destruction is counted instead of crashing.
'' Before the fix this printed
''
''    one ok
''    overload ok
''    hs ctor= 4 copy= 0 let= 0 dtor= 4 double= 1
''    done
''
'' fbc calls the operator and destroys the temporary after:
''
''    struct $2HS* vr$6 = MK( &TMP$11$1, TMP$13$1 );
''    _ZN2HSaSERS_( &C$1, vr$6 );
''    fb_WstrDelete( (uint16*)TMP$13$1 );
''    _ZN2HSD1Ev( &TMP$11$1 );
''
'' and the same for 'mko', '_Z3MKORw( &TMP$19$1, TMP$20$1 )'.
''
'' fbc-modern prints:
''
''    one ok
''    overload ok
''    hs ctor= 4 copy= 0 let= 2 dtor= 4 double= 0
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
function mk( byref s as wstring ) as HS
    return s
end function
function mko overload( byref s as wstring ) as HS
    return s
end function
function mko overload( byval n as long ) as HS
    return "n"
end function

scope
    dim as HS a = "Mars"
    dim as HS c
    c = mk( a + " 2028" )
    if *c.p = "Mars 2028" then print "one ok" else print "one bad"
    c = mko( a + " 2029" )
    if *c.p = "Mars 2029" then print "overload ok" else print "overload bad"
end scope
print "hs ctor="; hctor; " copy="; hcopy; " let="; hlet; " dtor="; hdtor; " double="; hdouble
print "done"
