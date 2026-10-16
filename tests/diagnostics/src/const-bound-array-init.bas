'' A NAMED CONSTANT AS AN ARRAY BOUND makes a FIXED array, which takes an initialiser:
'' 'const N', 'const as long', an enum constant, both bounds named, and a local const.
const N = 3
const as long M = 2
enum Bounds
    K = 2
end enum
const L = 1

dim as long a(N) = {1, 2, 3, 4}
dim as long b(M) = {5, 6, 7}
dim as long c(K) = {7, 8, 9}
dim as long d(L to N) = {1, 2, 3}

sub s( )
    const P = 1
    dim as long q(P) = {10, 11}
    print q(1); ubound(q)
end sub

print a(3); ubound(a); sizeof(a)
print b(2); ubound(b)
print c(2); ubound(c)
print d(3); lbound(d); ubound(d)
s( )
