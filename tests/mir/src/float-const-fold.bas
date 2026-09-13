'' A CONSTANT FLOAT EXPRESSION IS FOLDED BY THE COMPILER, as fbc folds it -- with the
'' host's x86 arithmetic, so '0.0 / 0.0' is the NEGATIVE quiet NaN 0xFFF8000000000000.
'' Handed to LLVM as 'fdiv double 0.0, 0.0' it was folded at -O2 to LLVM's canonical
'' POSITIVE NaN instead (numbers/infnan.bas). Measured: fbc, with gas64, gcc and its own
'' LLVM backend alike, prints FFF8 for every constant form below, and 7FF8 for the negated.
sub bits( byref label as string, byval d as double )
	print label; " "; hex( *cptr( ulongint ptr, @d ), 16 )
end sub
bits( "nan", 0.0 / 0.0 )
bits( "nan2", -0.0 / 0.0 )
bits( "negnan", -(0.0 / 0.0) )
bits( "inf", 1.0 / -0.0 )
bits( "prod", 1.5 * 2.0 )
dim as single s = 2.5 / 4.0
print s
dim as double m = 3 * 0.5 + 1
print m
