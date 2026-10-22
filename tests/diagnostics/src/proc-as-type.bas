namespace ns
    type R
        a as long
    end type
    function F( ) as long
        return 1
    end function
end namespace
function G( ) as long
    return 2
end function
dim a as ns.F
dim b as G
dim c as ns.R
dim d as long
print sizeof( c ), sizeof( d )
