type T
	i as integer
	const ws = wstr( "hello" )
end type
const W2 = wstr( "hello" )
print sizeof( T.ws ), sizeof( wstr( "hello" ) ), sizeof( W2 ), len( W2 ), len( T.ws )
