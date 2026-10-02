type Sorter( of T )
    dummy as long
    declare sub Run( byval a as T, byval b as T )
end type
sub Sorter( of T ).Run( byval a as T, byval b as T )
    var f = function( byval x as T, byval y as T ) as boolean
        return x < y
    end function
    print f( a, b )
end sub
sub Plain( byval a as long, byval b as long )
    var f = function( byval x as long, byval y as long ) as boolean
        return x < y
    end function
    print f( a, b )
end sub
dim as Sorter( of long ) s
s.Run( 1, 2 )
Plain( 3, 4 )
type Unused( of T )
    dummy as long
    declare sub Go( byval a as T )
end type
sub Unused( of T ).Go( byval a as T )
    var g = function( byval x as T ) as T
        return x
    end function
    print g( a )
end sub
print "end"
