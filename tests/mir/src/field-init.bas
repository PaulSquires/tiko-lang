'' A FIELD DECLARED WITH A VALUE. fbc runs these inside the constructor -- implicit or
'' written -- so every way of making the object gets them: 'dim', 'dim shared', a field
'' of another type, an element of an array, and 'new'.
''
'' Measured against fbc, which prints
''
''     123  1.5  18  hi  42  5
''
'' where tiko-lang printed whatever the stack held: the parser recorded the '= value'
'' and nothing downstream ever read it back.
const K = 9

dim shared as integer g = 5

function f( ) as integer
    return 42
end function

type UDT
    a as integer = 123
    b as double = 1.5
    c as integer = K * 2
    d as string = "hi"
    e as integer = f( )
    h as integer = g
    z as zstring * 8 = "abc"
end type

'' THE TYPE-FIRST SPELLING TOO -- 'as integer n = 7' and 'n as integer = 7' are the same
'' declaration to fbc, and only one of the two parser branches read the '= value'.
type Other
    as integer n = 7
end type

dim as UDT v
dim shared as UDT sv
dim as Other o
print v.a, v.b, v.c, v.d, v.e, v.h, v.z
print sv.a, o.n

'' A BRACE LIST OVER A FIXED ARRAY FIELD, which is the element walk a local array
'' declaration already does -- the destination was the only difference, a frame slot
'' where a field has an address. structs/field-init.bas in the corpus is half arrays.
type Arrs
    f1(0 to 2) as ubyte = { &h11, &h12, &h13 }
    f5(0 to 1) as string = { "First", "Second" }
    zz(0 to 1) as zstring * 8 = { "aa", "bb" }
end type

dim as Arrs av
print av.f1(2), av.f5(1), av.zz(0)
