'' derive-field-noeq.bas -- see ../derive-field-noeq.test
type Opaque_
    as long x
end type
type T
    derive equal
    as Opaque_ o
end type
