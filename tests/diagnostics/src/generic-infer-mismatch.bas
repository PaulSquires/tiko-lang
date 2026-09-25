'' A generic call whose typed arguments fit no inference -- fbc's error 340 on lines 17 and
'' 18 (fbc-modern 1.20). Line 16 infers T = long; line 19 passes a parenthesised Box.
type Box( of T )
    v as T
end type
type Other( of T )
    v as T
end type
sub Take( of T )( byref b as Box( of T ) )
    print "take"
end sub
dim as Box( of long ) bx
dim as Other( of long ) o
dim as long n

Take( bx )
Take( o )
Take( n )
Take( ( bx ) )
