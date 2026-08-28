'' AN ARRAY PARAMETER KEEPS THE RANK IT WAS WRITTEN WITH. Measured, fbc indexes
'' 'a( 1, 1 )' inside 'sub s( a( any, any ) as long )' as
''
''   *(int32*)((uint8*)((*(int64*)(A + 72) << 2) + *(int64*)A) + 4)
''
'' -- scaling by DIMTB[1].ELEMENTS at offset 72 -- and accepts a two-dimensional
'' array through a bare 'a( )' just the same, indexing it by the SUBSCRIPT COUNT.
sub s2( a( any, any ) as long )
	print a( 1, 1 )
end sub
sub s3( a( any, any, any ) as long )
	print a( 1, 1, 1 )
end sub
sub sopen( a( ) as long )
	print a( 1, 1 )
end sub
dim as long m( 0 to 2, 0 to 2 )
m( 1, 1 ) = 42
s2( m( ) )
sopen( m( ) )
dim as long n( 0 to 1, 0 to 1, 0 to 1 )
n( 1, 1, 1 ) = 7
s3( n( ) )
