type UDT
	as integer i
	declare constructor( )
	declare constructor( i as integer )
	declare destructor( )
end type
constructor UDT( ) : print "c0"; : end constructor
constructor UDT( i as integer ) : print "c1"; : this.i = i : end constructor
destructor UDT( ) : print "d"; i; : end destructor
function f( byval i as integer ) as UDT
	function = type( i )
end function
function g( byval i as integer ) as UDT
	return type( i )
end function
sub h( byval u as UDT )
	print "h"; u.i;
end sub
sub t
	print "[f"; : print f( 5 ).i; : print "]"
	print "[g"; : print g( 6 ).i; : print "]"
	print "[dim"; : dim as UDT x = type( 7 ) : print x.i; : print "]"
	print "[asg"; : x = type( 8 ) : print x.i; : print "]"
	print "[arg"; : h( type( 9 ) ) : print "]"
end sub
t
print
