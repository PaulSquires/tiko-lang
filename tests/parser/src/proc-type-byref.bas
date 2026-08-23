'' 'function( ) BYREF as T' -- A BYREF-RETURNING PROCEDURE TYPE. The modifier sits
'' before the AS, so 'Accept( KW_AS )' failed and the return type was left for the
'' caller to trip over as 'expected )'. The same shape as the byref-returning
'' procedure DECLARATION, which cost a run of its own.
declare sub f5 overload( byval p as function( ) byref as zstring )
declare sub f6 overload( byval p as function cdecl( ) byref as integer )
declare sub f7 overload( byval p as function( ) as integer )
dim as function( ) byref as long fp

'' TYPEOF'S OPERAND MAY BE A TYPE, and an expression parser reads 'any ptr' as two
'' names and fails on the second. '#assert typeof( p ) = typeof( any ptr )' is how the
'' corpus asserts a pointer type.
dim as any ptr pany
#assert typeof( pany ) = typeof( any ptr )
#assert typeof( pany ) = typeof( pany )
