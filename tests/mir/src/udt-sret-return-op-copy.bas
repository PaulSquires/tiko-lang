'' 'return <operator>' COPIES THE OPERATOR'S RESULT INTO THE HIDDEN POINTER AND DESTROYS THE
'' TEMPORARY, as 'return f( )' does. tiko stored the temporary's bytes and forgot it, so a
'' type with no copy constructor ran one destructor fewer than fbc per 'return a + b', per
'' 'return -a', and for the outer operator of 'return a + b + a'. fbc:
''
''    _ZplR1HS0_( &TMP$15$1, A$1, B$1 );
''    __builtin_memcpy( tmp$14$1, &TMP$15$1, 8 );
''    _ZN1HD1Ev( &TMP$15$1 );
''
'' A call, a method and a property were already copied and destroyed that way; a type with
'' a copy constructor, written (CC) or implicit for a dynamic array member (D), is
'' copy-constructed and then destroyed, and was right too. H's destructor frees what the
'' caller now holds, so fbc's own count ends 'double= 6' -- the count to match.
''
'' Before the fix tiko printed:
''
''    add 3 ctor= 3 dtor= 0 double= 0
''    neg-1 ctor= 4 dtor= 0 double= 0
''    call 101 ctor= 5 dtor= 1 double= 0
''    meth 4 ctor= 6 dtor= 2 double= 0
''    prop-2 ctor= 7 dtor= 3 double= 0
''    chain 4 ctor= 9 dtor= 4 double= 0
''    h end ctor= 9 dtor= 12 double= 3
''    l 3 ctor= 3 dtor= 0 let= 0
''    l end ctor= 3 dtor= 3 let= 0
''    c 3 ctor= 3 copy= 1 dtor= 1
''    c end ctor= 3 copy= 1 dtor= 4
''    d 11 0
''
'' fbc-modern prints:
''
''    add 3 ctor= 3 dtor= 1 double= 0
''    neg-1 ctor= 4 dtor= 2 double= 0
''    call 101 ctor= 5 dtor= 3 double= 0
''    meth 4 ctor= 6 dtor= 4 double= 0
''    prop-2 ctor= 7 dtor= 5 double= 0
''    chain 4 ctor= 9 dtor= 7 double= 0
''    h end ctor= 9 dtor= 15 double= 6
''    l 3 ctor= 3 dtor= 1 let= 0
''    l end ctor= 3 dtor= 4 let= 0
''    c 3 ctor= 3 copy= 1 dtor= 1
''    c end ctor= 3 copy= 1 dtor= 4
''    d 11 0
'' H: allocates, records its "free", no copy constructor, no let
type H
    p as long ptr
    declare constructor( byval v as long )
    declare destructor( )
    declare function twice( ) as H
    declare property neg( ) as H
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
function H.twice( ) as H
    return H( *p * 2 )
end function
property H.neg( ) as H
    return H( -*p )
end property
operator + ( byref a as H, byref b as H ) as H
    return H( *a.p + *b.p )
end operator
operator - ( byref a as H ) as H
    return H( -*a.p )
end operator
function mkH( byval v as long ) as H
    return H( v )
end function

function rAdd( byref a as H, byref b as H ) as H
    return a + b
end function
function rNeg( byref a as H ) as H
    return -a
end function
function rCall( byref a as H ) as H
    return mkH( *a.p + 100 )
end function
function rMeth( byref a as H ) as H
    return a.twice( )
end function
function rProp( byref a as H ) as H
    return a.neg
end function
function rChain( byref a as H, byref b as H ) as H
    return a + b + a
end function

'' L: operator let, no copy constructor
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
function lAdd( byref a as L, byref b as L ) as L
    return a + b
end function

'' CC: copy constructor
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
operator + ( byref a as CC, byref b as CC ) as CC
    return a.v + b.v
end operator
function cAdd( byref a as CC, byref b as CC ) as CC
    return a + b
end function

'' D: a dynamic array member, no constructor
type D
    arr( any ) as long
end type
operator + ( byref a as D, byref b as D ) as D
    dim as D r
    redim r.arr( 0 )
    r.arr( 0 ) = a.arr( 0 ) + b.arr( 0 )
    return r
end operator
function dAdd( byref a as D, byref b as D ) as D
    return a + b
end function

scope
    dim as H a = H( 1 ), b = H( 2 )
    dim as H r1 = rAdd( a, b )
    print "add"; *r1.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H r2 = rNeg( a )
    print "neg"; *r2.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H r3 = rCall( a )
    print "call"; *r3.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H r4 = rMeth( b )
    print "meth"; *r4.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H r5 = rProp( b )
    print "prop"; *r5.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
    dim as H r7 = rChain( a, b )
    print "chain"; *r7.p; " ctor="; hctor; " dtor="; hdtor; " double="; hdouble
end scope
print "h end ctor="; hctor; " dtor="; hdtor; " double="; hdouble

scope
    dim as L la = L( 1 ), lb = L( 2 )
    dim as L lr = lAdd( la, lb )
    print "l"; lr.v; " ctor="; lctor; " dtor="; ldtor; " let="; llet
end scope
print "l end ctor="; lctor; " dtor="; ldtor; " let="; llet

scope
    dim as CC ca = CC( 1 ), cb = CC( 2 )
    dim as CC cr = cAdd( ca, cb )
    print "c"; cr.v; " ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
end scope
print "c end ctor="; cctor; " copy="; ccopy; " dtor="; cdtor

scope
    dim as D da, db
    redim da.arr( 0 ) : da.arr( 0 ) = 5
    redim db.arr( 0 ) : db.arr( 0 ) = 6
    dim as D dr = dAdd( da, db )
    print "d"; dr.arr( 0 ); ubound( dr.arr )
end scope
