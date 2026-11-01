' A brace list of objects into a POINTER array stores each one's 'operator cast'.
type TT
    p as integer ptr
    declare operator cast () as integer ptr
end type
operator TT.cast () as integer ptr
    return p
end operator

dim shared as integer v1 = 7, v2 = 9
dim shared as TT x1, x2
x1.p = @v1 : x2.p = @v2

dim a(1) as integer ptr = { x1, x2 }
print *a(0); *a(1)

sub f ()
    dim b(2) as integer ptr = { x2, x1, x2 }
    print *b(0); *b(1); *b(2)
end sub
f()
