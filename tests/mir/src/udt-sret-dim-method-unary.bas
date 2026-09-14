'' A METHOD, A PROPERTY AND A UNARY OPERATOR BUILD 'dim as T x = ...' IN PLACE, as a
'' function and a binary operator already do (udt-sret-dim-in-place). fbc passes the
'' declared variable as the hidden result for every one:
''
''    _ZN3FAC2MKEi( &X1$1, &OBJ$1, 1 );     _ZN3FAC2MKEi( &X2$1, PF$1, 2 );
''    _ZN3FAC3SMKEi( &X3$1, 3 );            _ZN1H4PLUSEi( &X4$1, &X1$1, 10 );
''    _ZngR1H( &X5$1, &X1$1 );              _ZN3FAC9HP__get__Ev( &X6$1, &OBJ$1 );
''    _ZN3FAC2MKEi( &I2$1, THIS$1, 9 );     _ZngR2CC( &C2$1, &C1$1 );
''
'' tiko built each method's and getter's result in a temporary, stored its bytes over x
'' and destroyed the temporary: with the two unary lines spelled as constructor calls it
'' printed 'h ctor= 8 dtor= 14 double= 6'. A global UNARY operator returning such a type
'' passed no hidden result at all -- 'calls _ZngR1H with 1 arguments, which declares 2'
'' -- and clang refused the module.
''
'' The second scope chains calls whose RECEIVER calls the same symbol -- 'x.twin.twin',
'' '-(-x)', 'x.plus( 1 ).plus( 2 )'. Only the outermost call may build the variable. The
'' third calls without parentheses, 'obj.mk0' and 'mkfree'; so does 'mk0' inside 'inner'.
''
'' fbc-modern prints:
''
''    inner 1008 1009 1000
''     1001 1002 103 1011-1001 2000
''     1005-1005
''     8-2 5 80 20 11-10
''     7 3
''    h ctor= 25 dtor= 25 double= 0
''    cc ctor= 2 copy= 0 dtor= 2
'' H: allocates, records its "free", no copy constructor (hidden-pointer result)
type H
    p as long ptr
    declare constructor( byval v as long )
    declare destructor( )
    declare function plus( byval n as long ) as H
    declare property twin( ) as H
end type
dim shared as long hctor, hdtor, hfree, hdouble
dim shared as any ptr freed(0 to 63)
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
property H.twin( ) as H
    return H( *p * 2 )
end property
operator - ( byref a as H ) as H
    return H( -*a.p )
end operator

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
operator - ( byref a as CC ) as CC
    return -a.v
end operator

type Fac
    base_ as long
    declare function mk( byval v as long ) as H
    declare static function smk( byval v as long ) as H
    declare function mkc( byval v as long ) as CC
    declare property hp( ) as H
    declare function mk0( ) as H
    declare sub inner( )
end type
function Fac.mk( byval v as long ) as H
    return H( base_ + v )
end function
function Fac.smk( byval v as long ) as H
    return H( 100 + v )
end function
function Fac.mkc( byval v as long ) as CC
    return base_ + v
end function
property Fac.hp( ) as H
    return H( base_ * 2 )
end property
function Fac.mk0( ) as H
    return H( base_ )
end function
function mkfree( byval n as long = 3 ) as H
    return H( n )
end function
function mkfac( byval n as long ) as Fac
    dim as Fac f
    f.base_ = n
    return f
end function
sub Fac.inner( )
    dim as H i1 = mk( 8 )
    dim as H i2 = this.mk( 9 )
    dim as H i3 = mk0
    print "inner"; *i1.p; *i2.p; *i3.p
end sub

scope
    dim as Fac obj = ( 1000 )
    dim as Fac ptr pf = @obj
    dim as H x1 = obj.mk( 1 )
    dim as H x2 = pf->mk( 2 )
    dim as H x3 = Fac.smk( 3 )
    dim as H x4 = x1.plus( 10 )
    dim as H x5 = -x1
    dim as H x6 = obj.hp
    obj.inner( )
    print *x1.p; *x2.p; *x3.p; *x4.p; *x5.p; *x6.p
    dim as CC c1 = obj.mkc( 5 )
    dim as CC c2 = -c1
    print c1.v; c2.v
end scope
'' A RECEIVER CALLING THE SAME SYMBOL does not build the variable; the outermost call does.
'' The inner results are temporaries, destroyed at the end of the statement as fbc does.
scope
    dim as H x = H( 5 )
    dim as H a1 = x.plus( 1 ).plus( 2 )
    dim as H a2 = (-x).plus( 3 )
    dim as H a3 = -(-x)
    dim as H a4 = mkfac( 40 ).hp
    dim as H a5 = x.twin.twin
    dim as H a6 = x.twin.plus( 1 )
    dim as H a7 = -x.twin
    print *a1.p; *a2.p; *a3.p; *a4.p; *a5.p; *a6.p; *a7.p
end scope
'' A PAREN-LESS CALL -- every argument defaulted -- builds the variable in place too.
scope
    dim as Fac obj = ( 7 )
    dim as H z1 = obj.mk0
    dim as H z2 = mkfree
    print *z1.p; *z2.p
end scope
print "h ctor="; hctor; " dtor="; hdtor; " double="; hdouble
print "cc ctor="; cctor; " copy="; ccopy; " dtor="; cdtor
