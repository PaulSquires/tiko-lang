dim b as ubyte = 123
dim pb as ubyte ptr = @b
dim as long i
dim as double d
print peek( @b )
print peek( pb )
print peek( ubyte, pb )
print peek( typeof( b ), pb )
print peek( integer, @i )
print peek( double, @d )
dim as ubyte ptr array(0 to 1)
array(0) = pb
print peek( array(0) )
type array as ubyte
print peek( array(0) )
print peek( array, array(0) )
