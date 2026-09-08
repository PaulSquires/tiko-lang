'' 'function = this' OUT OF A BYREF-RETURNING MEMBER: the receiver, not its slot.
type W
    as integer i
    declare function self_( ) byref as W
    declare function selfr( ) byref as W
    declare operator []( byval n as integer ) byref as W
end type

function W.self_( ) byref as W
    function = this
end function

function W.selfr( ) byref as W
    return this
end function

operator W.[]( byval n as integer ) byref as W
    return this
end operator

dim x as W
x.i = 102
print x.self_( ).i, x.selfr( ).i, x[ 0 ].i
