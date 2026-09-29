'' 'base( ... )' that no constructor takes (fbc's 7), and an empty 'base( )' over a base
'' with nothing to construct (fbc's 9).
type WithCtor
    as integer a, b, c
    declare constructor( )
end type
constructor WithCtor( )
end constructor
type NoCtor
    as integer a, b, c
end type
type C1 extends WithCtor
    declare constructor( )
end type
constructor C1( )
    base( 1, 2, 3 )                            '' 7
end constructor
type C2 extends NoCtor
    declare constructor( )
end type
constructor C2( )
    base( )                                    '' 9
end constructor
type C3 extends NoCtor
    declare constructor( )
end type
constructor C3( )
    base( 1, 2 )                               '' fine
end constructor
