'' 'RETURN T( ARGS )' IN PLACE, FOR TYPES WITH MULTI-DIMENSIONAL ARRAYS. EL counts its default
'' constructor, copy constructor and destructor; M2 holds a dynamic 2-D long array, M3E a
'' dynamic 3-D array of EL with a lower bound of 1 beside a written destructor, F2E a fixed 2-D
'' array of EL bounded ( 1 to 2, -1 to 1 ), and M2P a 2-D array of EL grown on its first
'' dimension with 'redim preserve'. fbc-modern's C for each of the six functions below is one
'' constructor call on the hidden pointer, and the argument is evaluated once:
''
''     _ZN2M2C1Eii( tmp$30$1, R$1, C$1 );
''     int32 vr$0 = NEXTARG(  );
''     _ZN3M3EC1Ei( tmp$36$1, vr$0 );
''     _ZN3F2EC1Ei( tmp$38$1, N$1 );
''     _ZN3M2PC1Ei( tmp$40$1, N$1 );
''
'' fbc-modern prints, and tiko prints too:
''
''     1 2 23 | 1 1 112 | 0 101 | 1 12
''    -1 57 33 | 2 3 31
''    E ctor= 35 copy= 0 dtor= 0 U dtor= 0 arg= 1
''     3 23 99 | 2 112 77
''    E ctor= 39 copy= 0 dtor= 0 U dtor= 0 arg= 1
''     0 102 | 1 22
''    E ctor= 59 copy= 0 dtor= 31 U dtor= 1 arg= 1
''    E ctor= 59 copy= 0 dtor= 59 U dtor= 4 arg= 1
''
'' 'copy= 0' throughout. The caller's 'redim preserve' on the first dimension of a RETURNED
'' object's array keeps its values and constructs only its four new elements, and the two
'' assignments over returned objects destroy 31: a descriptor shared with a temporary, or
'' freed with one, would show in the values or the counts.
dim shared as long eCtor, eCopy, eDtor, uDtor, nArg

'' the ELEMENT: a UDT with a default constructor, a copy constructor and a destructor
type EL
    v as long
    declare constructor( )
    declare constructor( byref o as EL )
    declare destructor( )
end type
constructor EL( ) : eCtor += 1 : end constructor
constructor EL( byref o as EL ) : eCopy += 1 : v = o.v : end constructor
destructor EL( ) : eDtor += 1 : end destructor

'' a dynamic TWO-dimensional long array
type M2
    a( any, any ) as long
    declare constructor( byval r as long, byval c as long )
end type
constructor M2( byval r as long, byval c as long )
    redim a( 0 to r - 1, 0 to c - 1 )
    for i as long = 0 to r - 1 : for j as long = 0 to c - 1 : a( i, j ) = ( i + 1 ) * 10 + j + 1 : next : next
end constructor

'' a dynamic THREE-dimensional array of EL, a lower bound of 1, and a written destructor
type M3E
    e( any, any, any ) as EL
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor M3E( byval n as long )
    redim e( 0 to 1, 0 to n - 1, 1 to 2 )
    for i as long = 0 to 1 : for j as long = 0 to n - 1 : for k as long = 1 to 2
        e( i, j, k ).v = i * 100 + j * 10 + k
    next : next : next
end constructor
destructor M3E( ) : uDtor += 1 : end destructor

'' a FIXED two-dimensional array of EL with non-zero and negative lower bounds
type F2E
    f( 1 to 2, -1 to 1 ) as EL
    declare constructor( byval n as long )
end type
constructor F2E( byval n as long )
    for i as long = 1 to 2 : for j as long = -1 to 1 : f( i, j ).v = n * ( i * 10 + j ) : next : next
end constructor

'' a two-dimensional array of EL grown on its first dimension with REDIM PRESERVE
type M2P
    e( any, any ) as EL
    declare constructor( byval n as long )
end type
constructor M2P( byval n as long )
    redim e( 0 to 0, 0 to 2 )
    for j as long = 0 to 2 : e( 0, j ).v = j + 1 : next
    redim preserve e( 0 to n - 1, 0 to 2 )
    for i as long = 1 to n - 1 : for j as long = 0 to 2 : e( i, j ).v = ( i + 1 ) * 10 + j : next : next
end constructor

function nextArg( ) as long
    nArg += 1 : return nArg + 1
end function

function buildM2( byval r as long, byval c as long ) as M2
    return M2( r, c )
end function
function buildM3E( byval n as long ) as M3E
    return M3E( n )
end function
function buildM3ELit( byval n as long ) as M3E
    return type<M3E>( n )
end function
function buildM3EArg( ) as M3E
    return M3E( nextArg( ) )
end function
function buildF2E( byval n as long ) as F2E
    return F2E( n )
end function
function buildM2P( byval n as long ) as M2P
    return M2P( n )
end function

sub counts( )
    print "E ctor="; eCtor; " copy="; eCopy; " dtor="; eDtor; " U dtor="; uDtor; " arg="; nArg
end sub

scope
    dim as M2 a = buildM2( 2, 3 )
    dim as M3E b = buildM3E( 2 )
    dim as M3E c = buildM3ELit( 1 )
    dim as M3E d = buildM3EArg( )
    dim as F2E f = buildF2E( 3 )
    dim as M2P p = buildM2P( 3 )
    print ubound( a.a, 1 ); ubound( a.a, 2 ); a.a( 1, 2 ); " |"; ubound( b.e, 2 ); lbound( b.e, 3 ); b.e( 1, 1, 2 ).v; " |"; ubound( c.e, 2 ); c.e( 1, 0, 1 ).v; " |"; ubound( d.e, 2 ); d.e( 0, 1, 2 ).v
    print lbound( f.f, 2 ); f.f( 2, -1 ).v; f.f( 1, 1 ).v; " |"; ubound( p.e, 1 ); p.e( 0, 2 ).v; p.e( 2, 1 ).v
    counts( )
    redim preserve a.a( 0 to 3, 0 to 2 ) : a.a( 3, 2 ) = 99
    redim preserve b.e( 0 to 2, 0 to 1, 1 to 2 ) : b.e( 2, 1, 2 ).v = 77
    print ubound( a.a, 1 ); a.a( 1, 2 ); a.a( 3, 2 ); " |"; ubound( b.e, 1 ); b.e( 1, 1, 2 ).v; b.e( 2, 1, 2 ).v
    counts( )
    b = buildM3E( 1 )
    p = buildM2P( 2 )
    print ubound( b.e, 2 ); b.e( 1, 0, 2 ).v; " |"; ubound( p.e, 1 ); p.e( 1, 2 ).v
    counts( )
end scope
counts( )
