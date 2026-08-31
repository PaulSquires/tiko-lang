'' 'virtual' NEEDS A VTABLE, and only a type that extends OBJECT has one -- fbc error 221,
'' "Method declared VIRTUAL, but UDT does not extend OBJECT". 'abstract' implies virtual
'' and is the same refusal.
''
'' AND AN ABSTRACT METHOD HAS NO BODY -- fbc error 224, "Implemented body for an ABSTRACT
'' method". The declaration says there is nothing to call.
type Based extends object
    dummy as integer
    declare abstract sub pure_( )
    declare virtual sub ok_( )
end type

sub Based.ok_( )
end sub

'' -- refused ------------------------------------------------------------------
type NoObject
    dummy as integer
    declare virtual sub f( )
end type

type NoObject2
    dummy as integer
    declare abstract sub g( )
end type

abstract sub Based.pure_( )
end sub

'' -- accepted -----------------------------------------------------------------
type Derived extends Based
    declare sub pure_( )
end type

sub Derived.pure_( )
end sub

type Plain
    dummy as integer
    declare sub h( )
end type

sub Plain.h( )
end sub
