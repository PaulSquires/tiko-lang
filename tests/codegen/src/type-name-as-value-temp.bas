dim shared var_result as integer
dim shared A as integer = 2
type P extends object
	A as integer = 1
	declare sub proc()
end type
sub P.proc()
	var_result = A
end sub
type C extends P
	declare sub proc()
end type
sub C.proc()
	var_result = A
end sub
dim z as C
z.proc() : print var_result
cast(P, z).proc() : print var_result
cast(P, C).proc() : print var_result
cast(C, C).proc() : print var_result
