'' THE CV FAMILY OVER A LITERAL IS A CONSTANT.
''
'' 'cvshort( "ABCDEFGH" )' is that text's first two bytes read as a little-endian
'' integer, and fbc FOLDS it -- string/mkcv.bas writes seven 'const as longint'
'' initialised that way and then asserts each against a hex constant, so a constant with
'' no value is seven declines whose lines never mention a cv.
''
'' Measured by running the fold under fbc, on both targets:
''
''     cvshort   &h4241              both
''     cvi       &h4847464544434241  win64      &h44434241  win32
''     cvl       &h44434241          both
''     cvlongint &h4847464544434241  both
''
'' -- little-endian, SIGNED, and cvi follows the target's integer width.
''
'' The bytes come out of the SOURCE SPAN, the way LEN and ASC read theirs. An ESCAPED
'' literal is refused rather than decoded: '!"\n"' spans two characters and is one byte,
'' so reading its span would fold the backslash. CVS and CVD are float
'' reinterpretations and are left alone -- this folder has no float value to hand back.

const as longint SH = cvshort(   "ABCDEFGH" )
const as longint I  = cvi(       "ABCDEFGH" )
const as longint L  = cvl(       "ABCDEFGH" )
const as longint LL = cvlongint( "ABCDEFGH" )

print hex( SH ); " "; hex( L ); " "; hex( LL )
#ifdef __FB_64BIT__
	#assert I = &h4847464544434241
#else
	#assert I = &h44434241
#endif
#assert SH = &h4241
#assert L  = &h44434241
#assert LL = &h4847464544434241
