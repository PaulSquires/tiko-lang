'' valint and its siblings over a ustring convert it to a narrow string first.
dim as ustring u = "120"
dim as long a = valint( u )
dim as longint b = vallng( u )
dim as double d = val( u )
dim as ustring f( 1 )
f( 1 ) = "-1920"
dim as long e = valint( f( 1 ) )
print a; b; d; e
