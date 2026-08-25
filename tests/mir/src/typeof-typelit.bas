'' 'typeof( EXPR )' IS A TYPE WHEREVER ONE IS ALLOWED, not only in a declaration.
dim p as string ptr
dim as long x
dim as long a = sizeof( typeof( x ) )
dim as long b = sizeof( typeof( *p ) )
dim as long c = sizeof( typeof( *cptr( long ptr, 123 ) ) )

'' ...and 'type<T>( e )' over a type that is NOT a UDT is a plain CONVERSION.
dim as string s = "b"
dim as long n = 5
dim as string r = type<string>( s )
dim as long m = type<long>( n )
dim as double d = type<double>( n )

'' ...including inside a concatenation, which is where the corpus writes it.
dim as string q = s + (type<string>( "bbb" )) + s

print a, b, c, r, m, d, q
