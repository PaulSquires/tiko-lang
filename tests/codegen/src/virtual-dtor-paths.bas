'' virtual destructors: through a const pointer, and a derived type's IMPLICIT destructor overriding
dim shared as integer adtors, bdtors
type A extends object
	declare virtual destructor( )
end type
type B extends A
	declare destructor( ) override
end type
destructor A( ) : adtors += 1 : end destructor
destructor B( ) : bdtors += 1 : end destructor
scope
	dim xb as const B = B()
end scope
print adtors, bdtors
adtors = 0 : bdtors = 0
scope
	dim p as const A ptr = new B
	delete p
end scope
print adtors, bdtors
adtors = 0 : bdtors = 0
scope
	dim p as A ptr = new B
	delete p
end scope
print adtors, bdtors
dim shared as integer callsA, callsFB
type A2 extends object
	declare virtual destructor( )
end type
destructor A2( ) : callsA += 1 : end destructor
type FB
	dummy as integer
	declare destructor( )
end type
destructor FB( ) : callsFB += 1 : end destructor
type B2 extends A2
	f as FB
end type
scope : dim x as B2 : end scope
print callsA; callsFB
callsA = 0 : callsFB = 0
scope : dim as B2 ptr p = new B2 : delete p : end scope
print callsA; callsFB
callsA = 0 : callsFB = 0
scope : dim as A2 ptr p = new B2 : delete p : end scope
print callsA; callsFB
