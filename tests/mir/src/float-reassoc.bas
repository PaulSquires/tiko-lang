'' FBC REGROUPS CONSTANTS IN FLOAT ARITHMETIC, and the result differs from left-to-right by
'' a ULP. Measured shapes, with fbc's own C beside each (a = 0.1, b = 0.7):
''
''     a*3.3*1.7          A * 5.61
''     (a*3.3)*(b*1.7)    (A*B) * 5.61
''     3.3*a*1.7          A * 5.61
''     (a+1.1)*3.3        (A*3.3) + 3.63
''     a*(b*3.3)          (A*B) * 3.3
''     a+(b+1.1)          (A+B) + 1.1
''     3.3*(a+1.1)        (A*3.3) + 3.63
''     ((a+1.1)*2.2)*3.3  (A*7.26) + 7.986
''     a/3.3*1.7          unchanged -- a division stops it
''     (a+1.1)*(b+2.2)    unchanged -- no constant factor
sub bits( byref label as string, byval d as double )
	print label; " "; hex( *cptr( ulongint ptr, @d ), 16 )
end sub
dim as double a = 0.1, b = 0.7
bits( "mul-chain", a * 3.3 * 1.7 )
bits( "two-products", (a * 3.3) * (b * 1.7) )
bits( "const-first", 3.3 * a * 1.7 )
bits( "dist", (a + 1.1) * 3.3 )
bits( "right-mul", a * (b * 3.3) )
bits( "right-add", a + (b + 1.1) )
bits( "lhs-mul", 3.3 * (a + 1.1) )
bits( "nested", ((a + 1.1) * 2.2) * 3.3 )
bits( "div", a / 3.3 * 1.7 )
bits( "two-sums", (a + 1.1) * (b + 2.2) )
