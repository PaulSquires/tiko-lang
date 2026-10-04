'' new string( init ) and new ustring( init ) take their initialiser.
dim sp as string ptr = new string( "newstr" )
print *sp
dim s2 as string = "abc"
dim sp2 as string ptr = new string( s2 & "def" )
print *sp2; len( *sp2 )
delete sp : delete sp2
