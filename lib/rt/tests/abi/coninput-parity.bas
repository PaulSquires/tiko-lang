'' coninput-parity.bas -- the Windows console input trio, the multikey table and
'' the console mouse. Seven symbols across three fbc members.
''
'' NEEDS-GEN-LLVM
''
'' EXACTLY ONE OF THE SEVEN CAN BE CALLED SAFELY, and it is the one that reads no
'' hardware: fb_hVirtualToScancode is a pure lookup over the keytable, so the
'' whole table is swept below. Everything else is proved by address, for reasons
'' that differ per entry point and are worth stating individually rather than as
'' one blanket excuse:
''
''   fb_ConsoleInkey    calls fb_hConsoleGetKey, which CONSUMES a keystroke from
''                      the console queue. Under a harness there is no console
''                      and it returns -1, but the call also expects the caller
''                      to already hold the I/O lock -- which this test has no
''                      way to take.
''   fb_ConsoleGetkey   BLOCKS UNTIL A KEY IS PRESSED. It would hang the suite
''                      exactly as fb_ConsoleReadStr did in batch1-parity, which
''                      cost twenty minutes before it was found.
''   fb_ConsoleKeyHit   peeks rather than consumes, so it is the least dangerous
''                      of the three -- but it too wants the lock held.
''   fb_ConsoleMultikey calls fb_ConsoleProcessEvents, which PUMPS THE CONSOLE
''                      EVENT QUEUE. Draining events the harness did not put
''                      there is a side effect on a shared resource.
''   fb_ConsoleGetMouse INSTALLS A HOOK into __fb_con and TURNS QUICK-EDIT MODE
''                      OFF for the console the harness is running in. That
''                      change outlives the test.
''   fb_ConsoleSetMouse always fails, and is the one exception -- calling it is
''                      free, so it is called.
''
'' THE TABLE SWEEP IS THE REAL TEST. fb_hVirtualToScancode maps a virtual key to
'' a scancode by searching 87 rows, and the search checks the SECOND column
'' before the first. Several virtual keys appear in both columns of different
'' rows -- VK_SHIFT is column 1 of two rows, the keypad codes are column 2 of
'' ten -- so the order decides which scancode wins. Sweeping every vkey from 0 to
'' 255 pins the whole mapping including those collisions, which a sample of
'' plausible keys would not.

#include once "fbc-int/string.bi"

extern "c"
	declare function pVk2Sc alias "fb_hVirtualToScancode" ( byval vk as long ) as long
	declare function pInkey alias "fb_ConsoleInkey" ( ) as any ptr
	declare function pGetkey alias "fb_ConsoleGetkey" ( ) as long
	declare function pKeyHit alias "fb_ConsoleKeyHit" ( ) as long
	declare function pMultikey alias "fb_ConsoleMultikey" ( byval sc as long ) as long
	declare function pGetMouse alias "fb_ConsoleGetMouse" _
		( byval x as long ptr, byval y as long ptr, byval z as long ptr, _
		  byval b as long ptr, byval c as long ptr ) as long
	declare function pSetMouse alias "fb_ConsoleSetMouse" _
		( byval x as long, byval y as long, byval cur as long, byval clip as long ) as long
end extern

print "-- resolution"
dim shared as any ptr a7( 0 to 6 )
a7(0) = cast( any ptr, @pVk2Sc )   : a7(1) = cast( any ptr, @pInkey )
a7(2) = cast( any ptr, @pGetkey )  : a7(3) = cast( any ptr, @pKeyHit )
a7(4) = cast( any ptr, @pMultikey ): a7(5) = cast( any ptr, @pGetMouse )
a7(6) = cast( any ptr, @pSetMouse )
dim as long n = 0, distinct = 1
for i as integer = 0 to 6
	if( a7(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a7(i) = a7(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct
print "  five of seven are ADDRESS ONLY -- see the file header for which and why"

'' ------------------------------------------- fb_hVirtualToScancode

'' EVERY VIRTUAL KEY, 0 to 255 -- see the file header on why the collisions
'' matter and a sample would miss them.
print "-- fb_hVirtualToScancode, full sweep 0..255"
dim as long mapped = 0
for vk as long = 0 to 255
	dim as long sc = pVk2Sc( vk )
	if( sc <> 0 ) then
		mapped += 1
		print "  vk="; hex( vk, 2 ); " -> sc="; hex( sc, 2 )
	end if
next
print "  mapped="; mapped; " of 256"

'' THE COLLISIONS, ASKED FOR BY NAME so a change in search order shows up as a
'' one-line diff rather than being buried in the sweep above.
''   VK_SHIFT   (0x10) is column 1 of BOTH SC_LSHIFT (0x2A) and SC_RSHIFT (0x36)
''   VK_NUMPAD7 (0x67) is column 2 of SC_HOME (0x47)
''   VK_NUMPAD5 (0x65) is column 1 of SC_CLEAR (0x4C)
''   VK_DIVIDE  (0x6F) is column 2 of SC_SLASH (0x35)
print "  VK_SHIFT   0x10 -> "; hex( pVk2Sc( &h10 ), 2 ); "  (first of two rows wins)"
print "  VK_NUMPAD7 0x67 -> "; hex( pVk2Sc( &h67 ), 2 ); "  (column 2 of SC_HOME)"
print "  VK_NUMPAD5 0x65 -> "; hex( pVk2Sc( &h65 ), 2 ); "  (column 1 of SC_CLEAR)"
print "  VK_DIVIDE  0x6F -> "; hex( pVk2Sc( &h6F ), 2 ); "  (column 2 of SC_SLASH)"
print "  VK_SUBTRACT 0x6D -> "; hex( pVk2Sc( &h6D ), 2 ); " (column 2 of SC_MINUS)"

'' ZERO RETURNS SC_ESCAPE (1), NOT ZERO -- and that is not the terminator being
'' matched. Every row without a keypad alternate has 0 in column 2, and the
'' search tests column 2 first, so row 0 answers immediately. Surprising, fbc
'' does it too, and printing it is what keeps it from being 'fixed' later.
print "  vk=0   -> "; pVk2Sc( 0 ); "   (SC_ESCAPE: row 0 matches on column 2)"
print "  vk=-1  -> "; pVk2Sc( -1 )
print "  vk=256 -> "; pVk2Sc( 256 )
print "  vk=0x7FFFFFFF -> "; pVk2Sc( &h7FFFFFFF )

'' ------------------------------------------------------ fb_ConsoleSetMouse

'' THE ONE ENTRY POINT THAT IS FREE TO CALL: it always fails, touches nothing,
'' and returns the error code unconditionally.
print "-- fb_ConsoleSetMouse (always fails; safe to call)"
print "  (0,0,0,0)     -> "; pSetMouse( 0, 0, 0, 0 )
print "  (10,20,1,0)   -> "; pSetMouse( 10, 20, 1, 0 )
print "  (-1,-1,-1,-1) -> "; pSetMouse( -1, -1, -1, -1 )

print "done"
