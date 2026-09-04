'' contty-parity.bas -- fb_ConPrintRaw, fb_ConPrintTTY and their wide twins.
'' Four entry points across four fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THESE FOUR TAKE THEIR OUTPUT DEVICE AS AN ARGUMENT, which is what makes them
'' testable at all: fb_ConHooks carries a Write and a Scroll function pointer, so
'' this file supplies its own and RECORDS what they are handed. No terminal is
'' involved, nothing is redirected, and the whole TTY grammar -- tab stops, the
'' two line-feed modes, the wrap arithmetic, the flush points -- is compared
'' exactly rather than by address.
''
'' THE RECORDING IS THE OBSERVABLE, not the screen. Every Write call appends its
'' text and the coordinate it was made at; every Scroll call appends its
'' rectangle and row count. Two implementations that draw the same characters in
'' a different NUMBER of calls, or at different coordinates, differ here and
'' nowhere else -- and the flush rule is precisely a rule about call boundaries.

#include once "fbc-int/string.bi"

'' fb_console.h's fb_ConHooks. Plain ints, natural alignment.
type fb_Rect_
	as long L_, T_, R_, B_
end type

type fb_Coord_
	as long X_, Y_
end type

type ConHooks_ as HooksT

type FnScroll_ as sub cdecl _
	( byval h as ConHooks_ ptr, byval x1 as long, byval y1 as long, _
	  byval x2 as long, byval y2 as long, byval rows as long )
type FnWrite_ as function cdecl _
	( byval h as ConHooks_ ptr, byval buf as any ptr, byval l as uinteger ) as long

type HooksT
	as any ptr     Opaque
	as FnScroll_   Scroll_
	as FnWrite_    Write_
	as fb_Rect_    Border
	as fb_Coord_   Coord_
end type

#assert sizeof( HooksT ) = 48

extern "c"
	declare sub pRaw     alias "fb_ConPrintRaw" _
		( byval h as HooksT ptr, byval t as ubyte ptr, byval l as uinteger )
	declare sub pRawW    alias "fb_ConPrintRawWstr" _
		( byval h as HooksT ptr, byval t as wstring ptr, byval l as uinteger )
	declare sub pTTY     alias "fb_ConPrintTTY" _
		( byval h as HooksT ptr, byval t as ubyte ptr, byval l as uinteger, byval tm as long )
	declare sub pTTYW    alias "fb_ConPrintTTYWstr" _
		( byval h as HooksT ptr, byval t as wstring ptr, byval l as uinteger, byval tm as long )
end extern

dim shared as any ptr addrs( 0 to 3 )
addrs(0) = cast( any ptr, @pRaw )
addrs(1) = cast( any ptr, @pRawW )
addrs(2) = cast( any ptr, @pTTY )
addrs(3) = cast( any ptr, @pTTYW )

dim as long n = 0, distinct = 1
for i as integer = 0 to 3
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- all four console print entry points resolve"
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------------- the recorder

dim shared as string gLog
dim shared as long gWide      '' the Write hook is handed CHARACTERS, so it has
                              '' to be told the element width out of band
dim shared as long gFailAt    '' return FALSE on the Nth call, to test the stop
dim shared as long gCalls

sub resetLog( byval wide_ as long )
	gLog = ""
	gWide = wide_
	gFailAt = 0
	gCalls = 0
end sub

'' Renders one Write payload. Control codes never reach here -- TTY eats them --
'' but RAW can be handed anything, so they are shown as <nn>.
function render( byval buf as any ptr, byval l as uinteger ) as string
	dim as string out_ = ""
	for i as integer = 0 to l - 1
		dim as ulong c = any
		if( gWide <> 0 ) then
			#if sizeof( wstring ) = 2
				c = cast( ushort ptr, buf )[i]
			#else
				c = cast( ulong ptr, buf )[i]
			#endif
		else
			c = cast( ubyte ptr, buf )[i]
		end if
		if( (c >= 32) andalso (c < 127) ) then
			out_ += chr( c )
		else
			out_ += "<" + str( c ) + ">"
		end if
	next
	return out_
end function

function hookWrite cdecl ( byval h as HooksT ptr, byval buf as any ptr, byval l as uinteger ) as long
	gCalls += 1
	gLog += "  W(" + str( h->Coord_.X_ ) + "," + str( h->Coord_.Y_ ) + ") [" + _
	        render( buf, l ) + "]" + chr( 10 )
	'' A HOOK THAT REFUSES STOPS THE WHOLE RUN and the rest is discarded --
	'' there is no partial-write accounting, and gFailAt is how that is driven.
	if( (gFailAt <> 0) andalso (gCalls >= gFailAt) ) then return 0
	return 1
end function

'' THE SCROLL HOOK MOVES THE CURSOR ITSELF, exactly as a real driver does: it is
'' what makes the row stop growing. Without that the print loop would keep
'' calling it forever on a long string.
sub hookScroll cdecl ( byval h as HooksT ptr, byval x1 as long, byval y1 as long, _
                       byval x2 as long, byval y2 as long, byval rows as long )
	gLog += "  S(" + str( x1 ) + "," + str( y1 ) + "," + str( x2 ) + "," + str( y2 ) + _
	        ") rows=" + str( rows ) + chr( 10 )
	h->Coord_.Y_ -= rows
end sub

'' A 20x4 window at (1,1), which is small enough that wrapping and scrolling
'' happen in a handful of characters.
sub setup_( byref h as HooksT, byval x as long, byval y as long )
	h.Opaque = 0
	h.Scroll_ = @hookScroll
	h.Write_ = @hookWrite
	h.Border.L_ = 1 : h.Border.T_ = 1 : h.Border.R_ = 20 : h.Border.B_ = 4
	h.Coord_.X_ = x : h.Coord_.Y_ = y
end sub

sub showEnd( byref h as HooksT )
	print gLog;
	print "  end at ("; h.Coord_.X_; ","; h.Coord_.Y_; ")"
end sub

'' ------------------------------------------------------------------ RAW

print "-- fb_ConPrintRaw"

dim shared as HooksT h
dim shared as zstring * 128 buf

setup_( h, 1, 1 ) : resetLog( 0 )
buf = "hello"
pRaw( @h, @buf, 5 )
print "  short, no wrap:" : showEnd( h )

'' EXACTLY THE BORDER WIDTH: one write, and the column lands back at the left
'' border with the row advanced -- the `= Right + 1` test, not `>=`.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "12345678901234567890"
pRaw( @h, @buf, 20 )
print "  exactly one line:" : showEnd( h )

'' TWO AND A HALF LINES: three writes, and the third is short.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "1234567890123456789012345678901234567890abcde"
pRaw( @h, @buf, 45 )
print "  two and a half lines:" : showEnd( h )

'' STARTING MID-LINE: the first run is clipped to what is left of THAT row.
setup_( h, 15, 2 ) : resetLog( 0 )
buf = "abcdefghijklmnop"
pRaw( @h, @buf, 16 )
print "  starting at column 15:" : showEnd( h )

'' PAST THE BOTTOM: the scroll hook fires, and it fires BEFORE the write.
setup_( h, 1, 4 ) : resetLog( 0 )
buf = "1234567890123456789012345678901234567890"
pRaw( @h, @buf, 40 )
print "  from the last row:" : showEnd( h )

'' A REFUSING HOOK stops everything and discards the rest.
setup_( h, 1, 1 ) : resetLog( 0 ) : gFailAt = 2
buf = "1234567890123456789012345678901234567890abcde"
pRaw( @h, @buf, 45 )
print "  write hook fails on call 2:" : showEnd( h )

'' ZERO LENGTH writes nothing at all -- not even one empty call.
setup_( h, 3, 3 ) : resetLog( 0 )
pRaw( @h, @buf, 0 )
print "  zero length:" : showEnd( h )

'' ------------------------------------------------------------------ TTY

print "-- fb_ConPrintTTY"

setup_( h, 1, 1 ) : resetLog( 0 )
buf = "plain text"
pTTY( @h, @buf, 10, -1 )
print "  plain:" : showEnd( h )

'' THE FLUSH RULE: a cursor-moving control code flushes what came before it, so
'' this is THREE writes and not one.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "a" + chr( 13 ) + "b"
pTTY( @h, @buf, 3, -1 )
print "  a CR b -- CR flushes:" : showEnd( h )

'' LINE FEED IN TEXT MODE returns to the left border and drops a row; in
'' GRAPHICS MODE it only drops a row. Same string, two answers.
setup_( h, 5, 1 ) : resetLog( 0 )
buf = "ab" + chr( 10 ) + "cd"
pTTY( @h, @buf, 5, -1 )
print "  LF, text mode:" : showEnd( h )

setup_( h, 5, 1 ) : resetLog( 0 )
buf = "ab" + chr( 10 ) + "cd"
pTTY( @h, @buf, 5, 0 )
print "  LF, graphics mode:" : showEnd( h )

'' TAB STOPS ARE RELATIVE TO THE LEFT BORDER, and always advance by 1 to 8.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = chr( 9 ) + "x" + chr( 9 ) + "y"
pTTY( @h, @buf, 4, -1 )
print "  tabs from column 1:" : showEnd( h )

setup_( h, 8, 1 ) : resetLog( 0 )
buf = chr( 9 ) + "x"
pTTY( @h, @buf, 2, -1 )
print "  tab from column 8:" : showEnd( h )

setup_( h, 9, 1 ) : resetLog( 0 )
buf = chr( 9 ) + "x"
pTTY( @h, @buf, 2, -1 )
print "  tab from column 9:" : showEnd( h )

'' BACKSPACE AT THE LEFT BORDER MOVES NOTHING and still flushes.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "ab" + chr( 8 ) + "c"
pTTY( @h, @buf, 4, -1 )
print "  backspace mid-line:" : showEnd( h )

setup_( h, 1, 1 ) : resetLog( 0 )
buf = chr( 8 ) + "c"
pTTY( @h, @buf, 2, -1 )
print "  backspace at the left border:" : showEnd( h )

'' A LONE CR ON THE BOTTOM ROW draws nothing but must still be able to scroll --
'' the `elseif fGotNewCoordinate` branch, which is the only path that reaches
'' the scroll check with an empty buffer.
setup_( h, 1, 4 ) : resetLog( 0 )
buf = chr( 10 )
pTTY( @h, @buf, 1, -1 )
print "  a lone LF on the bottom row:" : showEnd( h )

'' WRAP INSIDE TTY: the column arithmetic is done by TTY and the drawing by RAW,
'' so a batch crossing three lines must still come out in RAW-sized runs.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "1234567890123456789012345678901234567890abcde"
pTTY( @h, @buf, 45, -1 )
print "  45 characters over a 20-wide border:" : showEnd( h )

'' A ZERO-WIDTH BORDER RETURNS IMMEDIATELY rather than dividing by zero.
setup_( h, 1, 1 ) : resetLog( 0 )
h.Border.L_ = 5 : h.Border.R_ = 4
buf = "anything"
pTTY( @h, @buf, 8, -1 )
print "  zero-width border:" : showEnd( h )

'' BELL IS NOT DRAWN. It calls fb_Beep and contributes nothing to the buffer --
'' and does NOT flush, so the text around it stays in one write.
setup_( h, 1, 1 ) : resetLog( 0 )
buf = "a" + chr( 7 ) + "b"
pTTY( @h, @buf, 3, -1 )
print "  bell between two letters:" : showEnd( h )

'' ------------------------------------------------------------------ WIDE

print "-- the wide forms"

dim shared as wstring * 64 wbuf

setup_( h, 1, 1 ) : resetLog( -1 )
wbuf = wstr( "hello" )
pRawW( @h, @wbuf, 5 )
print "  RawWstr, short:" : showEnd( h )

setup_( h, 1, 1 ) : resetLog( -1 )
wbuf = wstr( "1234567890123456789012345" )
pRawW( @h, @wbuf, 25 )
print "  RawWstr, one and a bit lines:" : showEnd( h )

'' THE WIDE TTY MUST BEHAVE IDENTICALLY to the narrow one, character for
'' character -- the element width is the Write hook's business, not the
'' interpreter's.
setup_( h, 5, 1 ) : resetLog( -1 )
wbuf = wstr( "ab" ) + wchr( 10 ) + wstr( "cd" )
pTTYW( @h, @wbuf, 5, -1 )
print "  TTYWstr, LF in text mode:" : showEnd( h )

setup_( h, 1, 1 ) : resetLog( -1 )
wbuf = wchr( 9 ) + wstr( "x" ) + wchr( 9 ) + wstr( "y" )
pTTYW( @h, @wbuf, 4, -1 )
print "  TTYWstr, tabs from column 1:" : showEnd( h )

print "done"
