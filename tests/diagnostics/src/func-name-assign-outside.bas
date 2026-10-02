dim shared as long slots(0 to 3)
function NoArg( ) byref as long
    return slots(0)
end function
function Plain( ) as long
    return 1
end function
function Other( ) as long
    NoArg = 5
    return 2
end function
NoArg = 42
Plain = 3
function Own( ) as long
    Own = 7
end function
function Ov overload( ) as long
    Ov = 1
end function
function Ov overload( byval i as long ) as long
    Ov = i
end function
type T
    v as long
    declare function Get( ) as long
end type
function T.Get( ) as long
    Get = v
end function
print "end"
