'' 'RETURN T( ARGS )' INTO A HIDDEN-POINTER RESULT WHOSE TYPE HAS NO WRITTEN COPY CONSTRUCTOR,
'' but needs one synthesised -- a STRING field, or a member with a copy constructor of its
'' own -- constructs the result in place, as sret-return-ctor-inplace does for a written one.
'' fbc-modern's C for each of the four functions below is one constructor call on the hidden
'' pointer, and the argument is evaluated once:
''
''     _ZN2SSC1Ei( tmp$4$1, N$1 );
''     int32 vr$0 = NEXTARG(  );
''     _ZN2SSC1Ei( tmp$8$1, vr$0 );
''     _ZN2OOC1Ei( tmp$10$1, N$1 );
''
'' fbc-modern prints, and tiko prints too:
''
''    ss1 1 | ss2 2 | ss10 10 |  4 4
''    S ctor= 3 dtor= 0 M ctor= 1 copy= 0 dtor= 0 arg= 1
''    ss9  8 ss7
''    S ctor= 5 dtor= 2 M ctor= 2 copy= 0 dtor= 1 arg= 1
''    S ctor= 5 dtor= 5 M ctor= 2 copy= 0 dtor= 2 arg= 1
''
'' A copy through the temporary would show as 'M copy=' above zero, and an argument lowered
'' twice as 'arg= 2'.
dim shared as long sCtor, sDtor, mCtor, mCopy, mDtor, nArg

'' synthesised copy through a STRING field
type SS
    s as string
    n as long
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor SS( byval n as long ) : sCtor += 1 : this.n = n : s = "ss" & n : end constructor
destructor SS( ) : sDtor += 1 : end destructor

'' synthesised copy through a MEMBER with a written copy constructor
type MM
    v as long
    declare constructor( )
    declare constructor( byref o as MM )
    declare destructor( )
end type
constructor MM( ) : mCtor += 1 : end constructor
constructor MM( byref o as MM ) : mCopy += 1 : v = o.v : end constructor
destructor MM( ) : mDtor += 1 : end destructor
type OO
    m as MM
    k as long
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor OO( byval n as long ) : k = n : m.v = n : end constructor
destructor OO( ) : end destructor

function nextArg( ) as long
    nArg += 1 : return nArg * 10
end function

function makeS( byval n as long ) as SS
    return SS( n )
end function
function makeSLit( byval n as long ) as SS
    return type<SS>( n )
end function
function makeSArg( ) as SS
    return SS( nextArg( ) )
end function
function makeO( byval n as long ) as OO
    return OO( n )
end function

scope
    dim as SS a = makeS( 1 )
    dim as SS b = makeSLit( 2 )
    dim as SS d = makeSArg( )
    dim as OO o = makeO( 4 )
    print a.s; a.n; " | "; b.s; b.n; " | "; d.s; d.n; " | "; o.m.v; o.k
    print "S ctor="; sCtor; " dtor="; sDtor; " M ctor="; mCtor; " copy="; mCopy; " dtor="; mDtor; " arg="; nArg
    a = makeS( 7 )
    print makeS( 9 ).s; " "; makeO( 8 ).k; " "; a.s
    print "S ctor="; sCtor; " dtor="; sDtor; " M ctor="; mCtor; " copy="; mCopy; " dtor="; mDtor; " arg="; nArg
end scope
print "S ctor="; sCtor; " dtor="; sDtor; " M ctor="; mCtor; " copy="; mCopy; " dtor="; mDtor; " arg="; nArg
