type A extends object
	declare virtual function f1( ) byref as const integer
end type
function A.f1( ) byref as const integer
	static i as integer = &hA1
	function = i
end function
dim xa as A
print hex(xa.f1( ))
