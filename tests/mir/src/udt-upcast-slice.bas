'' The upcast slice: a type literal over a DERIVED type initialising one of its bases.
'' fbc builds one temporary of the source type, copies exactly sizeof( destination )
'' bytes out of it, and destructs the temporary -- and does NOT add a destructor when
'' the source is a variable rather than a literal.
type t1 : dim as integer i : declare destructor() : end type
type t2 extends t1 : dim as integer j : declare destructor() : end type

destructor t1() : end destructor
destructor t2() : end destructor

sub FromLiteral()
    dim as t1 u1 = type<t1>( type<t2>( 1, 2 ) )
    print u1.i
end sub

sub FromVariable()
    dim as t2 v
    dim as t1 u2 = type<t1>( v )
    print u2.i
end sub

FromLiteral()
FromVariable()
