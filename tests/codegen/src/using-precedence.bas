'' T58: a declaration on the scope chain beats every 'using'; fbc-modern 1.20 prints this.
namespace N
    dim shared as long v = 2
    const C = 20
    function F( ) as long
        return 200
    end function
end namespace
namespace N1
    const Y = 1
end namespace
dim shared as long v = 1
const C = 10
function F( ) as long
    return 100
end function
sub InSub( )
    using N
    print "sub:"; v; C; F( )
end sub
InSub( )
scope
    using N
    print "scope:"; v; C; F( )
end scope
namespace M
    const Y = 3
    sub InM( )
        using N1
        print "M:"; Y
    end sub
end namespace
M.InM( )
sub OnlyThere( )
    using N1
    print "only:"; Y
end sub
OnlyThere( )
