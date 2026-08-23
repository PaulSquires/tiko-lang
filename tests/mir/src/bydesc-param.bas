'' 'sub Q( a( ) as long )' -- A BYDESC ARRAY PARAMETER.
''
'' The parser records the empty subscript as NF_ARRAY and NOTHING READ IT, so the
'' parameter was typed as its ELEMENT: 'redim a( ... )' inside the body found no array to
'' re-dimension and 'a( 0 ) = 1' had no descriptor to index through.
''
'' A DYNAMIC array, because bounds set by the caller are exactly what a bydesc parameter
'' does not know.
''
'' AND ITS SLOT HOLDS THE DESCRIPTOR'S ADDRESS, not the descriptor -- fbc's own signature
'' says so: 'void P( struct $7FBARRAYI1RE* ROWS$1 )'. Typing it alone was not enough and
'' was WORSE than the gap it replaced: the slot became a 72-byte descriptor by value with
'' the incoming pointer stored over its first field, so 'a( 0 ) = 1' loaded the
'' DESCRIPTOR'S OWN ADDRESS where the data pointer belongs and wrote through it,
'' corrupting the descriptor. It lowered and it verified.
''
'' One load, in AddrOfVar, and indexing, REDIM and ERASE are all right at once, because
'' every one of them asks that function for the descriptor -- the same shape a BYREF
'' parameter already had, one indirection along.
''
'' THE CALL SITE IS THE OTHER HALF, and it used to emit 'Q( _ )' -- a call with a hole
'' where its only operand belongs, pushed because an argument that would not lower was
'' pushed anyway. What crosses is a DESCRIPTOR POINTER, and which one depends on the
'' argument: a DYNAMIC array passes its own descriptor's address, while a FIXED one gets
'' a descriptor MATERIALISED over it, which is exactly what fbc emits -- nine stores and
'' then '&tmp'.

type R
    a as long
end type

sub Q( a( ) as long )
    a( 0 ) = 1
end sub

sub Build( rows( ) as R )
    redim rows( 0 to 3 )
    rows( 0 ).a = 1
    erase rows
end sub

sub P( )
    dim as long v( 0 to 3 )
    Q( v( ) )
    dim as long d( any )
    redim d( 0 to 3 )
    Q( d( ) )
end sub
