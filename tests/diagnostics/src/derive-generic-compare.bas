'' derive-generic-compare.bas -- see ../derive-generic-compare.test
type Opaque_
    as long x
end type
type Box( of T )
    derive equal
    as T value
end type
dim as Box( of Opaque_ ) a, b
dim as Box( of Opaque_ ) unused
dim as Box( of long ) c, d
print c = d
print a = b
