sub s overload ( )
end sub
sub s overload ( byval a as byte )
end sub
function g overload ( ) as long
    return 1
end function
function g overload ( byval a as long ) as long
    return a
end function
dim p1 as sub( ) = procptr( s, sub( ) )
dim p2 as sub( byval as byte ) = procptr( s, sub( byval as byte ) )
dim g1 as function( ) as long = procptr( g, function( ) as long )
dim g2 as function( byval as long ) as long = procptr( g, function( byval as long ) as long )
p1( )
p2( 0 )
print g1( ), g2( 2 )
