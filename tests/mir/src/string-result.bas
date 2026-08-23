'' A STRING RESULT IS ASSIGNED, NOT STORED.
''
'' The result slot holds a DESCRIPTOR, and copying one is not the same as assigning to
'' it: 'function = s' emitted a raw 24-byte aggregate copy, so the result descriptor
'' came out pointing at the ARGUMENT's data and both owners then freed it. It
'' compiled, verified and counted as lowered the whole time.
''
'' Measured from fbc, and the source length is what tells the three sources apart:
''
''     function = s        fb_StrAssign( &fb$result, -1, S, -1, 0 )
''     function = z        fb_StrAssign( &fb$result, -1, Z,  0, 0 )
''     function = "s"      fb_StrAssign( &fb$result, -1, "s", 2, 0 )
''     function = w        fb_WstrAssignToA( &fb$result, -1, W, 0 )
function FromString( byref s as string ) as string
	function = s
end function

function FromZstring( byref z as zstring ) as string
	function = z
end function

function FromZstringPtr( byval pz as zstring ptr ) as string
	function = *pz
end function

function FromWstring( byref w as wstring ) as string
	function = w
end function

function FromWstringPtr( byval pw as wstring ptr ) as string
	function = *pw
end function

function FromLiteral( ) as string
	function = "s"
end function

'' A CONCATENATION still flattens into assign-then-concat-assign, the same as an
'' ordinary string assignment does. fbc builds this one in a TEMPORARY and assigns
'' from it; the in-place chain is what fbc itself emits for an ordinary 'a = b + c',
'' and it is equivalent here because the result slot is freshly zeroed and cannot be
'' one of the terms. Recorded as a deliberate difference rather than left to look
'' like an oversight.
function FromConcat( byref a as string, byref b as string ) as string
	function = a & b & "!"
end function

dim as string q = FromString( "x" )
