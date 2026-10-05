type U
    as long v
    declare constructor( byval x as long )
    declare constructor( byval x as double )
    declare operator [] ( byval i as long ) as long
    declare operator [] ( byref s as string ) as long
end type
constructor U( byval x as long ) : v = 1 : end constructor
constructor U( byval x as double ) : v = 2 : end constructor
operator U.[] ( byval i as long ) as long : return i : end operator
operator U.[] ( byref s as string ) as long : return len( s ) : end operator
operator len( byref w as U ) as long : return 9 : end operator
sub f overload( byval x as long ) : end sub
sub f overload( byval x as double ) : end sub
dim as U a = U( 2.5 )
print a[ "abc" ], len( a )
dim as sub( byval as double ) p = @f
