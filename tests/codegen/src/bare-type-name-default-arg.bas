type foo
	value As integer = any
	declare constructor( byval value as integer = 1234 )
	declare destructor( )
end type
constructor foo( Byval value As Integer )
	this.value = value
End constructor
destructor foo()
end destructor
function func ( byref param as foo = foo ) as integer
	static as foo ptr lastparam = 0
	print lastparam <> @param,
	lastparam = @param
	function = param.value
end function
print func
print func
