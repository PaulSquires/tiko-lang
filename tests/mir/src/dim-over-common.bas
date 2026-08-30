'' "DIM'ing a COMMON works like a REDIM" -- dim/dim-common-dynamic-1.bas says so in its
'' own comment, and fbc emits the redim:
''
''     common a( ) as integer
''     dim a( 1 to 2 ) as integer
''     fb_ArrayRedimEx( (struct $7FBARRAYIvE*)&A$, 8ull, -1, 0, 1ull, 1ll, 2ll )
''
'' Collect already let the DIM through as a redeclaration -- that is the SYMF_COMMON row
'' in its duplicate check -- but the NODE still said DIM. Resolve gave it no dynamic-array
'' type and lowering built a fresh descriptor and ERASED it, so the array was never sized
'' and 'a( 1 ) = 5' wrote through a null descriptor. Nothing declined; the file reported
'' 0 statements not lowered while doing it. The runtime-call differential over dim/ is
'' what found it, as an fb_ArrayRedimEx fbc emits and tiko-lang did not.
''
'' The node is normalised to REDIM in Collect rather than at either consumer, because
'' both of them need it and only that pass knows the previous declaration was COMMON --
'' which is also why the VARIABLE-bound form below works: Resolve's redim row is what
'' gives it a dynamic-array type, and it only runs for a node spelled REDIM.
common a( ) as integer
dim a( 1 to 2 ) as integer
a( 1 ) = 5
print a( 1 )

var l = 1
var u = 3
common b( ) as integer
dim b( l to u ) as integer
b( 2 ) = 7
print b( 2 )
