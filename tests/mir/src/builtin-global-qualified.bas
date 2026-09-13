'' A BUILTIN CALLED THROUGH THE GLOBAL SCOPE IS THE BUILTIN. AfxNova's BSTRING.inc writes
'' '.LEN( ansiStr )' inside a method to reach the builtin past its own OPERATOR LEN overloads,
'' and fbc runs the builtin. tiko parsed the dotted name as a member, the intrinsic table
'' never saw it, and overload resolution tied the two user operators: TKO0660.
''
'' fbc prints: 6 / 9 / 100
type DWS
	as wstring * 32 buf
	declare constructor( byref s as string )
end type
constructor DWS( byref s as string )
	buf = s
end constructor
type BSS
	as wstring * 32 buf
	declare constructor( byref s as string = "" )
	declare function Count( byref t as string ) as long
	declare function Count3( byref t as string ) as long
end type
constructor BSS( byref s as string = "" )
	buf = s
end constructor
operator len overload ( byref d as DWS ) as uinteger
	return 100
end operator
operator len ( byref b as BSS ) as uinteger
	return 200
end operator
function BSS.Count( byref t as string ) as long
	if .LEN( t ) then return .LEN( t ) * 2 + ..LEN( t ) - len( t )
	return 0
end function
function BSS.Count3( byref t as string ) as long
	with this
		return ..len( t ) * 3
	end with
end function
dim as BSS b
print b.Count( "abc" )
print b.Count3( "abc" )
dim as DWS d = DWS( "q" )
print len( d )
