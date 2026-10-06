dim mytestvar as typeof( "test" )
print sizeof( mytestvar ), sizeof( "test" ), sizeof( zstring * 5 )
dim m2 as typeof( wstr( "test" ) )
print sizeof( m2 ), sizeof( wstr( "test" ) ), sizeof( wstring * 5 )
m2 = "abcd" : print m2
