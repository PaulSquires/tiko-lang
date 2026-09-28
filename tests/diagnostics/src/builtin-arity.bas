'' A BUILTIN FUNCTION WITH THE WRONG NUMBER OF ARGUMENTS, or named with no argument list --
'' fbc's errors 7, 9, 16 and 6 on lines 9 to 18 (fbc-modern 1.20). tiko dropped each statement
'' in silence. Lines 20 to 25 are well-formed.
dim as long n = 1
dim as long x
dim as string s = "abc"
dim as double d

x = len( s, 2 )
x = len( )
d = sqr( )
s = chr( )
x = sizeof( n, 1 )
x = asc( s, 1, 2 )
s = mid( s )
x = instr( s )
x = len
d = abs

x = len( s ) + sizeof( n )
x = asc( s, 1 )
s = mid( s, 1, 2 )
s = chr( 65, 66, 67 )
x = instr( 1, s, "b" )
d = abs( -3 ) + sin( 1 )
