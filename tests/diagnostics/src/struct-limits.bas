'' THREE THINGS A TYPE CANNOT DO, each measured against fbc with its accepted twin beside
'' it: a dynamic array anywhere inside a union (error 162), a byref binding to a bitfield,
'' which has no address (error 24), and a type whose total size does not fit (error 51).
''
'' THE LAST ONE IS REPORTED ON THE TYPE, not on the field that tipped it over: fbc blames
'' the member that overflowed and this compiler the declaration, because the overflow is
'' only visible once the whole layout is summed. The refusal is the same.
const LIMIT = &h7FFFFFFF
'' Refused: a dynamic array in a union, however deeply the anonymous aggregates nest.
union DirectUnion
    dyn(any) as integer
    b as integer
end union
type UnionMember
    union
        dyn(any) as integer
        b as integer
    end union
end type
type NestedInUnion
    union
        type
            dyn(any) as integer
        end type
    end union
end type
'' Accepted: a FIXED array in a union, and a dynamic array in a plain type.
union FixedInUnion
    a(0 to 3) as integer
    b as integer
end union
type DynInPlainType
    dyn(any) as integer
end type
'' Refused: a bitfield has no address.
type WithBitfield
    n : 1 as integer
    m as integer
end type
dim wb as WithBitfield
dim byref toBitfield as integer = wb.n
'' Accepted: a plain field of the same type binds fine.
dim byref toPlain as integer = wb.m
'' Refused: the type does not fit. Accepted: exactly at the limit.
type AtTheLimit
    as byte filler(0 to LIMIT - 1)
end type
type OverTheLimit
    as byte filler(0 to LIMIT - 1)
    as byte oneMore
end type
