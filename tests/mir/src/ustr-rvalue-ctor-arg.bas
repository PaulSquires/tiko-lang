'' A USTRING RVALUE FOR A 'byref as ustring' CONSTRUCTOR PARAMETER IS COPIED FIRST, as at a
'' call (ustr-rvalue-arg). fbc prints ' 4 [ROOM]', ' 5 [ROOM!]', ' 5 [room!]', ' 4 [room]',
'' ' 5 [ROOM!]', ' 5 [ROOM?]', ' 5 [ROOM#]', then ' 4 [name]' twice.
''
'' tiko handed the constructor the runtime temporary itself: 'Val( ucase( u ) )' came out
'' ' 0 []', and fbsqlite's 'DbValue( ucase( cell.AsText( ) ) & "!" )' returned "".
''
'' AN ELEMENT IS NOT A CALL RESULT. 'names_( 1 )' parses as a call and has an address; the
'' copy was once taken for it too, loading the descriptor's 24 bytes where a pointer
'' belongs -- fb/map.bi's Reserve, and every fbsqlite test with it, failed in clang.
type Val
	as ustring text
	declare constructor( byref t as ustring )
	declare function AsText( ) as ustring
end type
constructor Val( byref t as ustring )
	this.text = t
end constructor
function Val.AsText( ) as ustring
	return this.text
end function
sub Show( byval v as Val )
	dim as string s = v.text
	print len( v.text ); " ["; s; "]"
end sub
sub TakeU( byref u as ustring )
	dim as string s = u
	print len( u ); " ["; s; "]"
end sub
dim as ustring u = "room"
dim as Val cell = Val( u )
Show( Val( ucase( u ) ) )
Show( Val( ucase( u ) & "!" ) )
Show( Val( u & "!" ) )
Show( Val( cell.AsText( ) ) )
Show( Val( ucase( cell.AsText( ) ) & "!" ) )
dim as Val v2 = Val( ucase( cell.AsText( ) ) & "?" )
Show( v2 )
dim as Val v3 = ucase( u ) & "#"
Show( v3 )
dim as ustring names_( 0 to 2 )
names_( 0 ) = "id" : names_( 1 ) = "name" : names_( 2 ) = "age"
TakeU( names_( 1 ) )
Show( Val( names_( 1 ) ) )
