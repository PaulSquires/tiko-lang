'' derive-field-nohash.bas -- see ../derive-field-nohash.test
type Opaque_
    as long x
end type
operator = ( byref l as Opaque_, byref r as Opaque_ ) as boolean
    return l.x = r.x
end operator
type T
    derive equal, hash
    as Opaque_ o
end type
