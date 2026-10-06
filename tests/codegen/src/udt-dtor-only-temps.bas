'' a destructor-only UDT (no constructor): x = type<T>( ... ) and dim x = f( ) go through a temporary that is destroyed
type DtorUdt
	i as integer
	declare destructor( )
end type
dim shared as integer nd
destructor DtorUdt( ) : nd += 1 : end destructor
function test1( byval x as DtorUdt ) as DtorUdt
	function = x
end function
sub test2( byval x as DtorUdt = test1( type<DtorUdt>( 123 ) ) )
end sub
nd = 0 : test2( ) : print "A"; nd
nd = 0 : scope : dim x as DtorUdt = test1( type<DtorUdt>( 123 ) ) : end scope : print "B"; nd
nd = 0 : scope : dim x as DtorUdt = ( 123 ) : x = type<DtorUdt>( 123 ) : end scope : print "C"; nd
nd = 0 : scope : dim x as DtorUdt = ( 123 ) : x = type( 123 ) : end scope : print "D"; nd
