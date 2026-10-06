dim shared array9(11 to ...) as integer = { 1, lbound( array9 ), 3 }
dim shared const_array9(11 to ...) as const integer = { 1, lbound( const_array9 ), 3 }
dim shared a2(0 to 3) as integer = { 5, ubound( a2 ), 7, 8 }
print lbound( array9 ), ubound( array9 ), array9(11), array9(12), array9(13)
print const_array9(12), a2(1)
sub s
	static sa(2 to ...) as integer = { lbound( sa ), 9 }
	dim la(4 to ...) as integer = { lbound( la ), 6 }
	print sa(2), sa(3), la(4), la(5)
end sub
s
