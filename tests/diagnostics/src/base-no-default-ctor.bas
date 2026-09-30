'' A base with no default constructor: what the derived type must write itself.
type Parent
	as integer i
	declare constructor( byval as integer )
end type
constructor Parent( byval i as integer )
end constructor
type Good extends Parent                        '' fine: both written, each calls base
	declare constructor( )
	declare constructor( byref as const Good )
end type
constructor Good( )
	base( 1 )
end constructor
constructor Good( byref r as const Good )
	base( 2 )
end constructor
type NoCtor extends Parent                      '' 186: no constructor at all
	j as integer
end type
type NoCopy extends Parent                      '' 188: no copy constructor
	declare constructor( )
end type
constructor NoCopy( )
	base( 3 )
end constructor
type NoBase extends Parent
	declare constructor( )
	declare constructor( byref as const NoBase )
end type
constructor NoBase( )
	i = 4
end constructor                                 '' 185: no base( ... )
constructor NoBase( byref r as const NoBase )
	base( 5 )
end constructor
type NoMutCopy extends Parent                   '' 187: a non-const let wants a non-const copy
	s as string
	declare constructor( )
	declare constructor( byref as const NoMutCopy )
	declare operator let( byref as NoMutCopy )
end type
