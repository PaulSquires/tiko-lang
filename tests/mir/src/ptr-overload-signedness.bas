'' WHICH POINTER OVERLOAD A POINTER ARGUMENT TAKES, when none of them is exact.
''
'' On win64 'integer' and 'longint' are the same eight bytes, so every candidate below
'' is equally NEAR the argument and a model built on width alone makes them tie -- the
'' call then binds to nothing, the expression stays untyped, and the statement declines
'' with no diagnostic. Both integerPointers groups of overload/pointers.bas went that
'' way, twenty-four statements.
''
'' Measured by running these calls under fbc. The order is: the argument's own
'' signed/unsigned COUNTERPART first, then merely the same signedness.
''
''   { longint ptr, integer ptr }   + ulongint ptr  ->  longint ptr
''   { longint ptr, integer ptr }   + uinteger ptr  ->  integer ptr
''   { longint ptr, ulongint ptr }  + integer ptr   ->  longint ptr
''   { longint ptr, ulongint ptr }  + uinteger ptr  ->  ulongint ptr
''
'' The first two are the counterpart rule and nothing else explains them; the last two
'' are the signedness rule with no counterpart on offer.

#macro proc( T )
	function f overload( byval p as T ) as string
		function = #T
	end function
#endmacro

#macro g( T )
	function j overload( byval p as T ) as string
		function = #T
	end function
#endmacro

proc( longint ptr )
proc( integer ptr )

g( longint ptr )
g( ulongint ptr )

dim pll as longint ptr, pull as ulongint ptr
dim pi as integer ptr, pui as uinteger ptr

print f( pull ); "|"; f( pui ); "|"; j( pi ); "|"; j( pui )

'' Run under fbc that line prints
''
''      longint ptr|integer ptr|longint ptr|ulongint ptr
