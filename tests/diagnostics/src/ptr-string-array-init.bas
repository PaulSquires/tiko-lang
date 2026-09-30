'' A string literal for a pointer in an array's { } initializer -- fbc's 24 for a pointer
'' element, 14 at the next element for a UDT field.
type UDT
    s1 as zstring ptr
    s2 as zstring ptr
end type
dim shared as zstring ptr z1(0 to 1) = { @"a", "b" }                '' 24
dim shared as UDT u1(0 to 1) = { ( "a" ), ( @"b" ) }                '' 14
dim shared as zstring ptr z2(0 to 1) = { @"a", @"b" }               '' fine
dim u2 as UDT = ( "a" )                                             '' fine: a scalar
