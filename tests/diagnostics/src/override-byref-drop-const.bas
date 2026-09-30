'' An override may drop the const of a byref result, not add it.
type A extends object
	declare virtual function f1( ) byref as const integer
	declare virtual function f2( ) byref as integer
end type
function A.f1( ) byref as const integer
	static i as integer
	function = i
end function
function A.f2( ) byref as integer
	static i as integer
	function = i
end function
type B extends A
	declare function f1( ) byref as integer override              '' fine
	declare function f2( ) byref as const integer override        '' 225
end type
function B.f1( ) byref as integer
	static i as integer
	function = i
end function
function B.f2( ) byref as const integer
	static i as integer
	function = i
end function
