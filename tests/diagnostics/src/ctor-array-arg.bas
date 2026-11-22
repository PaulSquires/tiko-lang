'' A whole array, 'T( arr( ) )', where no constructor takes an array.
type T
    as long a
    declare constructor ( byval x as long )
    declare constructor ( byval x as double, byval y as long )
end type
constructor T ( byval x as long )
    a = x
end constructor
constructor T ( byval x as double, byval y as long )
    a = x
end constructor
dim as string sarr( 3 )
dim as long larr( 3 )
dim as T x = T( sarr( ) )
dim as T y = T( larr( ) )
x = T( sarr( ) )
y = T( larr( ) )
x = T( 4 )
print x.a
