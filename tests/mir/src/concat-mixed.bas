'' CONCATENATION, in the four flavours that were declining. Every shape here was read
'' out of the C fbc generates, and two of them are not what a guess would produce.

'' A NUMBER IN A CONCATENATION IS RENDERED, not refused: the renderer already existed
'' for STR( ) and only STR( ) could reach it.
''     fb_IntToStr( (int32)X ) then an ordinary narrow fb_StrConcat
dim as byte x = 5
dim as string s, r
r = x & ", "
print x & ", " & s

'' A STRING CONSTANT IS ITS TEXT. The constant evaluator carries a longint, so a string
'' const had no value it could return and every use of one declined -- including the
'' filename of every OPEN in the corpus's file tests.
const TESTFILE = ("./dir/" & "f.txt")
r = TESTFILE
print TESTFILE

'' STR AND WSTR OF A STRING ARE THE IDENTITY, and neither is a no-op: 'str( z )' over a
'' 'zstring * N' is the descriptor that flavour has to borrow.
dim as zstring * 20 z
print str( z )
print str( s )

'' A MIXED CONCATENATION HAS ITS OWN TWO ENTRY POINTS, and ONLY A GENUINELY WIDE TERM
'' IS WIDE: a literal is not -- measured, 'w & ", "' is fb_WstrConcatWA over the NARROW
'' entry point -- and neither is a number, so 'x & ", " & w' folds its narrow prefix
'' first and only then goes wide.
dim as wstring * 20 w
print s & w
print w & s
print w & ", " & w
print x & ", " & w
r = s & w

'' 'wstr( x )' HAS NO TYPE of its own, so a chain containing one looked entirely narrow.
print wstr( w )
print wstr( """" & wstr( w ) & """" )

'' A CONCATENATION OF LITERALS IS NARROW. Taking it for a wide one printed two wide
'' literals through fb_WstrConcat.
print "a" & "b"

'' THE ENCODING CLAUSE IS A DIFFERENT ENTRY POINT, fb_FileOpenEncod, taking a trailing
'' raw char* -- and fbc does not validate it.
open TESTFILE for output encoding "utf-16" as #1
close #1
