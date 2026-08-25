'' 'typeof( X )' used as a TYPE. It was read as a NAMED TYPE called 'typeof' with the
'' parenthesised group left behind -- silent in a DIM, where nothing follows it, and a
'' broken parameter list where something does:
''
''   declare sub f( byval c as typeof( sub( ) ) ptr, byval d as long )
''
'' which is how it surfaced. 20 corpus files, all of them including win/rpcndr.bi, whose
'' RpcSsSwapClientAllocFree declaration uses the form twice.
''
'' A TYPE OPERAND IS KEPT, as a nested TYPEREF: 'typeof( sub( ) )', 'typeof( integer
'' ptr )', 'typeof( const T )'. The attempt is speculative and counts only when the
'' type parse lands exactly on the closing ')', so an EXPRESSION operand -- which no
'' type parser reads -- falls through to the expression attempt after it, and anything
'' neither reads is still consumed and discarded.

dim a as typeof( sub( ) ) ptr
dim b as typeof( function( byval n as uinteger ) as any ptr ) ptr

declare sub f( byval c as typeof( sub( ) ) ptr, byval d as long )

'' The shape from rpcndr.bi, reduced.
declare sub g( byval a as function( byval n as uinteger ) as any ptr, _
               byval b as sub( byval p as any ptr ), _
               byval c as typeof( function( byval n as uinteger ) as any ptr ) ptr )
