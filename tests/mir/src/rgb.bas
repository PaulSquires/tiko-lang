'' 'rgb( r, g, b )' AND 'rgba( r, g, b, a )'. Neither is a call: fbc folds each into
'' shifts and ors, and each component is TRUNCATED TO A BYTE first. Measured:
''
''   rgb( r, g, b )      ((r&255) << 16) | ((g&255) << 8) | (b&255) | 0xFF000000
''   rgba( r, g, b, a )  the same three, with ((a&255) << 24) in place of the constant
''
'' They are PREDECLARED NAMES rather than procedures -- 'dim as long rgb' is fbc's
'' error 4, duplicated definition -- so they cannot be written in the prelude either,
'' and every 'line ..., rgb( 255, 0, 0 ), bf' in the graphics corpus declined for it.
dim as ulong r = 1, g = 2, b = 3, a = 4
dim as ulong c1 = rgb( r, g, b )
dim as ulong c2 = rgba( r, g, b, a )
dim as ulong c3 = rgb( 255, 0, 0 )

'' A FLOATING GLOBAL INITIALISER had no value at all: ConstVal carries a longint, so
'' the folder could not return one and the global went out uninitialised.
dim shared as double gd = 1.5
dim shared as single gs = 0.25 * 2.0
