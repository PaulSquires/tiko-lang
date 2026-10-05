dim as boolean b3
print ( cbool( 0 ) eqv cbool( 1 ) ); ( cbool( 1 ) eqv cbool( 1 ) ); ( cbool( 0 ) eqv cbool( 0 ) )
b3 = cbool( 0 ) eqv cbool( 1 ) : print b3
print ( cbool( 0 ) imp cbool( 1 ) ); ( cbool( 1 ) imp cbool( 0 ) )
print ( cbool( 1 ) xor cbool( 1 ) ); ( cbool( 0 ) xor cbool( 1 ) )
print ( (cbool( 0 ) eqv cbool( 1 )) = cbool( 0 ) )
sub foo2( byref b as boolean, byval i as integer )
    print b; cbool( i ); ( b = cbool( i ) )
end sub
dim as boolean bb
for i as integer = -1 to 2
    bb = cbool( i ) : foo2( bb, i )
next
dim as integer k = 2 : bb = k : print bb; ( bb = cbool( k ) )
