type Box( of T )
    as T v
end type
function F( ) as long
    return 0
end function
dim a as F
dim b as Box( of long )
print sizeof( b )
