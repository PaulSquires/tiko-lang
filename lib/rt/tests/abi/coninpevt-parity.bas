'' coninpevt-parity.bas -- the console input event pump and the QB key
'' translation. Seven symbols on Windows, one on POSIX, one fbc member.
''
'' NEEDS-GEN-LLVM
''
'' ONE OF THE SEVEN IS A PURE FUNCTION AND THE OTHER SIX TOUCH THE CONSOLE.
'' fb_hConsoleTranslateKey reads no state, writes no state and calls only
'' MapVirtualKey -- so it is swept below across every column of both tables.
'' The rest are proved by address, and the reason differs per entry point:
''
''   fb_ConsoleProcessEvents   DRAINS the console input queue. Under the harness
''                             the queue belongs to whatever is running the
''                             suite; consuming from it is a side effect on a
''                             shared resource, not a read.
''   fb_hConsoleGetKey         calls ProcessEvents, then REMOVES an entry.
''   fb_hConsolePeekKey        calls ProcessEvents. Does not remove, but drains.
''   fb_hConsoleInputBufferChanged
''                             calls ProcessEvents and CLEARS the changed flag.
''   fb_hConsolePutBackEvents  WRITES records into the console's input queue.
''                             The harness would inherit them.
''   fb_ConsoleHasFocus        the one that is free to read -- and it is called.
''
'' ON POSIX ONLY fb_hConsoleInputBufferChanged EXISTS, and it is fb_KeyHit,
'' which goes through the INKEY hook and reads the terminal. Not called; its
'' address is checked and that is all this platform offers.
''
'' THE SWEEP IS THE REAL TEST, and it is built to hit the parts of the
'' translation that a plausible sample would miss:
''
''   BOTH TABLES, EVERY COLUMN. Four modifier states x 256 scan codes covers the
''   89-row table's every row including the zero rows, and the twelve-row
''   enhanced table is swept separately because it needs ENHANCED_KEY set AND a
''   zero ASCII character to be reached at all.
''
''   THE BOUNDS TEST AT 89. Scan codes 88 and 89 straddle the end of the table,
''   and 89 is the first that falls through to the "ASCII is itself" rule. A
''   table one row short would still answer for 88 and would change 89 -- so
''   both are asked for by name.
''
''   THE AltGr RULE. A code above 255 is accepted only when the ASCII the
''   console reported matches what the layout says the key produces. Passing a
''   deliberately MISMATCHED ASCII with an ALT modifier is what exercises the
''   refusal, and it is the branch that keeps AltGr+Q printing '@' on a German
''   keyboard instead of being eaten.
''
''   THE ZERO COLUMN. In the enhanced table a zero in the alt/ctrl/shift column
''   means "no key" and returns -1, but a zero in the NORMAL column is still
''   posted. Scan code 0x1C's four columns are printed to pin that asymmetry.
''
'' MapVirtualKey DEPENDS ON THE ACTIVE KEYBOARD LAYOUT, so the sweep's exact
'' values are a property of this machine -- but BOTH SIDES run on it at the same
'' moment, which is the only thing a differential needs. What it cannot do is
'' serve as a golden file on another machine, and that is why the output is
'' compared rather than asserted.

#include once "fbc-int/string.bi"

const ENHANCED_KEY_       = &h0100
const SHIFT_PRESSED_      = &h0010
const LEFT_CTRL_PRESSED_  = &h0008
const LEFT_ALT_PRESSED_   = &h0002

extern "c"
	#ifdef __FB_WIN32__
		declare function pTranslate alias "fb_hConsoleTranslateKey" _
			( byval AsciiChar as byte, byval wVsCode as ushort, byval wVkCode as ushort, _
			  byval dwControlKeyState as ulong, byval bEnhancedKeysOnly as long ) as long
		declare function pProcess alias "fb_ConsoleProcessEvents" ( ) as long
		declare function pGetKey alias "fb_hConsoleGetKey" ( byval full as long ) as long
		declare function pPeekKey alias "fb_hConsolePeekKey" ( byval full as long ) as long
		declare sub pPutBack alias "fb_hConsolePutBackEvents" ( )
		declare function pHasFocus alias "fb_ConsoleHasFocus" ( ) as long
	#endif
	declare function pChanged alias "fb_hConsoleInputBufferChanged" ( ) as long
end extern

print "-- resolution"
#ifdef __FB_WIN32__
	dim shared as any ptr a7( 0 to 6 )
	a7(0) = cast( any ptr, @pTranslate ) : a7(1) = cast( any ptr, @pProcess )
	a7(2) = cast( any ptr, @pGetKey )    : a7(3) = cast( any ptr, @pPeekKey )
	a7(4) = cast( any ptr, @pPutBack )   : a7(5) = cast( any ptr, @pHasFocus )
	a7(6) = cast( any ptr, @pChanged )
	dim as long n = 0, distinct = 1
	for i as integer = 0 to 6
		if( a7(i) <> 0 ) then n += 1
		for j as integer = 0 to i - 1
			if( a7(i) = a7(j) ) then distinct = 0
		next
	next
	print "  count="; n; " distinct="; distinct
	print "  six of seven are ADDRESS ONLY -- see the file header for which and why"
#else
	print "  count="; iif( cast( any ptr, @pChanged ) <> 0, 1, 0 )
	print "  POSIX has one symbol here and it reads the terminal -- address only"
#endif

#ifdef __FB_WIN32__

'' -------------------------------------------------- fb_ConsoleHasFocus
''
'' Reads one file-local int that only a FOCUS_EVENT changes, and no event has
'' been pumped. It must be the initial value, and the initial value is TRUE --
'' a program whose console it did not create never sees a focus event and must
'' not report itself unfocused.
print "-- fb_ConsoleHasFocus (initial value, no events pumped)"
print "  "; pHasFocus( )

'' -------------------------------------------- fb_hConsoleTranslateKey
''
'' THE ENHANCED TABLE. Reached only with ENHANCED_KEY set and AsciiChar 0.
print "-- enhanced table: all 12 rows x 4 modifier states"
dim shared as ushort escans( 0 to 11 ) = { _
	&h001C, &h0035, &h0047, &h0048, &h0049, &h004B, _
	&h004D, &h004F, &h0050, &h0051, &h0052, &h0053 }
for i as integer = 0 to 11
	dim as ushort sc = escans(i)
	print "  sc="; hex( sc, 4 ); _
	      "  norm="; pTranslate( 0, sc, 0, ENHANCED_KEY_, 0 ); _
	      "  shift="; pTranslate( 0, sc, 0, ENHANCED_KEY_ or SHIFT_PRESSED_, 0 ); _
	      "  ctrl="; pTranslate( 0, sc, 0, ENHANCED_KEY_ or LEFT_CTRL_PRESSED_, 0 ); _
	      "  alt="; pTranslate( 0, sc, 0, ENHANCED_KEY_ or LEFT_ALT_PRESSED_, 0 )
next

'' A SCAN CODE THAT IS IN NO ROW falls out of the loop with AddKeyCode still
'' false and returns -1, even though ENHANCED_KEY was set.
print "  unmatched enhanced scan 0x0002 -> "; pTranslate( 0, &h0002, 0, ENHANCED_KEY_, 0 )

'' -------------------------------------------------------------------------
'' THE 89-ROW TABLE, every scan code and every modifier state. AsciiChar 0 so
'' the "ASCII is itself" fallback cannot mask a table miss.
print "-- ascii table: scan 0..255 x 4 modifier states, AsciiChar 0"
dim as long nonneg = 0
for sc as integer = 0 to 255
	dim as long a = pTranslate( 0, cast( ushort, sc ), 0, 0, 0 )
	dim as long b = pTranslate( 0, cast( ushort, sc ), 0, SHIFT_PRESSED_, 0 )
	dim as long c = pTranslate( 0, cast( ushort, sc ), 0, LEFT_CTRL_PRESSED_, 0 )
	dim as long d = pTranslate( 0, cast( ushort, sc ), 0, LEFT_ALT_PRESSED_, 0 )
	if( (a <> -1) orelse (b <> -1) orelse (c <> -1) orelse (d <> -1) ) then
		nonneg += 1
		print "  sc="; hex( sc, 2 ); " -> "; a; " "; b; " "; c; " "; d
	end if
next
print "  scan codes producing at least one key: "; nonneg; " of 256"

'' THE BOUNDS. 88 is the last row, 89 is the first past it. See the header.
print "  sc=88 (last row)        -> "; pTranslate( 0, 88, 0, 0, 0 )
print "  sc=89 (first past end)  -> "; pTranslate( 0, 89, 0, 0, 0 )
print "  sc=89 with AsciiChar 65 -> "; pTranslate( 65, 89, 0, 0, 0 )

'' A NON-ZERO ASCII IS ITSELF when the table does not produce an extended key.
print "-- the 'ASCII is itself' fallback"
print "  'A' sc=0   -> "; pTranslate( 65, 0, 0, 0, 0 )
print "  'A' sc=30  -> "; pTranslate( 65, 30, 0, 0, 0 )
print "  0xFF sc=0  -> "; pTranslate( -1, 0, 0, 0, 0 )   '' (char)255, sign-extended in C too

'' bEnhancedKeysOnly SUPPRESSES THAT FALLBACK, which is the whole reason the
'' parameter exists -- a caller that only wants function keys passes TRUE.
print "-- bEnhancedKeysOnly refuses the fallback"
print "  'A' sc=0, enhancedOnly=1 -> "; pTranslate( 65, 0, 0, 0, 1 )
print "  'A' sc=30, enhancedOnly=1 -> "; pTranslate( 65, 30, 0, 0, 1 )

'' THE AltGr RULE. An extended code is accepted only when the reported ASCII
'' agrees with the layout. A mismatched ASCII must be refused, and then fall
'' through to being itself.
print "-- the AltGr agreement rule"
for sc as integer = 16 to 25          '' the Q..P row, whose ALT column is 0x1000..0x1900
	print "  sc="; hex( sc, 2 ); _
	      "  alt+ascii0="; pTranslate( 0, cast( ushort, sc ), 0, LEFT_ALT_PRESSED_, 0 ); _
	      "  alt+ascii'@'="; pTranslate( 64, cast( ushort, sc ), 0, LEFT_ALT_PRESSED_, 0 )
next

'' THE VIRTUAL KEY CODE FEEDS MapVirtualKey, so it changes the answer even
'' though it does not index either table.
print "-- the virtual key code matters (it drives MapVirtualKey)"
for vk as integer = 0 to 4
	print "  vk="; vk; " sc=16 -> "; pTranslate( 0, 16, cast( ushort, vk ), 0, 0 )
next
print "  vk=0x51 ('Q') sc=16 -> "; pTranslate( 0, 16, &h51, 0, 0 )
print "  vk=0x51 ascii 'q'   -> "; pTranslate( 113, 16, &h51, 0, 0 )
print "  vk=0x51 ascii 'Q'   -> "; pTranslate( 81, 16, &h51, 0, 0 )

#endif

print "done"
