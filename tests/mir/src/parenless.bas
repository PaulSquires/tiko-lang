type T
    as long v
    declare sub M( byval x as long )
end type
sub T.M( byval x as long ) : end sub
declare sub Z( )
declare sub W( byval a as long, byval b as long )
sub Z( ) : end sub
sub W( byval a as long, byval b as long ) : end sub
dim shared as T obj
Z
W 1, 2
Z( )
W( 1, 2 )
obj.M 7
