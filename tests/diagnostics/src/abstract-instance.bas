'' AN ABSTRACT TYPE CANNOT BE INSTANTIATED -- fbc error 274, "Abstract method(s) not
'' implemented". A type is ABSTRACT when it declares an abstract method and nothing has
'' implemented it, and that is exactly what the vtable already knows: an abstract slot is
'' NULL and an override fills it. So this check asks no question of its own.
''
'' That is what makes the three shapes fall out together, which a "does this type declare
'' 'abstract'" test gets wrong: DIRECT, INHERITED (the derived type declares none of its
'' own) and PARTIAL (it implements one of two).
''
'' A POINTER OR REFERENCE TO ONE IS THE WHOLE POINT. 'dim p as A ptr', 'byref x as A' and
'' 'function f( ) byref as A' are all accepted by fbc -- a check that unwrapped them would
'' refuse the only way an abstract type is ever used. And for a UDT parameter BYREF IS THE
'' FreeBASIC DEFAULT, so only one that writes 'byval' counts.
type A extends object
    declare abstract sub f1( )
    declare abstract sub f2( )
end type

type Inherits_ extends A
end type

type Partial_ extends A
    declare sub f1( )
end type

sub Partial_.f1( )
end sub

type Complete extends A
    declare sub f1( )
    declare sub f2( )
end type

sub Complete.f1( )
end sub

sub Complete.f2( )
end sub

'' -- refused ------------------------------------------------------------------
dim shared as A         direct_
dim shared as Inherits_ inherited_
dim shared as Partial_  partly_

type HoldsOne
    x as A
end type

declare function returnsOne( ) as A
declare sub takesByval( byval x as A )

'' -- accepted -----------------------------------------------------------------
dim shared as A ptr     p
dim shared as Complete  done_

declare sub takesByref( byref x as A )
declare sub takesDefault( x as A )
declare function returnsRef( ) byref as A
