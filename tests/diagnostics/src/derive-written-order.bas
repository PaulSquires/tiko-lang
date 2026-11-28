'' derive-written-order.bas -- see ../derive-written-order.test
type T
    derive equal, order
    as long a
end type
operator < ( byref l as T, byref r as T ) as boolean
    return l.a < r.a
end operator
