'' A type literal over a type that declares a CONSTRUCTOR is CONSTRUCTED, and a bare
'' 'type( ... )' takes its type from the parameter it is passed to.
type T
    dim as long v
    declare constructor( byval n as long )
end type

constructor T( byval n as long )
    v = n
end constructor

'' ...and a type with NO constructor is still written field by field.
type U
    dim as long a
    dim as long b
end type

function g( byval x as T ) as long
    return x.v
end function

dim as T x = type<T>( 7 )
dim as U y = type<U>( 1, 2 )
dim as long r1 = g( type( 123 ) )
dim as long r2 = g( type<T>( 123 ) )
dim as long r3 = g( T( 123 ) )
print x.v, y.a, y.b, r1, r2, r3
