sub f overload( byval x as long ) : print "long"; x : end sub
sub f overload( byval x as double ) : print "double"; x : end sub
sub f overload( byref x as long, byval y as long ) : print "byref2"; x; y : end sub
sub take( byval p as sub( byval as double ) )
    p( 2.5 )
end sub
dim as sub( byval as double ) p1 = @f
p1( 1.5 )
dim as sub( byval as long ) p2
p2 = @f
p2( 7 )
take( @f )
dim as sub( byref as long, byval as long ) p3 = procptr( f )
dim as long z = 3
p3( z, 4 )
