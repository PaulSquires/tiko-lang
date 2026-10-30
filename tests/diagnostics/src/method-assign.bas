type T
    x as long
    declare function F( byval u as long ) as long
    declare function G( ) as long
    declare sub S( byval u as long )
    declare static function SF( byval u as long ) as long
    declare static sub SS( byval u as long )
end type
function T.F( byval u as long ) as long
    this.F = 3
    return u
end function
function T.G( ) as long
    return x
end function
sub T.S( byval u as long )
end sub
static function T.SF( byval u as long ) as long
    T.SF = u
end function
static sub T.SS( byval u as long )
end sub
namespace ns
    function NF( byval u as long ) as long
        ns.NF = u
    end function
end namespace
sub Q( byval u as long )
end sub
dim g as T
dim pg as T ptr = @g
g.F = 2
g.S = 1
g.G = 3
pg->F = 2
(g).F = 2
with g
    .F = 2
end with
g.F += 1
T.SF = 3
ns.NF = 2
T.SS = 1
Q = 1
print "end"
