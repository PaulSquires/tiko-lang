type UDT1
	declare constructor (array() as integer)
	array as integer ptr
end type
constructor UDT1 (array() as integer)
	dim as integer j, i
	this.array = allocate( ((ubound(array) - lbound(array)) + 1) * len( integer ) )
	j = 0
	for i = lbound(array) to ubound(array)
		this.array[j] = array(i)
		j += 1
	next
end constructor
type tmp_udt
	pad as integer
	array(0 to 3) as integer
end type
dim shared as tmp_udt tmp = (1234, {0, 1, 2, 3})
dim shared as UDT1 g_var = UDT1( tmp.array() )
for i as integer = 0 to 3 : print g_var.array[i]; : next : print
