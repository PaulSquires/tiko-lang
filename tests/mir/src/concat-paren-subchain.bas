'' A PARENTHESISED STRING CHAIN IS THE SAME CHAIN: 'a & ( b & c )' is 'a & b & c'.
dim as wstring * 10 w = "q"
dim as ustring u = "U"
dim as long x = 1

'' A wide term inside the parentheses.
print ( "a" & w ) & "bc"
dim as string s = ( "a" & w ) & "bc"
dim as long n = len( ( "a" & w ) & "bc" )

'' A ustring term inside them.
print "x" & ( u & "y" )
print ucase( "x" & ( u & "y" ) )
dim as ustring r = "x" & ( u & "y" )

'' A ustring chain with a wide term prints as a USTRING.
print u & "a" & w

'' ARITHMETIC in parentheses stays arithmetic.
print ( x + 2 ) & "s"
