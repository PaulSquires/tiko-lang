'' A MEMBER ON A USER OPERATOR'S RESULT. The result is a temporary the caller made, so
'' it has an address -- and LowerAddr had no case for a BINARY at all, so '( a + b ).f'
'' declined while 'c = a + b : c.f' beside it lowered.
type Big
    as longint a, b, c, d
    declare constructor( )
    declare destructor( )
end type

constructor Big( )
end constructor

destructor Big( )
end destructor

'' Non-trivial: the result travels through a hidden pointer and the temporary's address
'' is what the call hands back.
operator + ( byref x as Big, byref y as Big ) as Big
    dim as Big r
    r.a = x.a + y.a
    return r
end operator

'' Trivial: the result comes back BY VALUE and is stored into a temporary here.
type Small
    as long a
end type

operator + ( byref x as Small, byref y as Small ) as Small
    dim as Small r
    r.a = x.a + y.a
    return r
end operator

dim as Big p, q
dim as Small u, v
dim as longint r1 = ( p + q ).a
dim as long r2 = ( u + v ).a
print r1, r2
