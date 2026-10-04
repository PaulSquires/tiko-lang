'' Writes to const data -- each fbc's 119.
dim as const integer a( 2 ) = { 1, 2, 3 }
a( 0 ) = 5
type T : as const integer k = 1 : as integer m : end type
dim x as T
x.k = 2
dim as const integer cc = 1
for cc = 1 to 2
next
const S = "abc"
S[ 0 ] = 65
'' ...and what fbc takes.
dim as integer b = a( 1 )
x.m = 2
for i as integer = 1 to 2
next
dim as integer ia( 2 )
ia( 1 ) = 4
type T2
    as const integer k = 1
    declare constructor( )
end type
constructor T2( )
    this.k = 3
end constructor
