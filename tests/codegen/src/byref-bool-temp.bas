sub foo2( byref b as boolean, byval i as integer )
    print b; cbool( i )
end sub
foo2( 0, 0 ) : foo2( 2, 2 ) : foo2( 256, 256 ) : foo2( -1, -1 )
dim as integer k = 512
sub foo3( byref b as boolean ) : print b : end sub
foo3( k * 1 ) : foo3( 0.5 ) : foo3( 0.0 )
