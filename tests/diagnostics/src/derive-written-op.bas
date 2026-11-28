'' derive-written-op.bas -- see ../derive-written-op.test
type T
    derive equal
    as long a
end type
operator = ( byref l as T, byref r as T ) as boolean
    return l.a = r.a
end operator
