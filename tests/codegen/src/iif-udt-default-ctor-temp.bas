dim shared as integer ctors
type CtorUdt
	i as integer
	declare constructor( )
end type
constructor CtorUdt( )
	ctors += 1
end constructor
dim as integer condtrue = 1
dim as CtorUdt a, b
a.i = 11 : b.i = 22
a = iif( condtrue, a, b )
print ctors, a.i
