sub s1( ) static
	dim as integer a(1 to 3, 1 to 3, 1 to 4) = { { {1, 2, 3}, {4, 5, 6} }, { {7, 8, 9}, {10, 11, 12} } }
	for i as integer = 1 to 3
		for j as integer = 1 to 3
			for k as integer = 1 to 4
				print a(i, j, k);
			next
		next
		print
	next
end sub
s1
dim shared as byte b(0 to 1, 0 to 2) = { { 1 }, { 2, 3 } }
print b(0,0); b(0,1); b(0,2); b(1,0); b(1,1); b(1,2)
type P : as long x, y : end type
dim shared as P pp(0 to 1, 0 to 1) = { { ( 1 ) }, { ( 2, 3 ), ( 4 ) } }
print pp(0,0).x; pp(0,0).y; pp(0,1).x; pp(1,0).x; pp(1,0).y; pp(1,1).x; pp(1,1).y
