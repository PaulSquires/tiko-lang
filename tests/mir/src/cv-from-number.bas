'' THE CVx FAMILY TAKES A NUMBER TOO, and that half was neither typed nor lowered.
''
'' 'cvi( 1.58e40 )' does not read a string's bytes -- there is no string -- it
'' REINTERPRETS a number's bits, and fbc has a separate entry point for each pairing:
''
''   cvi( d ) / cvlongint( d )   fb_CVLONGINTFROMD( D$0 )
''   cvl( f )                    fb_CVLFROMS( F$0 )
''   cvd( q ) / cvd( i )         fb_CVDFROMLONGINT( Q$0 )
''   cvs( l )                    fb_CVSFROML( L$0 )
''
'' -- measured, and fbc REJECTS every other pairing with its error 58, so there is no
'' fifth row to invent by analogy. The intrinsic type table demanded a string, so every
'' one of these was typed as nothing and the declaration it initialises had no value to
'' store; lowering then asked a number for a string descriptor, which it has not got.
dim as double d = 1.5
dim as single f = 2.5
dim as long l = 3
dim as longint q = 4
dim as integer ii = 6

print cvi( d )
print cvlongint( d )
print cvl( f )
print cvd( q )
print cvs( l )
print cvd( ii )

'' ...and a LITERAL operand goes the same way -- string/mkcv.bas writes them that way
print cvi( 1.5839800103804824e+40 )
print cvl( 781.03521! )
