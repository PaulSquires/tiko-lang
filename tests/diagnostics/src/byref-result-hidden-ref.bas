'' A byval parameter fbc passes by a hidden reference may be a byref result.
type Q
	s as string
end type
type R
	x as integer
	declare destructor()
end type
destructor R()
end destructor
type P
	x as integer
end type
function f1( byval s as string ) byref as string
	function = s                                '' fine
end function
function f2( byval u as Q ) byref as Q
	function = u                                '' fine: a string field
end function
function f3( byval u as R ) byref as R
	function = u                                '' fine: a destructor
end function
function f4( byval u as P ) byref as P
	function = u                                '' refused: plain data
end function
