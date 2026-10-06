'' type<C>( type<C>( n ) ) over a copy constructor: one construction, one copy
type C
	as integer i
	declare constructor( byval n as integer )
	declare constructor( byref o as C )
	declare destructor()
end type
dim shared as integer nc, ncc, nd
constructor C( byval n as integer ) : i = n : nc += 1 : end constructor
constructor C( byref o as C ) : i = o.i : ncc += 1 : end constructor
destructor C() : nd += 1 : end destructor
scope : dim as C x = type<C>(type<C>(5)) : print x.i : end scope
print nc; ncc; nd
nc = 0 : ncc = 0 : nd = 0
scope : dim as C x = type<C>(type<C>(type<C>(5))) : end scope
print nc; ncc; nd
nc = 0 : ncc = 0 : nd = 0
sub f( byval v as C ) : print v.i; : end sub
f( type<C>(type<C>(7)) ) : print
print nc; ncc; nd
