'' AN ARRAY MUST FIT IN 2147483647 BYTES -- fbc error 50 -- INSIDE A TYPE TOO, and for
'' an element that is a UDT, whose size exists only once the layouts do. Measured, each
'' side of the limit: byte 0 to &h7FFFFFFE fits and 0 to &h7FFFFFFF does not; a 32-byte
'' UDT fits at 0 to 67108862 (2147483616 bytes) and not at 0 to 67108863 (2147483648).
const LIMIT = &h7FFFFFFF
type UDT
    as integer a, b, c, d
end type
type Container1
    as byte fits(0 to LIMIT - 1)
end type
type Container2
    as byte test(0 to LIMIT)
end type
type Container3
    test(0 to LIMIT \ 4) as integer
end type
type Container4
    as zstring * 16 test(0 to LIMIT \ 16)
end type
type Container5
    as UDT fits(0 to 67108862)
end type
type Container6
    as UDT test(0 to 67108863)
end type
dim shared as UDT fits(0 to 67108862)
dim shared as UDT big(0 to 67108863)
dim shared as UDT big2(0 to 8191, 0 to 8191)
