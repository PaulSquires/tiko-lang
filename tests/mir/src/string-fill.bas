'' STRING( n, ch ) and its WIDE half, and the '(' that tells a call from a type.
dim as string a = string( 3, "a" )
dim as string b = string( 3, 65 )
dim as string c = space( 4 )
dim as wstring * 8 w, v
v = wstr( "q" )
w = wstring( 3, 65 )
dim as wstring * 8 u
u = wstring( 3, v )

'' 'len( string )' is the TYPE and 'len( string( ... ) )' is the call: only the '('
'' tells them apart.
dim as long n = len( string( 3, "a" ) )
dim as long m = len( (string( 3, "a" )) )
print a, b, c, w, u, n, m

'' ...and 'len( string )' names the TYPE and folds to its size, 24 -- the descriptor.
print len( string ), len( wstring ), sizeof( string ), len( integer )
