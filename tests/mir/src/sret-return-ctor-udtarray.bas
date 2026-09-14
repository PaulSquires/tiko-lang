'' 'RETURN T( ARGS )' IN PLACE, FOR TYPES WHOSE ARRAYS HOLD UDTS WITH DESTRUCTORS OR ARE GROWN
'' WITH REDIM PRESERVE. EL counts its default constructor, copy constructor and destructor;
'' DP grows a long array with 'redim preserve' in its constructor, DU holds a dynamic array of
'' EL beside a written destructor, DUP grows one with 'redim preserve', and FX holds a fixed one.
'' fbc-modern's C for each of the six functions below is one constructor call on the hidden
'' pointer, and the argument is evaluated once:
''
''     _ZN2DPC1Ei( tmp$29$1, N$1 );
''     int32 vr$0 = NEXTARG(  );
''     _ZN2DUC1Ei( tmp$35$1, vr$0 );
''     _ZN3DUPC1Ei( tmp$37$1, N$1 );
''     _ZN2FXC1Ei( tmp$39$1, N$1 );
''
'' fbc-modern prints, and tiko prints too:
''
''     2 3 9 | 1 4 | 2 3 9 | 12 | 3 16 | 0 1
''    E ctor= 13 copy= 0 dtor= 0 U dtor= 0 arg= 1
''     4 9 99 | 3 4 77
''    E ctor= 15 copy= 0 dtor= 0 U dtor= 0 arg= 1
''     2 9 | 1 4
''    E ctor= 25 copy= 0 dtor= 12 U dtor= 1 arg= 1
''    E ctor= 25 copy= 0 dtor= 25 U dtor= 4 arg= 1
''
'' 'copy= 0' throughout: neither a return nor a 'redim preserve' copies an element, and the
'' caller's preserve constructs only its two new ones. That preserve, run on a RETURNED
'' object's array, and the two assignments over the returned objects would show a descriptor
'' shared with a temporary or freed with one.
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

'' a long array grown with REDIM PRESERVE inside the constructor
type DP
    a( any ) as long
    declare constructor( byval n as long )
end type
constructor DP( byval n as long )
    redim a( 0 to 0 ) : a( 0 ) = n
    redim preserve a( 0 to n - 1 )
    for i as long = 1 to n - 1 : a( i ) = ( i + 1 ) * n : next
end constructor

'' a dynamic array of EL, and a written destructor
type DU
    e( any ) as EL
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor DU( byval n as long )
    redim e( 0 to n - 1 )
    for i as long = 0 to n - 1 : e( i ).v = ( i + 1 ) * n : next
end constructor
destructor DU( ) : uDtor += 1 : end destructor

'' a dynamic array of EL grown with REDIM PRESERVE, no destructor written
type DUP
    e( any ) as EL
    declare constructor( byval n as long )
end type
constructor DUP( byval n as long )
    redim e( 0 to 0 ) : e( 0 ).v = n
    redim preserve e( 0 to n - 1 )
    for i as long = 1 to n - 1 : e( i ).v = ( i + 1 ) * n : next
end constructor

'' a FIXED array of EL
type FX
    f( 0 to 2 ) as EL
    declare constructor( byval n as long )
end type
constructor FX( byval n as long )
    for i as long = 0 to 2 : f( i ).v = ( i + 1 ) * n : next
end constructor

function nextArg( ) as long
    nArg += 1 : return nArg + 3
end function

function buildP( byval n as long ) as DP
    return DP( n )
end function
function buildU( byval n as long ) as DU
    return DU( n )
end function
function buildULit( byval n as long ) as DU
    return type<DU>( n )
end function
function buildUArg( ) as DU
    return DU( nextArg( ) )
end function
function buildUP( byval n as long ) as DUP
    return DUP( n )
end function
function buildF( byval n as long ) as FX
    return FX( n )
end function

sub counts( )
    print "E ctor="; eCtor; " copy="; eCopy; " dtor="; eDtor; " U dtor="; uDtor; " arg="; nArg
end sub

scope
    dim as DP p = buildP( 3 )
    dim as DU u = buildU( 2 )
    dim as DUP q = buildUP( 3 )
    dim as FX f = buildF( 4 )
    dim as DU w = buildUArg( )
    dim as DU l = buildULit( 1 )
    print ubound( p.a ); p.a( 0 ); p.a( 2 ); " |"; ubound( u.e ); u.e( 1 ).v; " |"; ubound( q.e ); q.e( 0 ).v; q.e( 2 ).v; " |"; f.f( 2 ).v; " |"; ubound( w.e ); w.e( 3 ).v; " |"; ubound( l.e ); l.e( 0 ).v
    counts( )
    redim preserve p.a( 0 to 4 ) : p.a( 4 ) = 99
    redim preserve u.e( 0 to 3 ) : u.e( 3 ).v = 77
    print ubound( p.a ); p.a( 2 ); p.a( 4 ); " |"; ubound( u.e ); u.e( 1 ).v; u.e( 3 ).v
    counts( )
    u = buildU( 3 )
    q = buildUP( 2 )
    print ubound( u.e ); u.e( 2 ).v; " |"; ubound( q.e ); q.e( 1 ).v
    counts( )
end scope
counts( )
