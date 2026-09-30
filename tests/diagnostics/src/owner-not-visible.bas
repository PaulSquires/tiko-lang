'' A member defined through an owner not visible from here -- fbc's error 160.
namespace ns
    type UDT
        dummy as integer
        declare property foo( ) as integer
        declare property bar( ) as integer
    end type
end namespace
property UDT.foo( ) as integer                      '' 160
    return 1
end property
property ns.UDT.bar( ) as integer                   '' fine
    return 2
end property
