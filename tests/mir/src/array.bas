'' Array indexing. The strides and the lbound bias are the whole content of this, so the
'' test asserts the numbers rather than the shape.

sub P( )
    dim as long a(0 to 9)
    dim as long b(1 to 3, 1 to 4)
    dim as long i, v
    a(2) = 7
    v = a(i)
    b(1, 2) = 5
    v = b(i, i)
end sub
