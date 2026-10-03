'' See ../ctor-arg-count.test.
type P
    as long v
    declare constructor( byval a as long )
end type
constructor P( byval a as long ) : v = a : end constructor
type Q
    as long v
    declare constructor( byval a as long, byval b as long = 2 )
end type
constructor Q( byval a as long, byval b as long = 2 ) : v = a + b : end constructor
type R
    as long v
    declare constructor( byval a as long, byval b as long, byval c as long )
    declare constructor( byval a as long )
end type
constructor R( byval a as long, byval b as long, byval c as long ) : v = a : end constructor
constructor R( byval a as long ) : v = a : end constructor
type PA as P
sub g( byval pp as P ) : end sub
var a1 = P( 1, 2 )
dim a2 as P = P( 1, 2 )
a2 = P( 1, 2 )
g( P( 1, 2 ) )
dim a3 as P ptr = new P( 1, 2 )
var a4 = PA( 1, 2 )
var a5 = P( )
var b1 = Q( 1, 2, 3 )
var b2 = Q( )
var c1 = R( 1, 2 )
var c2 = R( 1, 2, 3, 4 )
var c3 = R( )
