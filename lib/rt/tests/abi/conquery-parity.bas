'' conquery-parity.bas -- the console queries: POS, CSRLIN, the screen sizes,
'' SCREEN( ) and the redirection flag. Twelve entry points on Windows and five on
'' POSIX, across eight fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THIS TEST RUNS WITH ITS OUTPUT REDIRECTED, and that is not a limitation to
'' work around -- it is the configuration the differential harness provides, and
'' it is the one where a console query's fallbacks matter most. Every value below
'' is therefore checked as a PROPERTY rather than as a number: a redirected
'' console reports the documented default size, a cursor position that is
'' non-negative, and IsRedirected true for output.
''
'' NOTHING PRINTS A RAW COORDINATE. The cursor moves as this program writes, so
'' printing POS would embed the length of the previous line in the expected
'' output -- which is exactly the kind of self-referential assertion that breaks
'' when a comment is edited. What is printed is whether the value is in range and
'' whether repeated calls agree.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - a redirected handle makes GetConsoleScreenBufferInfo FAIL, so every query
''     must have a defined fallback rather than returning whatever was on the
''     stack
''   - the WINDOW and the SCREEN BUFFER are different sizes on Windows and the
''     entry points are different: GetSize is the window, GetScreenSize the
''     buffer
''   - IsRedirected is PER DIRECTION -- a program whose stdout is a pipe still
''     has a console on stdin
''   - SCREEN( ) out of range is 0, not an error and not garbage

extern "rtlib"
	declare sub      pGetXY    alias "fb_ConsoleGetXY"        ( byval c as long ptr, byval r as long ptr )
	declare sub      pGetSize  alias "fb_ConsoleGetSize"      ( byval c as long ptr, byval r as long ptr )
	declare function pReadXY   alias "fb_ConsoleReadXY"       ( byval c as long, byval r as long, byval f as long ) as ulong
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	declare sub      pGetScrSz alias "fb_ConsoleGetScreenSize" ( byval c as long ptr, byval r as long ptr )
#endif
end extern

extern "c"   '' NON-FBCALL: undecorated in fbc's archive -- the point of the batch.
	declare function pGetX     alias "fb_ConsoleGetX"          ( ) as long
	declare function pGetY     alias "fb_ConsoleGetY"          ( ) as long
	declare function pMaxRow   alias "fb_ConsoleGetMaxRow"     ( ) as long
	declare function pIsRedir  alias "fb_ConsoleIsRedirected"  ( byval is_input as long ) as long
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	declare function pRawX     alias "fb_ConsoleGetRawX"       ( ) as long
	declare function pRawY     alias "fb_ConsoleGetRawY"       ( ) as long
	declare sub      pRawXY    alias "fb_ConsoleGetRawXY"      ( byval c as long ptr, byval r as long ptr )
#endif
end extern

dim as long c = any, r = any, c2 = any, r2 = any

print "-- redirection is per direction"
print "  output redirected="; pIsRedir( 0 )
print "  input flag is 0 or 1="; iif( (pIsRedir( 1 ) = 0) orelse (pIsRedir( 1 ) = 1), 1, 0 )

print "-- the window size has a defined fallback"
c = -1 : r = -1
pGetSize( @c, @r )
print "  cols>0="; iif( c > 0, 1, 0 ); " rows>0="; iif( r > 0, 1, 0 )
print "  cols<=1000="; iif( c <= 1000, 1, 0 ); " rows<=1000="; iif( r <= 1000, 1, 0 )
'' NULL out-parameters must be tolerated: PRINT asks for one at a time.
pGetSize( @c, 0 )
pGetSize( 0, @r )
pGetSize( 0, 0 )
print "  null args survived"

print "-- the largest possible window"
print "  maxrow>0="; iif( pMaxRow( ) > 0, 1, 0 ); " maxrow<=1000="; iif( pMaxRow( ) <= 1000, 1, 0 )

print "-- the cursor position"
c = -1 : r = -1
pGetXY( @c, @r )
print "  col>=0="; iif( c >= 0, 1, 0 ); " row>=0="; iif( r >= 0, 1, 0 )
c2 = -1 : r2 = -1
pGetXY( @c2, @r2 )
print "  stable across two calls="; iif( (c = c2) andalso (r = r2), 1, 0 )
print "  GetX agrees with GetXY="; iif( pGetX( ) = c, 1, 0 )
print "  GetY agrees with GetXY="; iif( pGetY( ) = r, 1, 0 )
pGetXY( @c, 0 )
pGetXY( 0, @r )
pGetXY( 0, 0 )
print "  null args survived"

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
print "-- the screen BUFFER is a different query from the window"
c = -1 : r = -1
pGetScrSz( @c, @r )
print "  cols>0="; iif( c > 0, 1, 0 ); " rows>0="; iif( r > 0, 1, 0 )
pGetScrSz( 0, 0 )
print "  null args survived"

print "-- the raw coordinates"
print "  rawX>=0="; iif( pRawX( ) >= 0, 1, 0 ); " rawY>=0="; iif( pRawY( ) >= 0, 1, 0 )
'' fb_ConsoleGetRawXY writes -1 on SUCCESS -- fbc's test is inverted, and the
'' reproduction is the point. Whatever it does, both runtimes must do it.
c = -99 : r = -99
pRawXY( @c, @r )
print "  rawXY wrote something="; iif( (c <> -99) orelse (r <> -99), 1, 0 )
print "  rawXY is the inverted one="; iif( (c = -1) andalso (r = -1), 1, 0 )
pRawXY( 0, 0 )
print "  null args survived"
#endif

print "-- SCREEN( ) out of range is 0"
print "  (0,0) char="; pReadXY( 0, 0, 0 ); " attr="; pReadXY( 0, 0, 1 )
print "  (-5,-5) char="; pReadXY( -5, -5, 0 )
print "  (30000,30000) char="; pReadXY( 30000, 30000, 0 )
'' In range, the value is whatever the terminal holds -- so only its RANGE is
'' asserted, not its value.
dim as ulong ch = pReadXY( 1, 1, 0 )
dim as ulong at = pReadXY( 1, 1, 1 )
print "  (1,1) char<=&hFFFF="; iif( ch <= &hFFFF, 1, 0 ); " attr<=&hFFFF="; iif( at <= &hFFFF, 1, 0 )

print "done"
