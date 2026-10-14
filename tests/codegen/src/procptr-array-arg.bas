'' An array passed through a procedure pointer whose parameter is an array descriptor.
function Total( xs() as const long ) as long
    dim as long t
    for i as integer = lbound( xs ) to ubound( xs ) : t += xs( i ) : next
    return t
end function
dim as long arr( 0 to 2 ) = { 4, 5, 6 }
dim as long dyn( )
redim dyn( 1 to 2 )
dyn( 1 ) = 10 : dyn( 2 ) = 20
dim as function( xs() as const long ) as long fp = @Total
print "P:"; fp( arr( ) ); fp( dyn( ) )
