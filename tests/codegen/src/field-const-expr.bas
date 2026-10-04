const PK = 1
type A field = PK
    a as byte
    b as long
end type
type B field = (1)
    a as byte
    b as long
end type
type C field = 1 + 0
    a as byte
    b as long
end type
type D field = PK * 2
    a as byte
    b as long
end type
type E field = 1
    a as byte
    b as long
end type
print sizeof(A), sizeof(B), sizeof(C), sizeof(D), sizeof(E)
print offsetof(A, b), offsetof(D, b)
