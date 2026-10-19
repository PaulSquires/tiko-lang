'' clng & co. over a USTRING parse the text (tracks-2026 TB-003): "2027" is 2027, not 2.
dim as ustring u = "2027"
dim as ustring f = "57.5"
dim as ustring * 8 fx = "77"
print clng( u ), cint( u ), clngint( u ), culngint( u ), culng( u )
print cdbl( f ), csng( f ), cbyte( "12" & u ), cushort( u )
print clng( fx ), clng( u & "1" ), cbool( u )
