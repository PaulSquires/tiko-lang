'' EXTENDS is a FIELD at offset 0, not a flag, and 'object' is the one type that is
'' declared nowhere -- fbc predeclares it as a single pointer.
''
'' Sizes and offsets MEASURED from fbc's own output for this exact source:
''   sizeof(object) 8, sizeof(A) 16, sizeof(B) 24    (win32: 4, 8, 12)
''   A.f1 at 8, B.g1 at 16
type A extends object
    f1 as long
end type

type B extends A
    g1 as long
end type

'' No 'object' above it: the negative control. A UDT that does not extend anything has
'' no base field and no vptr.
type Plain
    x as long
    y as long
end type

dim as object xo
dim as A xa
dim as B xb
dim as Plain xp
