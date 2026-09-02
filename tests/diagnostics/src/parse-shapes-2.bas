'' THREE THINGS THE PARSER REFUSES, each measured against fbc: CONST on a structor
'' (errors 314 and 315), a byref procedure type without a result ('sub( ) byref' is
'' error 17, 'function( ) byref' without 'as' is 68), and a bare 'base' (error 120).
type UDT
    i as integer
    declare const constructor( )
    declare const destructor( )
    declare const sub okConst( )
end type
const constructor UDT( )
end constructor
const destructor UDT( )
end destructor
const sub UDT.okConst( )
end sub
dim p1 as function( ) byref as integer
dim p2 as function( ) byref
dim p3 as sub( ) byref
dim p4 as sub( )
type A extends object
    i1 as integer
end type
type B extends A
    declare sub f( )
    declare sub g( )
end type
sub B.f( )
    print base.i1
    base.i1 = 1
end sub
sub B.g( )
    print base
end sub
