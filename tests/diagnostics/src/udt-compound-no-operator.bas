'' A compound assignment or a unary operator over a UDT that nothing takes -- fbc's error 20
'' on lines 30 to 38 (fbc-modern 1.20) -- an 'operator let' alone is not enough for line 38.
'' Lines 40 to 43 are accepted: a member self-operator, a binary one whose result goes back,
'' and a cast.
type A
    v as long
end type
type N
    v as long
    declare operator cast( ) as long
end type
operator N.cast( ) as long : return v : end operator
type P
    v as long
    declare operator += ( byref r as P )
end type
operator P.+= ( byref r as P ) : v += r.v : end operator
type Q
    v as long
end type
operator + ( byref x as Q, byref y as Q ) as Q
    return type<Q>( x.v + y.v )
end operator
type L
    v as long
    declare operator let( byval x as long )
end type
operator L.let( byval x as long ) : v = x : end operator
dim as A a1, a2 : dim as N n1 : dim as P p1, p2 : dim as Q q1, q2 : dim as L l1 : dim as long k
a1 += 1
a1 and= a2
q1 -= q2
k += a1
n1 += 1
k = not a1
a2 = -a1
a2 = +a1
l1 -= 1

p1 += p2
q1 += q2
k += n1
k = -n1
