'' Assigning through a BY-VALUE 'operator []': fbc's 3 at line 18 (fbc-modern 1.20,
'' 2026-10-25). A byref one is a place (line 19).
type V
    a( 0 to 3 ) as long
    declare operator []( byval i as long ) as long
end type
operator V.[]( byval i as long ) as long
    return a( i )
end operator
type W
    a( 0 to 3 ) as long
    declare operator []( byval i as long ) byref as long
end type
operator W.[]( byval i as long ) byref as long
    return a( i )
end operator
dim as V vv : dim as W ww
vv[ 1 ] = 5
ww[ 1 ] = 5
