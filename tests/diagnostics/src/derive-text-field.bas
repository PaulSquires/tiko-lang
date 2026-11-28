'' derive-text-field.bas -- see ../derive-text-field.test
type Opaque_
    as long x
end type
type T
    derive text
    as Opaque_ o
end type
