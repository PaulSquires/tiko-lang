type foo
	array as double ptr
	items as integer
	declare constructor (arr() as double)
end type
constructor foo (arr() as double)
	array = @arr(lbound(arr))
	items = (ubound(arr) - lbound(arr)) + 1
end constructor
dim shared g_arr1(1 To 3) As double = {1, 2, 3}
dim shared g_arr2(1 To 4) As double = {-1, -2, -3, -4}
dim shared g_footb(1 To 2) As foo = {g_arr1(), g_arr2()}
print g_footb(1).items; g_footb(2).items; g_footb(1).array = @g_arr1(1); g_footb(2).array[3]
type bv
	v as integer
	declare constructor( byval x as integer )
end type
constructor bv( byval x as integer )
	v = x * 10
end constructor
dim shared as bv g7(0 to 1) = { 7, 8 }
print g7(0).v; g7(1).v
