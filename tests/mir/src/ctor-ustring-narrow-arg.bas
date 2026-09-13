'' A NARROW STRING FOR A 'byref as ustring' CONSTRUCTOR PARAMETER, in every place a constructor
'' runs: an implicit conversion to a byval UDT, an explicit call, and 'dim x as T = init'.
'' fbc converts through a ustring temporary first:
''
''     fb_UStrAssign( &TMP_u, -1, (uint16[]){...}, <len>, 0 )
''     _ZN7DBVALUEC1ER9FBUSTRING( &TMP, &TMP_u )
''
'' tiko passed the literal's address or the narrow variable's own descriptor, so the text
'' came back empty or as mojibake -- every value fbsqlite binds as text. fbc prints:
''     [lit] [narrowvar] [x7] [ustrvar] [explicit] and ' 4 dimlit'
type DbValue
	as long kind
	as ustring t
	declare constructor( )
	declare constructor( byval intValue as longint )
	declare constructor( byref textValue as ustring )
end type
constructor DbValue( )
end constructor
constructor DbValue( byval v as longint )
	kind = 1
end constructor
constructor DbValue( byref v as ustring )
	kind = 4 : t = v
end constructor
function Take( byval a1 as DbValue ) as ustring
	return "[" & a1.t & "]"
end function
dim as string nv = "narrowvar"
dim as ustring uv = "ustrvar"
dim as long index = 7
print Take( "lit" )
print Take( nv )
print Take( "x" & index )
print Take( uv )
print Take( DbValue( "explicit" ) )
dim as DbValue d = "dimlit"
print d.kind; " "; d.t
