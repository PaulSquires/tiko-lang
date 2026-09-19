'' A MEMBER'S BODY IS WRITTEN ONCE. Each second definition below is fbc error 4 --
'' measured 2026-09-18 on fbc-modern 1.20 and 1.10.1 -- and tiko-lang gave both bodies to
'' the one declaration, leaving clang to refuse the duplicate symbol. The overload
'' defined once beside it is not a second body.
type BodyT
    x as long
    declare sub m( )
    declare sub ov( byval a as long )
    declare sub ov( byval a as double )
    declare property p( ) as long
    declare constructor( )
    declare destructor( )
    declare operator let( byval a as long )
    declare static sub s( )
end type

sub BodyT.m( )
end sub
sub BodyT.m( )
end sub

sub BodyT.ov( byval a as long )
end sub
sub BodyT.ov( byval a as double )
end sub
sub BodyT.ov( byval a as long )
end sub

property BodyT.p( ) as long
    return 0
end property
property BodyT.p( ) as long
    return 1
end property

constructor BodyT( )
end constructor
constructor BodyT( )
end constructor

destructor BodyT( )
end destructor
destructor BodyT( )
end destructor

operator BodyT.let( byval a as long )
end operator
operator BodyT.let( byval a as long )
end operator

sub BodyT.s( )
end sub
sub BodyT.s( )
end sub

'' Reached through a namespace.
namespace BodyNs
    type T
        x as long
        declare sub m( )
    end type
end namespace
sub BodyNs.T.m( )
end sub
sub BodyNs.T.m( )
end sub
