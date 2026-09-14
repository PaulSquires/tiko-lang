'' A call through a procedure pointer that returns an aggregate passes the hidden result pointer.
type Big
    as longint a, b, c
end type
type ParseFn as function( byval n as longint ) as Big
function RealParse( byval n as longint ) as Big
    dim as Big r
    r.a = n : r.b = n + 1 : r.c = n + 2
    return r
end function
type Provider
    as long    source
    as ParseFn parse_
end type
dim as Provider p
p.parse_ = @RealParse
dim as Big got = p.parse_( 42 )
print got.a; got.b; got.c
dim as ParseFn fp = @RealParse
dim as Big got2 = fp( 7 )
print got2.a; got2.b; got2.c
