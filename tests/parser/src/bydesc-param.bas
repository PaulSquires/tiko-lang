'' Array-descriptor parameters. Measured against fbc:
''
''   declare sub f1( ( ) as integer )                  accepted -- UNNAMED
''   sub f2( a( ) as integer )                         accepted
''   declare sub f3( a( any ) as integer )             accepted
''   declare sub f4( a( any, any ) as integer )        accepted
''   dim p as sub cdecl( byval as integer, ( ) as integer )   accepted
''   sub f5( byref a( ) as integer )                   fbc error 59, a SEMANTIC rule
''
'' The named forms already worked. Only the UNNAMED one failed, because the check for
'' an absent name tested for 'as' alone -- and a descriptor's bounds follow where the
'' name would be, so '(' means the name is absent just as 'as' does.

declare sub f1( ( ) as integer )
declare sub f3( a( any ) as integer )
declare sub f4( a( any, any ) as integer )

dim p as sub cdecl( byval as integer, ( ) as integer )

sub f2( a( ) as integer )
	print ubound( a )
end sub

dim x(0 to 2) as integer
f2( x( ) )
