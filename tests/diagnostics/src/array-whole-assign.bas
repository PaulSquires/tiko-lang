type H
    arr(0 to 3) as long
end type
function MakeArr( ) as long( )
    return { 1, 2, 3 }
end function
dim as long a(0 to 1), b(0 to 7), c(0 to 1)
dim as long d()
dim as string s1(0 to 2), s2(0 to 2)
dim as zstring * 8 z1, z2
dim as H h1, h2
a = b
a = c
d = b
a() = b()
s1 = s2
h1.arr = h2.arr
a += b
a = 5
swap a, c
d = MakeArr( )
h1 = h2
a(0) = b(1)
z1 = z2
swap a(0), c(1)
