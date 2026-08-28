'' A NESTED ENUM REACHED THROUGH AN INSTANCE. 'x.E.I' over a type holding 'enum E' has
'' an ENUM-typed base for its second step, and the field lookup answers only for a UDT --
'' so the member was unbound, the expression untyped, and the PRINT declined. Resolve's
'' own 'E.elem' case cannot reach it: there the base is an IDENT bound to the enum
'' symbol, and here it is a member access whose type only Check knows.
''
'' A NAME THAT IS BOTH A TYPE AND A PROCEDURE is, inside SIZEOF, the TYPE. An identifier
'' in expression position prefers the VALUE class, so 'sizeof( f1 )' measured the SUB.
'' Reached through the symbol slot's 'altClass' rather than a fresh lookup: an expression
'' node inside a procedure has no recorded scope to look a name up from.
''
'' Measured, all three: 'fb_PrintLongint( 0, 0ll, 2 )', '( 0, 1ll, 1 )', '( 0, 8ll, 1 )'.
type T
	enum E
		I
		J
	end enum
	v as long
end type
dim as T x
print x.E.I, x.E.J

type F1
	i as integer
end type
declare sub F1( )
print sizeof( F1 )
