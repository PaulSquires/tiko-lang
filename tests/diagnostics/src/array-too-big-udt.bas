'' AN ARRAY OF A UDT OVER 2147483647 BYTES, its bound written with 'sizeof( UDT )' -- fbc's error
'' 50 on lines 9, 11, 13 and 15 (fbc-modern 1.20). The bound did not fold, so the array was
'' DYNAMIC and never measured. Line 17, one element fewer, is fbc's and accepted.
type UDT
    as integer a, b, c, d
end type
const LIMIT = &h7FFFFFFF
const N = sizeof( UDT )
dim shared as UDT t1( 0 to LIMIT \ sizeof( UDT ) )
type C1
    as UDT f1( 0 to LIMIT \ sizeof( UDT ) )
end type
dim shared t2( 0 to LIMIT \ N ) as UDT
sub S( )
    static as UDT t3( 0 to LIMIT \ sizeof( UDT ) )
end sub
dim shared as UDT ok1( 0 to LIMIT \ sizeof( UDT ) - 1 )
print "end"
