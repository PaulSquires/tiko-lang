type B1
    a : 1 as boolean
    b : 1 as boolean
    c : 4 as long
end type
dim as B1 x1 : x1.a = true : x1.b = false : x1.c = 3
print sizeof(x1.a), x1.a - 2, x1.a + 0, x1.b - 1
print x1.a; x1.b
dim s as string = str(x1.a)
print s
print x1.a < 0
