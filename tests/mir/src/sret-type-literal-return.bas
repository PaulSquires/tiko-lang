'' 'return type<T>' AND ITS THREE SIBLINGS, out of a function whose result travels
'' through the hidden pointer.
''
'' TWO FACTS, both measured, and they are not the same fact.
''
'' 1. 'type<T>' WITH NOTHING AFTER IT IS THE DEFAULT CONSTRUCTION of T, the same
''    thing as 'type<T>( )'. The parser's note said fbc rejects it -- a correct
''    measurement of an incomplete rule, taken over INTEGER, which has no
''    constructor. Over a type that HAS one it is accepted:
''
''        type A : declare constructor( ) : end type
''        function fa( ) as A : return type<A> : end function     accepted
''        type B : v as integer : end type
''        function fb( ) as B : return type<B> : end function     error 9
''
'' 2. A RETURN CONSTRUCTS STRAIGHT INTO THE HIDDEN POINTER; 'function =' does not:
''
''        return type<T>        _ZN1TC1Ev( tmp$1 ); return tmp$1
''        return type<T>( )     _ZN1TC1Ev( tmp$1 ); return tmp$1
''        return type( )        _ZN1TC1Ev( tmp$1 ); return tmp$1
''        function = type( )    _ZN1TC1Ev( tmp$1 );
''                              _ZN1TC1Ev( &TMP );
''                              memcpy( tmp$1, &TMP, 8 ); _ZN1TD1Ev( &TMP )
''
'' -- so a RETURN runs ONE constructor and NO destructor, which is the whole subject
'' of pp/typeof-no-dtors.bas. Building the temporary anyway ran a destructor fbc does
'' not, and for a type owning a buffer the bitwise copy would have left two owners.
type T
    v as integer
    declare constructor( )
    declare destructor( )
end type
constructor T( ) : end constructor
destructor T( ) : end destructor

function g1( ) as T
    return type<T>
end function

function g2( ) as T
    return type<T>( )
end function

function g3( ) as T
    function = type( )
end function

function g4( ) as T
    return type( )
end function

dim a as T = g1( )
dim b as T = g2( )
dim c as T = g3( )
dim d as T = g4( )
print a.v, b.v, c.v, d.v
