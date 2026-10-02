'' A string to a number, through a type's ONLY constructor -- see ctor-arg-mismatch.test.
type T
    declare constructor ( byval a as long, byref w as long )
    v as long
end type
constructor T ( byval a as long, byref w as long )
end constructor
type V
    declare constructor ( byval w as double )
    v as long
end type
constructor V ( byval w as double )
end constructor
sub g( byref t1 as T )
end sub
dim s as string
dim n as integer
dim x as T = T( 1, "hi" )
dim y as T = T( 1, s )
g( T( 2, "x" ) )
dim q as T ptr = new T( 3, "y" )
var z = T( 4, "w" )
x = T( 5, "v" )
dim v1 as V = V( "1.5" )
dim w as T = T( 1, n )
