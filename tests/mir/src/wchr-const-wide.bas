'' 'wchr( ... )' AS A NAMED CONSTANT, with codes above 255.
''
'' The constant folder's carrier is a BYTE string -- one byte per code unit, widened
'' when the global is emitted -- so a code above 255 had nowhere to go and the fold
'' declined. That was honest, but it took the whole statement with it: 's = TV' over
'' 'const TV = wchr( 256, 257, 258 )' lowered nothing, and wstring/wchr.bas is two of
'' those.
''
'' The wide global already holds real code units in a pool of its own; only the path
'' from a CONSTANT to that pool was missing. WideLitUnits_ now reads a named constant's
'' initialiser and a 'wchr' call directly, and WideOperand_ asks it before falling back
'' to the byte carrier.
''
'' Measured by running fbc: three characters either way, 65/67 for the ASCII one and
'' 256/258 for the other, and the DIM initialiser form agrees.
const TV1 = wchr( 65, 66, 67 )
const TV2 = wchr( 256, 257, 258 )

dim as wstring * 32 s

s = TV1
print len( s ), asc( s, 1 ), asc( s, 3 )

s = TV2
print len( s ), asc( s, 1 ), asc( s, 3 )

dim as wstring * 32 t = TV2
print len( t ), asc( t, 2 )
