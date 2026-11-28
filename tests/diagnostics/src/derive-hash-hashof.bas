'' derive-hash-hashof.bas -- see ../derive-hash-hashof.test
type T
    derive equal, hash
    as long a
    declare function HashOf( ) as ulongint
end type
function T.HashOf( ) as ulongint
    return a
end function
