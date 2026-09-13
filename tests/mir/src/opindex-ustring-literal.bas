'' A LITERAL KEY FOR 'operator []( byref as ustring )' IS CONVERTED. fbc's C for 'r[ "name" ]':
''
''     fb_UStrAssign( &TMP, -1, (uint16[]){0x006E,...}, <len>, 0 )
''     vr = _ZN3ROWixER9FBUSTRING( &R, &TMP )  ...  fb_UStrDelete( &TMP )
''
'' tiko passed the literal's narrow descriptor, so the lookup compared UTF-16 against narrow
'' bytes and found nothing -- fbsqlite's 'row[ "name" ]' read NULL. fbc prints: 1 / 2 / -1
type Row
	as ustring cols( 0 to 2 )
	declare operator [] ( byref wantedName as ustring ) as long
end type
operator Row.[] ( byref wantedName as ustring ) as long
	for i as long = 0 to 2
		if ucase( cols( i ) ) = ucase( wantedName ) then return i
	next
	return -1
end operator
dim as Row r
r.cols( 0 ) = "id" : r.cols( 1 ) = "name" : r.cols( 2 ) = "age"
print r[ "name" ]
print r[ "AGE" ]
print r[ "nope" ]
