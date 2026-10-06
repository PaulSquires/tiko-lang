'' PALETTE [GET] USING picks its 64-bit entry by the POINTEE's SIZE: 8 is the 64 form, 4 the
'' 32 form, any other size INTEGER's width -- fbc's cGfxPalette. Measured on win64 with
'' fbc-modern 1.20 -r -gen gcc: double, byte and 'any ptr' take the 64 form, single the 32.
'' A UDT is its pointer 'operator cast', and the cast's pointee decides.
type W64
    p as longint ptr
    declare operator cast( ) as longint ptr
end type
operator W64.cast( ) as longint ptr
    return p
end operator
dim as double d(255)
dim as any ptr ap = @d(0)
dim as byte b(1023)
dim as single s(255)
dim as W64 w
palette get using d
palette get using ap
palette get using b
palette get using s
palette using d
palette get using w
