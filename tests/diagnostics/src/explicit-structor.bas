'' 'x.constructor( )' NAMES A STRUCTOR EXPLICITLY, which is legal only when the type
'' DECLARED one -- the implicit structor is not a member anything can name. fbc error 18.
'' MEASURED both ways round and through a pointer: with a declared constructor the call
'' compiles, without one it does not, and '->' behaves exactly as '.' does.
type Has
    i as integer
    declare constructor( )
    declare destructor( )
end type
constructor Has( )
end constructor
destructor Has( )
end destructor

type Bare
    i as integer
end type

dim h as Has
h.constructor( )
h.destructor( )

dim b as Bare
dim pb as Bare ptr = @b
b.constructor( )
pb->destructor( )
