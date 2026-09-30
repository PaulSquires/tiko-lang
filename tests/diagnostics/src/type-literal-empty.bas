'' A type literal that builds nothing: empty over a type with no constructor (fbc's 9), or
'' with values over one that extends OBJECT and declares none (fbc's 99).
type Plain
    i as integer
end type
type Obj extends object
    i as integer
end type
type WithCtor
    i as integer
    declare constructor( )
end type
constructor WithCtor( )
end constructor
print type<Plain>( ).i                         '' 9
dim o as Obj = type<Obj>( 1 )                  '' 99
print type<WithCtor>( ).i                      '' fine
dim q as Plain = type<Plain>( 1 )              '' fine
