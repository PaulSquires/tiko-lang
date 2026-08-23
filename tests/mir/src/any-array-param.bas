'' 'a( ) as ANY' TAKES AN ARRAY OF ANY ELEMENT TYPE. That is what the spelling is for:
'' fbc's own fbc-int header declares 'ArrayDescriptorPtr( a( ) as any )' and passes
'' arrays of every element type to it.
''
'' The argument of an array parameter arrives at overload costing as its ELEMENT type,
'' so costing 'integer' against 'any' said NOT VIABLE and the call came out UNTYPED.
'' Not a diagnostic -- the initialiser it fed simply had no value and declined, while
'' the identical call as a STATEMENT lowered fine because nothing asked its type.
type FBARRAY
    as any ptr dataPtr
end type

declare function DescOf( a( ) as any ) as FBARRAY ptr
declare function SumOf( a( ) as integer ) as integer

dim ints( 0 to 3 ) as integer
dim dbls( 0 to 1 ) as double

'' A FIXED array passed bydesc gets a SYNTHESISED descriptor -- measured, fbc emits
'' '(struct FBARRAY*)&tmp$2$0' rather than the array's own address.
dim d1 as FBARRAY ptr = DescOf( ints( ) )
dim d2 as FBARRAY ptr = DescOf( dbls( ) )
dim s as integer = SumOf( ints( ) )

'' A DYNAMIC array already has one, and passes it directly.
dim dyn( ) as integer
redim dyn( 0 to 2 )
dim d3 as FBARRAY ptr = DescOf( dyn( ) )
print d1, d2, s, d3
