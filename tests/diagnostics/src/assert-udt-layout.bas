'' '#assert' OVER A UDT'S SIZE AND A FIELD'S OFFSET -- fbc's error 308 on lines 21 to 29
'' (fbc-modern 1.20). tiko passed every one in silence, so a '#assert sizeof( T ) = N' held for
'' any N. Lines 31 to 41 hold and pass.
type G : d( 0 to 15 ) as ubyte : end type
type H
    a as G
    b as long
end type
type N2 : h as H : k as short : end type
type P1 field = 1 : a as byte : b as long : end type
union U : a as byte : b as double : end union
type B0 extends object : x as long : end type
type D0 extends B0 : y as byte : end type
type S0 : s as string : z as zstring * 5 : end type
type Al as H
namespace NS
    type Q : a as double : b as byte : end type
end namespace
dim as H x

#assert sizeof( G ) = 99
#assert sizeof( H ) = 21
#assert offsetof( H, b ) = 17
#assert sizeof( x ) = 22
#assert sizeof( N2 ) = 20 andalso 1 = 1
#assert offsetof( N2, h.b ) = 20
#assert sizeof( Al ) = sizeof( G )
#assert sizeof( NS.Q ) = 9
#assert len( P1 ) = 8

#assert sizeof( G ) = 16
#assert sizeof( H ) = 20 andalso offsetof( H, b ) = 16
#assert sizeof( x ) = 20
#assert sizeof( N2 ) = 24 andalso offsetof( N2, k ) = 20 andalso offsetof( N2, h.b ) = 16
#assert sizeof( P1 ) = 5 andalso offsetof( P1, b ) = 1
#assert sizeof( U ) = 8
#assert sizeof( B0 ) = 16 andalso sizeof( D0 ) = 24 andalso offsetof( D0, y ) = 16
#assert sizeof( S0 ) = 32 andalso offsetof( S0, z ) = 24
#assert sizeof( Al ) = 20 andalso offsetof( Al, b ) = 16
#assert sizeof( NS.Q ) = 16
#assert sizeof( G ) + sizeof( H ) = 36
