dim shared as long slots(0 to 3)
function SlotAt( byval i as long ) byref as long
    return slots(i)
end function
function Two( byval i as long, byval j as long ) byref as long
    return slots(i + j)
end function
function Plain( byval i as long ) as long
    return slots(i)
end function
function NoArg( ) byref as long
    return slots(0)
end function
function Ov overload( ) byref as long
    return slots(3)
end function
function Ov overload( byval i as long ) as long
    return i
end function
type T
    v(0 to 3) as long
    declare function At( byval i as long ) byref as long
end type
function T.At( byval i as long ) byref as long
    return v(i)
end function
dim as T a
SlotAt( 0 ) = 42
SlotAt 1 = 42
a.At( 2 ) = 88
Two( 0, 1 ) = 42
Plain( 0 ) = 42
SlotAt( 0 = 42 )
( SlotAt( 2 ) ) = 42
NoArg( ) = 7
SlotAt( 2 ) => 5
Ov( 1 ) = 9
print slots(0); slots(1); slots(2); a.v(2); slots(3)
