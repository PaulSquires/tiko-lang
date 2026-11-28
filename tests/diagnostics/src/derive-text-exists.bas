'' derive-text-exists.bas -- see ../derive-text-exists.test
type T
    derive text
    as long a
    declare function ToText( ) as ustring
end type
function T.ToText( ) as ustring
    return "t"
end function
