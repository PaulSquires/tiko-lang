'' AN ARRAY PARAMETER TAKES A DESCRIPTOR POINTER, in a DECLARATION as much as in a
'' definition.
''
'' SignatureFromProc -- the path for a procedure whose body this module has not lowered
'' yet -- read the parameter's typeref, which for 'b( ) as T' carries the ELEMENT's
'' type and no NF_BYREF. So the declaration came out 'declare void TAKE<23>(i32, i32)'
'' against a definition '(i32, ptr)', and the ABI pass copied the caller's 72-byte
'' descriptor into a 4-byte aggregate: the callee saw lbound 0, ubound -1, and the
'' program segfaulted.
''
'' ORDER IS WHAT HID IT. The definition path records the signature from the parameter
'' SLOTS, where an array slot is already a pointer, so it only shows when the CALL is
'' lowered before the callee's body -- which is what a generic calling a generic does.
'' The same call written at module scope was right all along.
''
'' fb/sort.bi's StableSortBy passes its scratch 'buf( )' to SortMergeBy exactly so.
type Rec
	as long key
end type

sub Take( of T )( byval tag as T, b( ) as T )
	print lbound( b ); ubound( b )
end sub

sub Outer_( of T )( byval tag as T, byval n as long )
	dim as T buf( any )
	redim buf( 0 to n-1 )
	print lbound( buf ); ubound( buf )
	Take( tag, buf( ) )
end sub

dim as Rec t
Outer_( t, 20 )
