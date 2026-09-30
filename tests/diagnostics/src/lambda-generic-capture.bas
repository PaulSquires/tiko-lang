'' A capturing lambda whose parameter is the enclosing generic's type parameter -- fbc's
'' error 59 at the generic.
sub Apply( of T, F )( byval x as T, byref f as F )
    f( x )
end sub
sub Outer( of T )( byval x as T )                  '' 59
    dim as T total = 0
    Apply( x, sub[ byref total ]( byval v as T )
        total = v
    end sub )
end sub
sub Plain( of T )( byval x as T )
    dim as long total = 0
    Apply( 1, sub[ byref total ]( byval v as long )
        total = v
    end sub )
end sub
dim as long n = 5
Outer( n )
Plain( n )
