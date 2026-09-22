'' A STRING-FAMILY CALL OVER A WIDE CHAIN IS WIDE. Check types '&' as STRING, and the call
'' takes its first argument's type, so each of these looked narrow.
dim as ustring u
for i as long = 1 to 9
    u = "Item " & right( "00" & wstr( i ), 2 )
next
u = "Item " & left( "00" & wstr( 5 ), 2 )
u = "Item " & mid( "00" & wstr( 5 ), 2 )
u = "Item " & ucase( "ab" & wstr( 5 ) )
u = "[" & trim( "  a" & wstr( 5 ) & "  " ) & "]"

dim as string s = right( "00" & wstr( 5 ), 2 )
print right( "00" & wstr( 5 ), 2 )
print right( ucase( "ab" & wstr( 5 ) ), 2 )
dim as long n = len( right( "00" & wstr( 5 ), 2 ) )
dim as long m = len( "00" & wstr( 5 ) )

'' A USTRING TERM STILL MAKES IT A USTRING CHAIN.
dim as ustring v = "00"
u = "I" & right( v & wstr( 5 ), 2 )
dim as long k = len( v & wstr( 5 ) )
