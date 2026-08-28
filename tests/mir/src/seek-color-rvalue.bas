'' THE FUNCTION SPELLINGS of two statements, which are different entry points.
'' Measured, one probe each:
''
''   dim as longint p = seek( 1 )   fb_FileTell( 1 )     -- NOT fb_FileSeekLarge
''   var old = color( 1 )           fb_Color( 1, 0, 2u ) -- the same call the
''                                                          statement makes, with
''                                                          its result kept
open "seek-color-rvalue.tmp" for binary as #1
dim as longint p = seek( 1 )
close #1
dim as long oldc = color( 1 )
print p, oldc
