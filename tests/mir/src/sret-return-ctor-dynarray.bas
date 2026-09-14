'' 'RETURN T( ARGS )' INTO A HIDDEN-POINTER RESULT WHOSE TYPE NEEDS A COPY BODY ONLY FOR A
'' DYNAMIC ARRAY FIELD -- no copy constructor, written or through a member -- constructs the
'' result in place, as sret-return-ctor-inplace and sret-return-ctor-synthcopy do for the
'' other two. fbc-modern's C for each of the four functions below is one constructor call on
'' the hidden pointer, and the argument is evaluated once:
''
''     _ZN2DAC1Ei( tmp$12$1, N$1 );
''     int32 vr$0 = NEXTARG(  );
''     _ZN2DAC1Ei( tmp$16$1, vr$0 );
''     _ZN2DSC1Ei( tmp$18$1, N$1 );
''
'' fbc-modern prints, and tiko prints too:
''
''     2 9 | 1 4 | 3 16 | 2 s6
''    A ctor= 3 dtor= 0 S ctor= 1 arg= 1
''     4 25 | 1 s2 | 4
''    A ctor= 5 dtor= 2 S ctor= 2 arg= 1
''    A ctor= 5 dtor= 5 S ctor= 2 arg= 1
''
'' The bounds and elements are read back after every construction, so an array buffer freed
'' with a temporary, or shared between two objects, shows there; an argument lowered twice
'' shows as 'arg= 2'.
dim shared as long aCtor, aDtor, sCtor, nArg

'' a DYNAMIC ARRAY field and a written destructor, no copy constructor
type DA
    a( any ) as long
    n as long
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor DA( byval n as long )
    aCtor += 1 : this.n = n
    redim a( 0 to n - 1 )
    for i as long = 0 to n - 1 : a( i ) = ( i + 1 ) * n : next
end constructor
destructor DA( ) : aDtor += 1 : end destructor

'' a dynamic array of STRINGS, no destructor written at all
type DS
    a( any ) as string
    declare constructor( byval n as long )
end type
constructor DS( byval n as long )
    sCtor += 1
    redim a( 0 to n - 1 )
    for i as long = 0 to n - 1 : a( i ) = "s" & ( i * n ) : next
end constructor

function nextArg( ) as long
    nArg += 1 : return nArg + 3
end function

function buildA( byval n as long ) as DA
    return DA( n )
end function
function buildALit( byval n as long ) as DA
    return type<DA>( n )
end function
function buildAArg( ) as DA
    return DA( nextArg( ) )
end function
function buildS( byval n as long ) as DS
    return DS( n )
end function

scope
    dim as DA x = buildA( 3 )
    dim as DA y = buildALit( 2 )
    dim as DA z = buildAArg( )
    dim as DS s = buildS( 3 )
    print ubound( x.a ); x.a( 2 ); " |"; ubound( y.a ); y.a( 1 ); " |"; ubound( z.a ); z.a( 3 ); " |"; ubound( s.a ); " "; s.a( 2 )
    print "A ctor="; aCtor; " dtor="; aDtor; " S ctor="; sCtor; " arg="; nArg
    x = buildA( 5 )
    s = buildS( 2 )
    print ubound( x.a ); x.a( 4 ); " |"; ubound( s.a ); " "; s.a( 1 ); " |"; buildA( 4 ).n
    print "A ctor="; aCtor; " dtor="; aDtor; " S ctor="; sCtor; " arg="; nArg
end scope
print "A ctor="; aCtor; " dtor="; aDtor; " S ctor="; sCtor; " arg="; nArg
