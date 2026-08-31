'' A PARAMETER DEFAULT CANNOT NAME A LOCAL -- fbc error 272, "Local symbols can't be
'' referenced". The default is evaluated at the CALL SITE, where the declaring frame does
'' not exist.
''
'' Measured, and the second row is the one a scope test gets wrong:
''
''     dim shared g as integer : sub f( byval p as integer = g )      OK
''     dim localI as integer   : sub f( byval p as integer = localI ) error 272
''     const K = 5             : sub f( byval p as integer = K )      OK
''     sub f( byval p as integer = 5 )                                OK
''
'' A module-level 'dim' WITHOUT 'shared' still has automatic storage in fbc's model -- it
'' lives in main's frame -- so what decides is the SYMBOL's storage, not where it sits.
dim shared g as integer
dim localI as integer
const K = 5

'' -- refused ------------------------------------------------------------------
declare sub bad1( byval p as integer = localI )
declare sub bad2( byval p as integer = localI + 1 )

'' -- accepted -----------------------------------------------------------------
declare sub good1( byval p as integer = g )
declare sub good2( byval p as integer = K )
declare sub good3( byval p as integer = 5 )
declare sub good4( byval p as integer = g + K )
