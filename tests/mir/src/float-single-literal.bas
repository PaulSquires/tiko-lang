'' A SINGLE LITERAL FOLDS AS ITS SINGLE VALUE. Measured against fbc:
''
''     1.1f * 1.0              3FF19999A0000000     not 3FF199999999999A
''     1.1f * 2.4f * 5.4f      41641895             the single values multiplied in DOUBLE
''     const KS as single = 1.1, then KS * 1.0     3FF19999A0000000
sub bits( byref label as string, byval d as double )
	print label; " "; hex( *cptr( ulongint ptr, @d ), 16 )
end sub
sub sb( byref label as string, byval s as single )
	print label; " "; hex( *cptr( ulong ptr, @s ), 8 )
end sub
const KS as single = 1.1
bits( "slit-dbl", 1.1f * 1.0 )
sb( "pure", 1.1f * 2.4f * 5.4f )
bits( "named", KS * 1.0 )
