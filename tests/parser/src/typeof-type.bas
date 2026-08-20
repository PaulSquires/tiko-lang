'' 'typeof( X )' used as a TYPE. It was read as a NAMED TYPE called 'typeof' with the
'' parenthesised group left behind -- silent in a DIM, where nothing follows it, and a
'' broken parameter list where something does:
''
''   declare sub f( byval c as typeof( sub( ) ) ptr, byval d as long )
''
'' which is how it surfaced. 20 corpus files, all of them including win/rpcndr.bi, whose
'' RpcSsSwapClientAllocFree declaration uses the form twice.
''
'' The group is consumed and DISCARDED, so the type is left unresolved rather than
'' wrong: the inner may be a type OR an expression and telling which needs Check. That
'' is no worse than the named type it used to produce, which resolved to nothing either.

dim a as typeof( sub( ) ) ptr
dim b as typeof( function( byval n as uinteger ) as any ptr ) ptr

declare sub f( byval c as typeof( sub( ) ) ptr, byval d as long )

'' The shape from rpcndr.bi, reduced.
declare sub g( byval a as function( byval n as uinteger ) as any ptr, _
               byval b as sub( byval p as any ptr ), _
               byval c as typeof( function( byval n as uinteger ) as any ptr ) ptr )
