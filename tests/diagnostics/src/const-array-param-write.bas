'' Writes through a 'const' array parameter (by-example BUG-arrays-2).
sub Assign_( v( ) as const long )
    v( lbound( v ) ) = 0
end sub
sub PlusEq_( v( ) as const long )
    v( lbound( v ) ) += 1
end sub
sub Redim_( v( ) as const long )
    redim v( 5 )
end sub
function Variadic_( values( ) as const long ... ) as long
    values( lbound( values ) ) = 0
    return 0
end function

'' Accepted: a read, a variadic read, and a non-const array parameter.
function Reads_( v( ) as const long ) as long
    return v( lbound( v ) )
end function
function Sum_( values( ) as const long ... ) as long
    dim as long s = 0
    for i as long = lbound( values ) to ubound( values )
        s += values( i )
    next
    return s
end function
sub Writable_( v( ) as long )
    v( lbound( v ) ) = 0
end sub
