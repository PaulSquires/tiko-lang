'' A CALL RETURNING A cva_list BYVAL HAS NO ADDRESS, and the vararg opcodes take one.
'' 'cva_arg( sidefx_byval( args ), integer )' is legal and prints 42; refusing it
'' declined the whole statement, so the side effect the corpus test is named for never
'' happened either.
''
'' The temporary is the OPERAND'S OWN, so writing through it -- which cva_arg does,
'' advancing the cursor -- advances the copy and not the caller's list. That is what
'' BYVAL means here.
function sidefx_byval( byval a as cva_list ) as cva_list
	return a
end function
sub f cdecl( byval n as integer, ... )
	dim as cva_list args
	cva_start( args, n )
	print cva_arg( sidefx_byval( args ), integer )
	cva_end( args )
end sub
f( 1, 42 )
