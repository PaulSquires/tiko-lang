dim as integer a(1 to 3)
print a(0)
print a(-1)
a(4) = 1
print a(2)
type T
    as integer f(1 to 3)
end type
dim as T t
print t.f(7)
