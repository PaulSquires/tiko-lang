'' A CALL THROUGH A PROCEDURE POINTER HAS BYREF PARAMETERS TOO. Measured -- fbc's C
'' for the call below is '(F$1)( &TMP$3, &TMP$4 )' with 'TMP$3 = 1' and 'TMP$4 = 2',
'' and for a byte parameter it writes '(P2$0)( (int8)0 )'.
type Cmp as function( byref as long, byref as long ) as boolean
type Take1 as sub( byval as byte )

function less( byref x as long, byref y as long ) as boolean
	return x < y
end function
sub sbyte_( byval b as byte )
	print b
end sub

sub run_( byref f as Cmp )
	'' Two RVALUES against byref parameters: each needs a temporary of the
	'' parameter's own width, and its ADDRESS is what goes out.
	print f( 1, 2 )
end sub

run_( @less )
dim as Take1 p = @sbyte_
p( 0 )

'' ...and the type argument is inferred from '@less' too, which is how fb/sort.bi's
'' comparer parameter is declared.
sub apply_( of TC )( byref f as TC )
	print f( 3, 4 )
end sub
apply_( @less )
apply_( function( byref x as long, byref y as long ) as boolean
	return x > y
end function )
