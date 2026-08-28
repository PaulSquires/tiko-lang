function bar( byval x as long ) as long
	return x
end function
function baz( byval x as long ) as long
	return x + 1
end function
dim shared a(0 to ...) as const zstring ptr = { @"a1", @"a2" }
dim shared f(0 to ...) as function( as long ) as long = { @bar, @baz }
print *a(0), f(1)(2)
