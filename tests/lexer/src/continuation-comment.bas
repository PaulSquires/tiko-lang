'' A COMMENT MAY SIT BETWEEN THE '_' AND THE NEWLINE.
''
'' The corpus writes its long continued expressions that way -- 'sizeof(ubyte) + _ '' 1'
'' with the running total in the comment -- and fbc folds all three comment forms, the
'' apostrophe, the block and REM, to the same value. Measured: each sum below is 6.
''
'' Without it the '_' was lexed as an IDENTIFIER and the logical line ended there, so
'' every such expression came apart: structs/padding.bas is written almost entirely in
'' this shape.
dim as long a = 1 + _   '' one
	2 + _               '' two
	3

dim as long b = 1 + _   /' one '/
	2 + _               /' two '/
	3

dim as long c = 1 + _   rem one
	2 + _               rem two
	3

'' A BLOCK COMMENT THAT DOES NOT CLOSE ON THE LINE is not a continuation's trailing
'' comment: the '_' before it is an ordinary identifier character and the line ends.
dim as long d = 4

print a, b, c, d
