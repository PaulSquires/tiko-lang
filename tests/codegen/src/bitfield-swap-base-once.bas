type UDT
	a : 1 as integer
	b : 1 as integer
end type
dim shared as integer f1calls, f2calls
dim shared as UDT globalx
function f1( byval i as integer ) as integer
	f1calls += 1
	function = i
end function
function f2( ) byref as UDT
	f2calls += 1
	function = globalx
end function
dim array(0 to 0) as UDT
array(0).a = 1
swap array(f1( 0 )).a, array(f1( 0 )).b
print f1calls, array(0).a, array(0).b
globalx.a = 1
swap f2( ).a, f2( ).b
print f2calls, globalx.a, globalx.b
