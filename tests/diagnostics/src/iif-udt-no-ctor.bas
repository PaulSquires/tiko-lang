'' IIF OVER A UDT WITH CONSTRUCTORS BUT NEITHER A DEFAULT NOR A COPY ONE -- fbc's error 24 on
'' lines 23, 24 and 25 (fbc-modern 1.20). tiko accepted each. From line 27, a defaulted
'' argument and a string field (fbc writes the copy constructor) are fbc's, and accepted. See symbols/iifudt.bas.
type U1
    i as integer
    declare constructor( byval as integer )
end type
constructor U1( byval i as integer ) : end constructor
type U2
    i as integer
    declare constructor( byval as integer = 0 )
end type
constructor U2( byval i as integer ) : end constructor
type U3
    s as string
    declare constructor( byval as integer )
end type
constructor U3( byval i as integer ) : end constructor
dim as integer c
dim as U1 a1 = U1( 0 ), b1 = U1( 1 )
dim as U2 a2, b2
dim as U3 a3 = U3( 0 ), b3 = U3( 1 )
a1 = iif( c, a1, b1 )
a1 = iif( c, a1, U1( 2 ) )
a1 = iif( c, U1( 3 ), a1 )
'' accepted from here
a2 = iif( c, a2, b2 )
a3 = iif( c, a3, b3 )
print "end"
