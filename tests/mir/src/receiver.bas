type T
    as long v
    declare sub M( byval x as long )
    declare function G( ) as long
end type
sub T.M( byval x as long ) : end sub
function T.G( ) as long : return 0 : end function
dim as T obj
dim as T ptr p = @obj
obj.M( 1 )
p->M( 2 )
print obj.G( )
