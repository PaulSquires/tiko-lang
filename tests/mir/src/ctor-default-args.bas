'' A constructor with a DEFAULTED TRAILING PARAMETER answers the shorter call, and
'' 'new const T' allocates and constructs exactly as 'new T' does.
type A
	as long v
	declare constructor( )
	declare constructor( byval c as long, byval os as long = 0 )
end type
constructor A( )
	this.v = 1
end constructor
constructor A( byval c as long, byval os as long = 0 )
	this.v = c + os
end constructor
dim p as const A ptr = new const A
dim as A a1 = A( 5 )
dim as A a2 = A( 5, 6 )
print p->v, a1.v, a2.v
