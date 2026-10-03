'' See ../ctor-arg-count-accepted.test.
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
constructor R( byval a as long, byval b as long, byval c as long ) : v = a + b + c : end constructor
constructor R( byval a as long ) : v = a : end constructor
type S
    as string s
    declare constructor( byval a as long, byval b as long )
end type
constructor S( byval a as long, byval b as long ) : s = str( a * b ) : end constructor
var q1 = Q( 1 )
var q2 = Q( 1, 5 )
dim q3 as Q ptr = new Q( 4 )
var r1 = R( 7 )
var r2 = R( 1, 2, 3 )
var s0 = S( 3, 4 )
var s1 = S( s0 )
print q1.v; q2.v; q3->v; r1.v; r2.v; " "; s1.s
delete q3
