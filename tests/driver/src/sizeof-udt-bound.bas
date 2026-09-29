'' AN ARRAY BOUNDED BY 'sizeof( UDT )'. The UDT's layout is computed after Resolve, so the bound
'' did not fold and the array silently became DYNAMIC: a 'dim shared' one had ubound -1, and a
'' field one gave its type the wrong size. fbc prints 2 3 96 32. See symbols/constfold.bas.
type UDT
    as integer a, b, c, d
end type
const N = sizeof( UDT )
dim shared as UDT t( 0 to 64 \ sizeof( UDT ) )
dim shared as UDT t2( 0 to 64 \ N )
dim as UDT l( 0 to 96 \ sizeof( UDT ) )
type Container
    as UDT f( 0 to 64 \ sizeof( UDT ) )
end type
print "bounds " & ubound( t ) & " " & ubound( t2 ) & " " & ubound( l )
print "sizes " & sizeof( Container ) & " " & sizeof( t )
t( 2 ).d = 7
print "store " & t( 2 ).d
