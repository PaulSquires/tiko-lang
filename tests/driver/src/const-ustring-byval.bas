'' See tests/driver/const-ustring-byval.test.
namespace NS
    const K as ustring = "ns"
end namespace
const G as ustring = "hi"
sub P( byval s as ustring )
    print s; len( s )
end sub
function F( byval s as ustring ) as ustring
    return s & "!"
end function
type T
    v as ustring
    declare constructor( byval s as ustring )
    declare sub M( byval s as ustring )
end type
constructor T( byval s as ustring )
    v = s
end constructor
sub T.M( byval s as ustring )
    print v; "|"; s
end sub
P( G )
P( NS.K )
print F( G )
dim as T o = T( G )
o.M( G )
