'' A PASTE WHOSE OPERAND IS ITSELF A PASTE, one macro level down.
''
''     #macro INNER( ca ) : print p##ca : #endmacro
''     #macro OUTER( a )  : INNER( c##a ) : #endmacro
''     OUTER( s )                             ->  PCS
''
'' Measured against fbc, which prints PS and PCS.
''
'' tiko-lang printed PS and 'pou'. A pasted token's loc is REPOINTED AT THE USE SITE so
'' that diagnostics land somewhere the user can see -- and the spelling of an identifier
'' was then read as t.length bytes of source AT THAT LOC, which is the INVOCATION's
'' text: 'p' plus the first two characters of 'OUTER('. Numeric literals were rescued
'' from exactly this by recording their own span; an identifier has none, so the source
'' text is used only when it FOLDS TO THE INTERNED SPELLING.
''
'' It was silent. 'pou' is a perfectly good identifier, simply not a declared one, and
'' an undeclared name in an expression is an untyped node rather than an error -- so the
'' statement lowered to nothing and said nothing. 63 declines in string/concat.bas, the
'' concatenation matrix, were this one paste.
dim ps as long = 1
dim pcs as long = 2

#macro INNER( ca )
	print p##ca
#endmacro

#macro OUTER( a )
	INNER( a )
	INNER( c##a )
#endmacro

OUTER( s )

'' ...and THREE levels, where the middle name is itself pasted from a paste.
dim abc as long = 3

#macro L1( x )
	print ab##x
#endmacro
#macro L2( y )
	L1( y##c )
#endmacro
#macro L3( z )
	L2( z )
#endmacro
L3( )
