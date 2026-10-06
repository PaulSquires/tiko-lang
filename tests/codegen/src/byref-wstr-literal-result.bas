function f8( ) byref as wstring
	function = wstr( "also good" )
end function
function f6( ) byref as zstring
	function = "also good"
end function
print f8( ) = wstr( "also good" ), len(f8()), f6() = "also good"
