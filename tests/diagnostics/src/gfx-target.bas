'' A GRAPHICS STATEMENT'S IMAGE TARGET IS A POINTER. MEASURED: an 'any ptr' or 'ubyte ptr'
'' target is accepted; an integer or a string is fbc error 28; a UDT is accepted only when
'' it declares 'operator cast( ) as any ptr', and is error 99 otherwise. PSET, PUT and
'' CIRCLE measure the same as LINE.
type Img
    i as integer
    declare operator cast( ) as any ptr
end type
operator Img.cast( ) as any ptr
    operator = 0
end operator
type Plain
    i as integer
end type

dim pa as any ptr, pb as ubyte ptr
dim im as Img, pl as Plain
dim n as integer, s as string

line pa, (0,0)-(1,1), 1
line pb, (0,0)-(1,1), 1
line im, (0,0)-(1,1), 1
pset pa, (0,0), 1

line n, (0,0)-(1,1), 1
line s, (0,0)-(1,1), 1
line pl, (0,0)-(1,1), 1
pset n, (0,0), 1
circle n, (0,0), 5
