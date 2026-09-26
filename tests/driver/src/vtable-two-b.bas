'' Module two of the pair; see vtable-two-a.bas.
#include once "vtable-two.bi"

dim shared as D keep

sub other( byref o as B )
    print o.f( ), (o is D)
end sub

function makeD( ) as B ptr
    return @keep
end function
