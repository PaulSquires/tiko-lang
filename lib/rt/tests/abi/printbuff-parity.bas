'' printbuff-parity.bas -- the console print buffer, narrow and wide. Five
'' symbols on Windows, four on POSIX, across two fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THIS BATCH IS THE RARE ONE THAT CAN ACTUALLY BE CALLED, and the reason is
'' that the differential harness REDIRECTS STDOUT. Every one of these entry
'' points opens with a redirection check -- an empty console window rect on
'' Windows, an uninitialised console on POSIX -- and takes a raw-write path that
'' touches no cells, moves no cursor and needs no terminal. So the harness runs
'' the branch a real console never would, and it is the branch whose output can
'' be compared byte for byte.
''
'' WHAT THAT DOES **NOT** COVER, stated plainly because the pass looks stronger
'' than it is:
''
''   the cell path        WriteConsoleOutput, the scroll hook, the VIEW PRINT
''                        region, fb_ConPrintTTY's wrapping -- none of it runs
''                        here. It runs under fbc's own suite, which is where
''                        this batch's real evidence comes from.
''   the UTF-16 stream    fb_hConsoleStreamOutW returns FALSE immediately when
''                        GetConsoleScreenBufferInfo fails, which is what a
''                        redirected handle does. It is CALLED below and its
''                        refusal is compared; the WriteConsoleW loop is not.
''   scrollWasOff         the deferred scroll lives in __fb_con and only the
''                        cell path sets it.
''
'' THE WIDE ENTRY POINTS EMIT RAW CODE UNITS when redirected -- UTF-16LE on
'' Windows, UTF-32LE on POSIX, no BOM, no conversion. That is deliberate on
'' fbc's part (its own source marks the POSIX half a FIXME and leaves it), so
'' the bytes below are binary and are meant to be. Diffing them is the test.

#include once "fbc-int/string.bi"

const FB_PRINT_FORCE_ADJUST_ = 8

extern "c"
	declare sub pPrintEx alias "fb_ConsolePrintBufferEx" _
		( byval buffer as any ptr, byval length_ as uinteger, byval mask as long )
	declare sub pPrint alias "fb_ConsolePrintBuffer" _
		( byval buffer as zstring ptr, byval mask as long )
	declare sub pPrintWEx alias "fb_ConsolePrintBufferWstrEx" _
		( byval buffer as wstring ptr, byval chars as uinteger, byval mask as long )
	declare sub pPrintW alias "fb_ConsolePrintBufferWstr" _
		( byval buffer as wstring ptr, byval mask as long )
	#ifdef __FB_WIN32__
		declare function pStreamW alias "fb_hConsoleStreamOutW" _
			( byval text as wstring ptr, byval chars as uinteger ) as long
	#endif
end extern

print "-- resolution"
dim shared as any ptr a5( 0 to 4 )
a5(0) = cast( any ptr, @pPrintEx )
a5(1) = cast( any ptr, @pPrint )
a5(2) = cast( any ptr, @pPrintWEx )
a5(3) = cast( any ptr, @pPrintW )
#ifdef __FB_WIN32__
	a5(4) = cast( any ptr, @pStreamW )
#else
	a5(4) = cast( any ptr, @pPrintEx )   '' POSIX has no stream path at all
#endif
dim as long n = 0
for i as integer = 0 to 4
	if( a5(i) <> 0 ) then n += 1
next
print "  count="; n

'' ------------------------------------------------ fb_hConsoleStreamOutW
''
'' WINDOWS ONLY, and it must REFUSE here: the screen-buffer query fails on a
'' redirected handle, so the very first guard returns FALSE. The two NULL/zero
'' guards ahead of it are checked as well, because they are the cheap ones a
'' rewrite would be tempted to drop.

#ifdef __FB_WIN32__
	print "-- fb_hConsoleStreamOutW (must refuse: redirected)"
	dim shared as wstring * 8 wprobe
	wprobe = wstr( "hi" )
	print "  (NULL, 3)      -> "; pStreamW( 0, 3 )
	print "  (text, 0)      -> "; pStreamW( @wprobe, 0 )
	print "  (text, 2)      -> "; pStreamW( @wprobe, 2 )
#else
	print "-- fb_hConsoleStreamOutW: absent on POSIX, nothing to call"
#endif

'' ------------------------------------------------ the narrow entry points
''
'' EVERY BYTE BELOW REACHES STDOUT. The markers are ordinary PRINTs and the
'' payloads are the calls, so the interleaving is part of what is compared: a
'' runtime that buffered differently would show up as a reordering rather than
'' as a wrong byte.

dim shared as zstring * 32 z
z = "abc"

print "-- fb_ConsolePrintBufferEx"
print "  [1] len 3:";
pPrintEx( @z, 3, 0 )
print ""

'' ZERO LENGTH WITHOUT THE FLAG IS A NO-OP, and with the flag it is the
'' deferred-scroll settle -- which on a redirected handle writes nothing either.
'' Both are silent; printing the markers is what proves neither emitted a byte.
print "  [2] len 0, mask 0:";
pPrintEx( @z, 0, 0 )
print "|"
print "  [3] len 0, FORCE_ADJUST:";
pPrintEx( @z, 0, FB_PRINT_FORCE_ADJUST_ )
print "|"
print "  [4] NULL, len 0, FORCE_ADJUST:";
pPrintEx( 0, 0, FB_PRINT_FORCE_ADJUST_ )
print "|"

'' AN EMBEDDED NUL SURVIVES the *Ex form -- the length is given, not measured.
z = "a" + chr(0) + "b"
print "  [5] embedded NUL, len 3:";
pPrintEx( @z, 3, 0 )
print "|"

'' A LONG RUN, to cross whatever internal buffer either implementation keeps.
dim shared as zstring * 600 zlong
for i as integer = 0 to 598
	zlong[i] = asc( "0" ) + (i mod 10)
next
zlong[599] = 0
print "  [6] 599 bytes:";
pPrintEx( @zlong, 599, 0 )
print "|"

print "-- fb_ConsolePrintBuffer (length from strlen)"
z = "a" + chr(0) + "b"
print "  [7] strlen stops at the NUL:";
pPrint( @z, 0 )
print "|"

'' ------------------------------------------------ the wide entry points
''
'' RAW CODE UNITS, not text -- see the file header. The byte width differs per
'' platform and that is the contract, not a defect.

print "-- fb_ConsolePrintBufferWstrEx (raw code units when redirected)"
dim shared as wstring * 16 w
w = wstr( "wxy" )
print "  [8] chars 3:";
pPrintWEx( @w, 3, 0 )
print "|"
print "  [9] chars 0:";
pPrintWEx( @w, 0, 0 )
print "|"
print "  [10] chars 0, FORCE_ADJUST:";
pPrintWEx( @w, 0, FB_PRINT_FORCE_ADJUST_ )
print "|"

'' NON-ASCII, so the code-unit width is visible in the bytes rather than hidden
'' by every high byte being zero. BUILT NUMERICALLY, not written as a literal:
'' a non-ASCII literal makes the test depend on how the compiler decided to read
'' this source file's encoding, and that is a different question from the one
'' being asked here.
w[0] = &h00E9   '' LATIN SMALL LETTER E WITH ACUTE
w[1] = &h4E2D   '' CJK: two cells wide on a real console, one code unit here
w[2] = 0
print "  [11] U+00E9 U+4E2D:";
pPrintWEx( @w, 2, 0 )
print "|"

print "-- fb_ConsolePrintBufferWstr (length counted to the NUL)"
w = wstr( "wxy" )
print "  [12]:";
pPrintW( @w, 0 )
print "|"

print "done"
