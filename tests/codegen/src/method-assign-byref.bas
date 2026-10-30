type T
    x as long
    declare function R( ) byref as long
    declare function Ro( byval u as long = 0 ) byref as long
    declare property P( byval v as long )
    declare static function SF( byval u as long ) as long
end type
function T.R( ) byref as long
    return x
end function
function T.Ro( byval u as long = 0 ) byref as long
    return x
end function
property T.P( byval v as long )
    x = v
end property
static function T.SF( byval u as long ) as long
    T.SF = u * 2
end function
namespace ns
    function NF( byval u as long ) as long
        ns.NF = u + 1
    end function
end namespace
dim g as T
dim pg as T ptr = @g
g.R = 3
print g.x
g.R += 2
print g.x
with g
    .R = 7
end with
print g.x
pg->R = 8
print g.x
g.Ro = 9
print g.x
print (@g.R = @g.x)
g.P = 11
print g.x
print T.SF( 5 ), ns.NF( 5 )
