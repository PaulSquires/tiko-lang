'' A REFERENCE IS TRANSPARENT TO TypeOf_, so a 'byref' parameter's own type never says
'' it is one -- only the N_PARAM's NF_BYREF flag can. Three more places asked the type
'' and got the referent, and each passed a LOADED AGGREGATE where the signature wants a
'' pointer: clang's "defined with type '[8 x i8]' but expected 'ptr'".
''
''   - a DEFAULT argument. 'constructor T( i as integer, byref impl as X )' called as
''     'T( 420 )' fills the default, and the fill loaded its value.
''   - a PROPERTY SETTER's value, 'p( 0 ) = a'.
''
'' ...and one that is the same fact one step along: a call THROUGH A PROCEDURE POINTER
'' returning a STRING. A string result travels as a POINTER, and the rule that says so
'' asked the callee SYMBOL -- which for an indirect call is the VARIABLE holding the
'' pointer, whose type is the procptr and not the result. The signature has it.
type X
	as integer v
end type

dim shared as X gx

type T
	as integer i
	declare constructor( byval i as integer, byref impl as X = gx )
end type

constructor T( byval i as integer, byref impl as X )
	this.i = i + impl.v
end constructor

sub Take( byref tv as T )
	print tv.i
end sub

type Holder
	as X items( 0 to 3 )
	declare property p( byval i as long ) as X
	declare property p( byval i as long, byref v as X )
end type

property Holder.p( byval i as long ) as X
	return items( i )
end property

property Holder.p( byval i as long, byref v as X )
	items( i ) = v
end property

function MakeName( ) as string
	return "made"
end function

gx.v = 7
Take( T( 420 ) )

dim as Holder h
dim as X a
a.v = 101
h.p( 2 ) = a
print h.p( 2 ).v

'' A string result through a procedure pointer, DISCARDED -- the shape that has to
'' free the temporary through a pointer.
dim as function( ) as string pf = @MakeName
pf( )
print pf( )
