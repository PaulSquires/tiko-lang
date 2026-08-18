'' CAST, CPTR, SIZEOF and LEN take a TYPE where an expression would otherwise go.
dim as any ptr p
dim as string s
dim as ulongint u

dim as long a = sizeof( long ptr )
dim as long b = len( long ptr )
dim as long ptr c = cptr( long ptr, p )
dim as long d = cast( long, a )
dim as double e = *cptr( double ptr, @u )
dim as any ptr f = cast( const long ptr ptr, p )
dim as long g = sizeof( const long )

'' The same names still take an EXPRESSION, which is the common case.
dim as long h = len( s )
dim as long i = sizeof( p )
