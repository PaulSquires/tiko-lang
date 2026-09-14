'' A STATIC LOCAL INITIALISED FROM A CALL RETURNING ITS OWN TYPE. The guard and the atexit
'' thunk were emitted and the call was not: the static stayed zeroed, it verified, and
'' nothing was declined. fbc-modern calls into a TEMPORARY on the first pass, COPIES that
'' into the static and destroys the temporary after the atexit call -- never in place:
''
''     MKH( &TMP$13$1, 3 );
''     __builtin_memcpy( &tmp$31, &TMP$13$1, 4 );          no copy constructor
''     atexit( (void*)&LABEL$38 );
''     _ZN1HD1Ev( &TMP$13$1 );
''     _ZN3FAC2MKEi( &TMP$16$1, &GF$, 4 );                 a method, likewise
''     ...
''     int32 vr$19 = LENOF( &TMP$21$1 );
''     MKH( &TMP$18$1, vr$19 );
''     __builtin_memcpy( &tmp$35, &TMP$18$1, 4 );
''     atexit( (void*)&LABEL$50 );
''     fb_StrDelete( (FBSTRING*)&TMP$21$1 );               the argument's string, inside
''     _ZN1HD1Ev( &TMP$18$1 );                             the guard too
''     struct $1C* vr$25 = MKC( &TMP$22$1, 6 );
''     _ZN1CC1ERS_( &tmp$36, vr$25 );                      a written copy constructor
''     struct $1S* vr$28 = MKSTR( &TMP$23$1, 7 );
''     _ZN1SC1ERKS_( &tmp$37, (struct $1S*)vr$28 );        a synthesised one
''     struct $1K vr$30 = MKK( 8 );
''     K1$1 = vr$30;                                       no destructor: a plain store
''
'' 'static as H h2 = mkh' is 'MKH( &TMP$15$1, 3 )', the same as the call with parens.
'' fbc-modern prints, and tiko prints too:
''
''     3 3 14 55 5 600 val7 7 8
''    H ctor= 5 dtor= 5 C ctor= 1 copy= 1 dtor= 1 K ctor= 1 len= 1
''     4 4 14 55 6 601 val7 8 9
''    H ctor= 5 dtor= 5 C ctor= 1 copy= 1 dtor= 1 K ctor= 1 len= 1
''
'' 'copy= 1' and 'dtor= 5' on the first line are the copy and the temporaries; the same
'' counts on the second are the guard.
dim shared as long hCtor, hDtor, cCtor, cCopy, cDtor, kCtor, lCalls

'' no copy constructor: the bytes are copied
type H
    v as long
    declare constructor( byval v as long )
    declare destructor( )
end type
constructor H( byval v as long ) : hCtor += 1 : this.v = v : end constructor
destructor H( ) : hDtor += 1 : end destructor

function mkh( byval n as long = 3 ) as H
    return H( n )
end function

type Fac
    base_ as long
    declare function mk( byval n as long ) as H
    declare static function smk( byval n as long ) as H
end type
function Fac.mk( byval n as long ) as H
    return H( n + base_ )
end function
static function Fac.smk( byval n as long ) as H
    return H( n + 50 )
end function
dim shared as Fac gf

'' a written copy constructor
type C
    v as long
    declare constructor( byval v as long )
    declare constructor( byref o as C )
    declare destructor( )
end type
constructor C( byval v as long ) : cCtor += 1 : this.v = v : end constructor
constructor C( byref o as C ) : cCopy += 1 : this.v = o.v * 100 : end constructor
destructor C( ) : cDtor += 1 : end destructor
function mkc( byval n as long ) as C
    return C( n )
end function

'' a synthesised copy constructor, through a string field
type S
    t as string
    n as long
end type
function mkstr( byval n as long ) as S
    dim as S r
    r.t = "val" & n
    r.n = n
    return r
end function

'' no destructor: the result comes back in registers
type K
    v as long
    declare constructor( byval v as long )
end type
constructor K( byval v as long ) : kCtor += 1 : this.v = v : end constructor
function mkk( byval n as long ) as K
    return K( n )
end function

function lenof( byref txt as string ) as long
    lCalls += 1
    return len( txt )
end function
dim shared as long gx = 12

sub run1( )
    static as H h1 = mkh( 3 )
    static as H h2 = mkh
    static as H h3 = gf.mk( 4 )
    static as H h4 = Fac.smk( 5 )
    static as H h5 = mkh( lenof( str( gx ) & "abc" ) )
    static as C c1 = mkc( 6 )
    static as S s1 = mkstr( 7 )
    static as K k1 = mkk( 8 )
    print h1.v; h2.v; h3.v; h4.v; h5.v; c1.v; " "; s1.t; s1.n; k1.v
    print "H ctor="; hCtor; " dtor="; hDtor; " C ctor="; cCtor; " copy="; cCopy; _
          " dtor="; cDtor; " K ctor="; kCtor; " len="; lCalls
    h1.v += 1 : h2.v += 1 : h5.v += 1 : c1.v += 1 : s1.n += 1 : k1.v += 1
end sub

gf.base_ = 10
run1( )
gx = 12345
run1( )
