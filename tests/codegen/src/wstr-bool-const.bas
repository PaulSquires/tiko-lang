'' 'wstr( true )' into a wstring: the builtin constant has no initialiser node to fold through.
dim as wstring * 50 a = wstr( true )
dim as wstring * 50 b = wstr( false )
dim as wstring * 50 c
c = wstr( true )
print len( a ); len( b ); len( c )
print a = wstr( "true" ), b = wstr( "false" )
