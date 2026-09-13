'' AN INTRINSIC OVER A CONSTANT IS A CONSTANT, and joins the regrouping around it.
'' Measured in fbc's C (a = 1, fa = 1), each constant then multiplied in as one:
''
''     a / (abs(42.3) + 1.5) * 1.7      (A / 43.8) * 1.7
''     a * int(-3.5) * 1.7              A * -6.8
''     a * frac(-3.3) * 1.7             A * ((-3.3 - -3) * 1.7)
''     a * cint(2.5) * 1.7              A * 3.4               half to even
''     fa * sqr(2.0f) * 1.7f            sqrt of the SINGLE 2, in double, unrounded
''     fa * csng(1.1) * 2.4f * 5.4f     as for the literal 1.1f
sub bits( byref label as string, byval d as double )
	print label; " "; hex( *cptr( ulongint ptr, @d ), 16 )
end sub
sub sb( byref label as string, byval s as single )
	print label; " "; hex( *cptr( ulong ptr, @s ), 8 )
end sub
dim as double a = 1, b = 0.37
dim as single fa = 1
bits( "abs-sum", b / (abs(42.3) + 1.5) * 1.7 )
bits( "abs", b * abs(-3.3) * 1.7 )
bits( "sgn", b * sgn(-3.3) * 1.7 )
bits( "int", a * int(-3.5) * 1.7 )
bits( "fix", a * fix(-3.5) * 1.7 )
bits( "frac", a * frac(-3.3) * 1.7 )
bits( "cint", a * cint(2.5) * 1.7 )
bits( "clng", a * clng(3.5) * 1.7 )
bits( "sqr", b * sqr(2.0) * 1.7 )
bits( "cdbl", b * cdbl(3) * 1.7 )
bits( "nested", b * abs(fix(-3.7) * 2.0) * 1.7 )
bits( "abs-negzero", b * abs(-0.0) + 1.7 )
sb( "s-sqr", fa * sqr(2.0f) * 1.7f )
sb( "s-csng", fa * csng(1.1) * 2.4f * 5.4f )
sb( "s-frac", fa * frac(3.3f) * 1.7f )
