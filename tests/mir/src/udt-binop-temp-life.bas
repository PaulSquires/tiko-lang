'' A USER BINARY OPERATOR'S HIDDEN RESULT IS A TEMPORARY, DESTROYED AT THE END OF THE
'' STATEMENT, as a call's is. tiko never registered it, so 'x = a + b' leaked the result --
'' through a bitwise store and through 'operator let' alike -- and so did an operator result
'' passed as an argument, under a member access, inside 'a + b + c' and in 'return a + b'.
'' fbc destroys it after every use:
''
''    _ZplR1HR1H( &TMP$23$1, &A$1, &B$1 );
''    __builtin_memcpy( &X$1, &TMP$23$1, 8 );
''    _ZN1HD1Ev( &TMP$23$1 );
''
'' H has no copy constructor and no 'let': the copy is bitwise and the temporary's destructor
'' frees what x now holds, so fbc's own count ends 'double= 2'. That is the count to match.
'' The counters are read in a statement of their own, so every count is taken after the
'' statement's temporaries are gone -- see tests/mir/src/udt-stmt-temp-life.bas.
''
'' Before the fix tiko printed:
''
''    h0 ctor= 4 dtor= 0
''    h1 x= 3 ctor= 5 dtor= 0 double= 0
''    h2 x= 7 ctor= 7 dtor= 0 double= 0
''    h3 x= 9 ctor= 8 dtor= 1 double= 0
''    h4 x=-1 ctor= 9 dtor= 2 double= 0
''    h5 arg= 3 ctor= 10 dtor= 2 double= 0
''    h6 mem= 5 ctor= 11 dtor= 2 double= 0
''    h7 y= 13 ctor= 13 dtor= 2 double= 0
''    h9 byval= 3 ctor= 14 dtor= 3 double= 0
''    h end ctor= 14 dtor= 8 double= 1
''    l1 x= 3 ctor= 4 dtor= 0 let= 1
''    l end ctor= 4 dtor= 3 let= 1
''    c1 x= 3 ctor= 4 copy= 0 dtor= 0 let= 1
''    c2 s= 3 ctor= 5 copy= 1 dtor= 0 let= 1
''    c3 byval= 3 ctor= 6 copy= 2 dtor= 1 let= 1
''    c end ctor= 6 copy= 2 dtor= 5 let= 1
''
'' fbc-modern prints:
''
''    h0 ctor= 4 dtor= 0
''    h1 x= 3 ctor= 5 dtor= 1 double= 0
''    h2 x= 7 ctor= 7 dtor= 3 double= 0
''    h3 x= 9 ctor= 8 dtor= 4 double= 0
''    h4 x=-1 ctor= 9 dtor= 5 double= 0
''    h5 arg= 3 ctor= 10 dtor= 6 double= 0
''    h6 mem= 5 ctor= 11 dtor= 7 double= 0
''    h7 y= 13 ctor= 13 dtor= 8 double= 0
''    h9 byval= 3 ctor= 14 dtor= 10 double= 1
''    h end ctor= 14 dtor= 15 double= 2
''    l1 x= 3 ctor= 4 dtor= 1 let= 1
''    l end ctor= 4 dtor= 4 let= 1
''    c1 x= 3 ctor= 4 copy= 0 dtor= 1 let= 1
''    c2 s= 3 ctor= 5 copy= 1 dtor= 2 let= 1
''    c3 byval= 3 ctor= 6 copy= 2 dtor= 4 let= 1
''    c end ctor= 6 copy= 2 dtor= 8 let= 1
'' H: allocates, records its "free", no copy constructor, no let (hidden-pointer result)
type H
    p as long ptr
    declare constructor( byval v as long )
    declare destructor( )
    declare function plus( byval n as long ) as H
end type
dim shared as long hctor, hdtor, hfree, hdouble
dim shared as any ptr freed(0 to 127)
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
function H.plus( byval n as long ) as H
    return H( *p + n )
end function
operator + ( byref a as H, byref b as H ) as H
    return H( *a.p + *b.p )
end operator
operator - ( byref a as H ) as H
    return H( -*a.p )
end operator
function mkH( byval v as long ) as H
    return H( v )
end function
function takeR( byref hh as H ) as long
    return *hh.p
end function
function takeV( byval hh as H ) as long
    return *hh.p
end function

'' L: has operator let (deep copy), destructor
type L
    v as long
    declare constructor( byval n as long )
    declare destructor( )
    declare operator let( byref o as L )
end type
dim shared as long lctor, ldtor, llet
constructor L( byval n as long )
    lctor += 1
    v = n
end constructor
destructor L( )
    ldtor += 1
end destructor
operator L.let( byref o as L )
    llet += 1
    v = o.v
end operator
operator + ( byref a as L, byref b as L ) as L
    return L( a.v + b.v )
end operator

'' CC: copy constructor and let
type CC
    v as long
    declare constructor( byval n as long )
    declare constructor( byref o as CC )
    declare destructor( )
    declare operator let( byref o as CC )
end type
dim shared as long cctor, ccopy, cdtor, clet
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
operator CC.let( byref o as CC )
    clet += 1
    v = o.v
end operator
operator + ( byref a as CC, byref b as CC ) as CC
    return a.v + b.v
end operator
function sumC( byref a as CC, byref b as CC ) as CC
    return a + b
end function
function takeCV( byval cc_ as CC ) as long
    return cc_.v
end function

scope
    dim as H a = H( 1 ), b = H( 2 ), c = H( 4 ), x = H( 0 )
    print "h0 ctor="; hctor; " dtor="; hdtor
    x = a + b
    print "h1 x="; *x.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    x = a + b + c
    print "h2 x="; *x.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    x = mkH( 9 )
    print "h3 x="; *x.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    x = -a
    print "h4 x="; *x.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as long r5 = takeR( a + b )
    print "h5 arg="; r5; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as long r6 = *(a + c).p
    print "h6 mem="; r6; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H y = (a + b).plus( 10 )
    print "h7 y="; *y.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as long r9 = takeV( a + b )
    print "h9 byval="; r9; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
end scope
print "h end ctor="; hctor; " dtor="; hdtor; " double="; hdouble

scope
    dim as L la = L( 1 ), lb = L( 2 ), lx = L( 0 )
    lx = la + lb
    print "l1 x="; lx.v; " ctor="; lctor; " dtor="; ldtor; " let="; llet
end scope
print "l end ctor="; lctor; " dtor="; ldtor; " let="; llet

scope
    dim as CC ca = CC( 1 ), cb = CC( 2 ), cx = CC( 0 )
    cx = ca + cb
    print "c1 x="; cx.v; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor; " let="; clet
    dim as CC cs = sumC( ca, cb )
    print "c2 s="; cs.v; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor; " let="; clet
    dim as long r3 = takeCV( ca + cb )
    print "c3 byval="; r3; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor; " let="; clet
end scope
print "c end ctor="; cctor; " copy="; ccopy; " dtor="; cdtor; " let="; clet
