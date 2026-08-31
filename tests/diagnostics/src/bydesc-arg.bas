'' A 'bydesc' PARAMETER TAKES THE WHOLE ARRAY -- fbc error 58, "Type mismatch". What it is
'' passed is a DESCRIPTOR, and an element has none. Measured:
''
''     sub f( a( ) as integer ) : f( a( 0 ) )      error 58    an ELEMENT is not one
''     sub f( a( ) as integer ) : f( a( ) )        OK
''     sub f( byval i as integer ) : f( a( 0 ) )   OK          an ordinary parameter
''
'' 'a( )' IS RECOGNISED BY ITS SHAPE, not by its type: an empty subscript list over an
'' array variable types as the ELEMENT here, so a type test alone refused
'' dim/shared-array-1.bas and -2.bas, which fbc accepts.
declare sub takesArray( a( ) as integer )
declare sub takesValue( byval i as integer )

dim shared as integer a( 0 to 1 )

'' -- refused ------------------------------------------------------------------
sub refused( )
    takesArray( a( 0 ) )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    takesArray( a( ) )
    takesValue( a( 0 ) )
end sub
