dim shared as integer ctors, dtors, zero
type UDT
    as integer i, alive
    declare constructor( )
    declare constructor( i as integer )
    declare destructor( )
end type
constructor UDT( ) : ctors += 1 : print "[c0]"; : end constructor
constructor UDT( i as integer ) : ctors += 1 : this.i = i : print "[c"; i; "]"; : end constructor
destructor UDT( ) : dtors += 1 : print "[d]"; : end destructor
sub takeR( byref u as UDT ) : print " takeR"; u.i; : end sub
print "A:"; : takeR( type<UDT>( 5 ) ) : print " "; ctors; dtors
ctors = 0 : dtors = 0
print "B:"; : print ( type<UDT>( 6 ) ).i; : print " "; ctors; dtors
ctors = 0 : dtors = 0
print "C:"; : takeR( UDT( 7 ) ) : print " "; ctors; dtors
ctors = 0 : dtors = 0
print "D:";
with UDT( 8 )
    print .i;
end with
print " "; ctors; dtors
