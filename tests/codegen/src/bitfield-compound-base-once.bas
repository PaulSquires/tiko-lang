type UDT
	a : 1 as integer
	b : 1 as integer
	c as integer
end type
dim shared as integer fcalls
dim shared as UDT x
function f( ) byref as UDT
	fcalls += 1
	function = x
end function
f( ).a += 1
print fcalls, x.a, x.b
f( ).c += 5
print fcalls, x.c
