'' A COMPOUND ASSIGNMENT THROUGH A BINARY OPERATOR: with no 'operator +=', 'q1 += q2' is
'' 'q1 = q1 + q2' (fbc-modern 1.20 prints 3, 8, 108, 115, 82 and 2). tiko dropped the
'' first, second, fourth and fifth, and died in emission on the third and fourth.
type Q
    v as long
end type
operator + ( byref x as Q, byref y as Q ) as Q
    return type<Q>( x.v + y.v )
end operator
operator + ( byref x as Q, byval y as long ) as Q
    return type<Q>( x.v + y )
end operator
operator + ( byval y as long, byref x as Q ) as long
    return x.v + y
end operator
operator & ( byref x as Q, byref y as Q ) as Q
    return type<Q>( x.v * 10 + y.v )
end operator
type N
    v as long
    declare operator cast( ) as long
end type
operator N.cast( ) as long : return v : end operator
dim as Q q1 = type<Q>( 1 ), q2 = type<Q>( 2 ) : dim as N n1 = type<N>( 7 ) : dim as long k = 100
dim as Q qa( 1 ) : dim as integer j = 0
q1 += q2 : print q1.v
q1 += 5 : print q1.v
k += q1 : print k
k += n1 : print k
q1 &= q2 : print q1.v
qa( j ) += q2 : print qa( 0 ).v
