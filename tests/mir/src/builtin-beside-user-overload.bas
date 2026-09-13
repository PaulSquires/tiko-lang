'' A BUILTIN'S NAME OVERLOADED BY THE PROGRAM STILL NAMES THE BUILTIN for a builtin argument.
'' AfxNova declares 'Left OVERLOAD( byref as DWSTRING, n )' and calls 'LEFT( w, 1 )' over a
'' 'byref as const wstring'; fbc runs the builtin. tiko judged the const argument against the
'' user overload's non-const byref parameter and refused it (TKO0699) -- PsControls could not
'' build a single demo.
''
'' fbc prints: a / [ / userleft
type DWS
	as wstring * 32 buf
	declare constructor( byref s as string )
	declare constructor( byref w as const wstring )
end type
constructor DWS( byref s as string )
	buf = s
end constructor
constructor DWS( byref w as const wstring )
	buf = w
end constructor
type BSS
	as wstring * 32 buf
	declare constructor( byref s as string = "" )
end type
constructor BSS( byref s as string = "" )
	buf = s
end constructor
function Left overload ( byref d as DWS, byval n as integer ) as DWS
	return DWS( "userleft" )
end function
sub T( byref w as const wstring )
	print left( w, 1 )
end sub
sub T2( byref w as const wstring )
	if left( w, 1 ) <> "[" then print "plain" else print left( w, 1 )
end sub
T( "abc" )
T2( "[x]" )
dim as DWS d = DWS( "x" )
print left( d, 1 ).buf
