dim shared as integer ctor_count
type T
	declare constructor( )
	as integer i
end type
constructor T( )
	ctor_count += 1
end constructor
type DtorUDT
	i as integer
	declare destructor( )
end type
destructor DtorUDT( )
end destructor
sub s
	static as DtorUDT staticx1 = ( 123 )
	dim as DtorUDT localx1 = ( 123 )
	print staticx1.i, localx1.i
	dim as T x = any
	print ctor_count
	x.constructor( )
	print ctor_count
end sub
s
