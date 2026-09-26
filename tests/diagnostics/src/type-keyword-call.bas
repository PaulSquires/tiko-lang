'' A TYPE KEYWORD CALLED LIKE A FUNCTION is fbc's error 9 (fbc-modern 1.20), on lines 9 to 12.
'' tiko took each for an intrinsic call nothing binds and dropped the statement in silence.
'' Lines 14 to 17 are accepted: 'string( n, c )' and 'wstring( n, c )' are functions, and a
'' type under sizeof or cast is a type argument.
dim as long x
dim as ustring u
dim as string s

u = ustring( "VARIANT" )
x = long( 5 )
x = zstring( 5 )
x = any( 5 )

s = string( 3, "a" )
u = wstring( 3, wchr( 66 ) )
x = sizeof( long ) + len( ustring )
x = cast( long, 2.6 )
