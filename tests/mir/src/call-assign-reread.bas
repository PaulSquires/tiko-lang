'' 'f( args ) = value' IS NOT AN ASSIGNMENT. fbc warns 34 and re-reads it as the CALL
'' 'f( args = value )' -- and it does so whether the result is byval or byref, and
'' whether the callee is free or a member.
function br( byval i as integer ) byref as integer
	static j as integer = 0
	function = j
end function

'' WITH NO ARGUMENTS there is nothing to fold the '=' into, and it IS the assignment:
'' fbc emits 'vr = BR0( ); *vr = 456' and the program prints 456.
function br0( ) byref as integer
	static j as integer = 0
	function = j
end function

type T
	items(0 to 9) as long
	declare operator [] ( byval i as long ) byref as long
	declare function At( byval i as long ) byref as long
end type
operator T.[] ( byval i as long ) byref as long
	return this.items( i )
end operator
function T.At( byval i as long ) byref as long
	return this.items( i )
end function

br( 1 ) = 456
print br( 1 )        '' 0 -- the call was made and its result discarded
br0( ) = 456
print br0( )         '' 456 -- the assignment

dim a as T
a.At( 2 ) = 88
print a.At( 2 )      '' 0 -- a MEMBER is re-read the same way

'' THE BRACKET SPELLING IS UNTOUCHED: an 'operator []' is a real lvalue.
a[ 3 ] = 99
print a[ 3 ]         '' 99

dim q(0 to 3) as integer
q( 2 ) = 7
print q( 2 )         '' 7 -- an ARRAY subscript is an assignment too
