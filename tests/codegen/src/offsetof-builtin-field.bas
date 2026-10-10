'' A FIELD NAMED LIKE A BUILTIN, as offsetof's second argument: tiko-rt's string
'' descriptors have a 'len' and a 'size'. fbc accepts it; tiko reported TKO0872, "'len'
'' needs an argument list". Measured with fbc: the offsets are 8 and 16.
type Desc
    as any ptr data
    as integer len
    as integer size
end type
#assert offsetof( Desc, len ) = 8
#assert offsetof( Desc, size ) = 16
print offsetof( Desc, len ); offsetof( Desc, size )
