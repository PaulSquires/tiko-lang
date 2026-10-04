dim shared a as long = 7
sub f( byval a as long, byval b as long = a )
    print a; b
end sub
f( 2 )
f( 2, 3 )
namespace N
    dim shared k as long = 140
    sub g( byval k as long, byval m as long = k )
        print k; m
    end sub
end namespace
N.g( 3 )
function h( byval x as long = a * 2 ) as long
    return x
end function
print h( )
