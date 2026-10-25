'' 'base( )' after another statement is fbc's 170 (fbc-modern 1.20, 2026-10-25), with or
'' without a default constructor in the base; at the top it is fine. For B2 only the 170
'' is reported, not also "must call base( ... )" (TKO0927). B2's copy constructor is
'' TKO0926, as fbc's 188.
type A extends object
    a as long
    declare constructor( )
    declare constructor( byval v as long )
end type
constructor A( )
end constructor
constructor A( byval v as long )
    a = v
end constructor
type B extends A
    b as long
    declare constructor( )
    declare constructor( byval v as long )
end type
constructor B( )
    b = 7
    base( 1 )
end constructor
constructor B( byval v as long )
    base( v )
    b = v
end constructor

type A2 extends object
    a as long
    declare constructor( byval v as long )
end type
constructor A2( byval v as long )
    a = v
end constructor
type B2 extends A2
    b as long
    declare constructor( )
end type
constructor B2( )
    b = 7
    base( 1 )
end constructor
