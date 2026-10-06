function g( byval s as string ) byref as string
	function = s
end function
dim s as string = "magic"
print g( s ) = "magic"
