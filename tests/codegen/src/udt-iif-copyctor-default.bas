'' iif over a UDT whose copy constructor has a defaulted second parameter: the arm is copy-constructed
dim shared as integer nc, ncc, nd
type A
	i as integer
	declare constructor( byval i as integer )
	declare destructor( )
end type
constructor A( byval i as integer ) : nc += 1 : print "A+"; : end constructor
destructor A( ) : nd += 1 : print "A-"; : end destructor
type B
	i as integer
	declare constructor( byval i as integer )
	declare constructor( byref rhs as B, byref x as A = type<A>( 123 ) )
	declare destructor( )
end type
constructor B( byval i as integer ) : this.i = i : nc += 1 : print "B+"; : end constructor
constructor B( byref rhs as B, byref x as A ) : this.i = rhs.i : ncc += 1 : print "Bc"; : end constructor
destructor B( ) : nd += 1 : print "B-"; : end destructor
dim c as integer = -1
scope
	dim as B b1 = B( 1 ), b2 = B( 2 )
	print "|";
	print (iif( c, b1, b2 )).i;
	print "|";
end scope
print : print nc; ncc; nd
