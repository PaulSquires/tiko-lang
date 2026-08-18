'' UDT layout, on the shapes where a wrong answer is silent.
type Ordered
    as byte  b
    as long  l
    as short s
end type

type Reordered
    as long  l
    as short s
    as byte  b
end type

type Inner1
    as long a
    as byte b
end type

type Nested
    as byte   x
    as Inner1 i
    as byte   y
end type

type WithUnion
    as byte b
    union
        as long   l
        as double d
    end union
    as byte c
end type
