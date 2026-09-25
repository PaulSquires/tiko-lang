'' Arithmetic or logic on a UDT that no operator takes -- fbc's error 20 on lines 19 to 22
'' (fbc-modern 1.20), including a generic operator whose operands disagree on T. Lines 24
'' and 25 are accepted: the operator fits, and a cast makes the other one numeric.
type A
    v as long
end type
type N
    v as long
    declare operator cast( ) as long
end type
operator N.cast( ) as long : return v : end operator
type Box( of T )
    as T v
end type
operator + ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as Box( of T )
    return x
end operator
dim as A a1, a2 : dim as N n1 : dim as long k : dim as Box( of long ) bl : dim as Box( of double ) bd
a1 = a1 + a2
k = a1 * 2
k = a1 and a2
bl = bl + bd

bl = bl + bl
k = n1 * 2
