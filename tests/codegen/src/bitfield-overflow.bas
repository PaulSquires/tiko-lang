type T1
    a : 3 as ubyte
    b : 4 as ubyte
    d : 10 as ushort
    e : 20 as long
    f : 30 as long
end type
type T2
    union
        u : 3 as long
        v as byte
    end union
    w as byte
end type
type T3
    a : 7 as ubyte
    b : 2 as ubyte
    c : 1 as boolean
    d : 15 as short
end type
dim x as T1, y as T2, z as T3
x.a = 7 : x.b = 15 : x.d = 1023 : x.e = 1048575 : x.f = 12345678
print sizeof(T1), x.a, x.b, x.d, x.e, x.f
print sizeof(T2), offsetof(T2, w)
z.a = 127 : z.b = 3 : z.c = true : z.d = -1
print sizeof(T3), z.a, z.b, z.c, z.d, (z.c = true), cint(z.c)
dim k as integer = z.c
print k
if z.c = -1 then print "neg1"
z.c = false
print z.c, cint(z.c)
