'' conattr-parity.bas -- LOCATE, COLOR, CLS, VIEW PRINT and console scrolling.
'' Twelve entry points on Windows and eight on POSIX, across six fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THIS RUNS REDIRECTED, so none of these statements reaches a console. That is
'' not a weakness here -- it is the half of the contract that is hardest to get
'' right and easiest to get wrong silently, because every one of these entry
'' points has to DECIDE that there is nothing to do and return the documented
'' value anyway. A version that skipped the bookkeeping and returned garbage
'' would look fine on a terminal and fail here.
''
'' WHAT IS ASSERTED IS THE RETURN VALUE AND THE STATE, not the screen. COLOR
'' returns the pair it replaced; LOCATE returns the position and cursor
'' visibility it replaced, packed; VIEW PRINT returns its own packed pair and
'' zero when the range is rejected. All three are pure arithmetic over remembered
'' state and are identical on a terminal and on a pipe.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - COLOR returns the PREVIOUS pair, packed fg | (bg << 16) -- not the new one
''   - COLOR with the DEFAULT flags leaves that half alone AND still returns the
''     old value for it
''   - only the low four bits of each colour are kept
''   - VIEW PRINT with a negative argument QUERIES rather than sets
''   - an out-of-range VIEW PRINT returns 0 and leaves the window untouched, so
''     the next query still reports the old one
''   - CLS mode 1 is a no-op, and &hFFFF0000 is a synonym for 2

extern "rtlib"
	declare function pView    alias "fb_ConsoleView"       ( byval t as long, byval b as long ) as long
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	declare sub      pLocRaw  alias "fb_ConsoleLocateRaw"  ( byval r as long, byval c as long, byval cur as long )
#endif
end extern

extern "c"   '' NON-FBCALL: undecorated in fbc's archive.
	declare function pColor    alias "fb_ConsoleColor"        ( byval f as ulong, byval b as ulong, byval fl as long ) as ulong
	declare function pGetAtt   alias "fb_ConsoleGetColorAtt"  ( ) as ulong
	declare function pLocate   alias "fb_ConsoleLocate"       ( byval r as long, byval c as long, byval cur as long ) as long
	declare sub      pCls      alias "fb_ConsoleClear"        ( byval m as long )
	declare sub      pScroll   alias "fb_ConsoleScroll"       ( byval n as long )
	declare function pViewEx   alias "fb_ConsoleViewEx"       ( byval t as long, byval b as long, byval sc as long ) as long
	declare sub      pViewUpd  alias "fb_ConsoleViewUpdate"   ( )
	declare sub      pGetView  alias "fb_ConsoleGetView"      ( byval t as long ptr, byval b as long ptr )
	declare function pTopRow   alias "fb_ConsoleGetTopRow"    ( ) as long
	declare function pBotRow   alias "fb_ConsoleGetBotRow"    ( ) as long
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	declare function pGetAttEx alias "fb_ConsoleGetColorAttEx" ( byval h as any ptr ) as ulong
	declare sub      pClearRaw alias "fb_ConsoleClearViewRawEx" _
		( byval h as any ptr, byval x1 as long, byval y1 as long, byval x2 as long, byval y2 as long )
	declare sub      pLocRawEx alias "fb_ConsoleLocateRawEx" _
		( byval h as any ptr, byval r as long, byval c as long, byval cur as long )
#endif
end extern

const FG_DEFAULT = 1
const BG_DEFAULT = 2

dim as ulong prev = any
dim as long t = any, b = any, rc = any

print "-- COLOR returns the pair it replaced"
'' Set a known pair first, so the first assertion does not depend on whatever the
'' console started with.
pColor( 7, 0, 0 )
prev = pColor( 3, 5, 0 )
print "  previous fg="; (prev and &hFFFF); " bg="; ((prev shr 16) and &hFFFF)
prev = pColor( 9, 2, 0 )
print "  previous fg="; (prev and &hFFFF); " bg="; ((prev shr 16) and &hFFFF)

print "-- only the low four bits are kept"
prev = pColor( &hFF, &hF0, 0 )
print "  previous fg="; (prev and &hFFFF); " bg="; ((prev shr 16) and &hFFFF)
prev = pColor( 1, 1, 0 )
print "  masked fg="; (prev and &hFFFF); " bg="; ((prev shr 16) and &hFFFF)

print "-- the DEFAULT flags leave that half alone"
pColor( 4, 6, 0 )
prev = pColor( 12, 13, FG_DEFAULT )
print "  fg kept, previous="; (prev and &hFFFF); " "; ((prev shr 16) and &hFFFF)
prev = pColor( 12, 13, BG_DEFAULT )
print "  bg kept, previous="; (prev and &hFFFF); " "; ((prev shr 16) and &hFFFF)
prev = pColor( 1, 2, FG_DEFAULT or BG_DEFAULT )
print "  both kept, previous="; (prev and &hFFFF); " "; ((prev shr 16) and &hFFFF)
prev = pColor( 0, 0, 0 )
print "  settled="; (prev and &hFFFF); " "; ((prev shr 16) and &hFFFF)

print "-- the attribute query is in range"
print "  attr<=&hFFFF="; iif( pGetAtt( ) <= &hFFFF, 1, 0 )

print "-- LOCATE returns the position and cursor it replaced"
'' THE CURSOR BIT IS NOT ASSERTED, ONLY ITS RANGE, and that is a statement
'' about fbc rather than about this test. GetConsoleCursorInfo FAILS on a
'' redirected handle and fbc reads the local it never filled, so the bit is
'' whatever was on fbc's stack -- 1 on the run that first exposed this, 0 from
'' tiko-rt, and neither is a value. tiko-rt zeroes the buffer so ITS answer is
'' at least defined; a differential cannot compare against something that is not.
rc = pLocate( 1, 1, 1 )
print "  col="; (rc and &hFF); " row="; ((rc shr 8) and &hFF); _
      " visible in range="; iif( ((rc and (not &h10000)) and &hFFFF0000) = 0, 1, 0 )
rc = pLocate( 5, 10, -1 )
print "  col="; (rc and &hFF); " row="; ((rc shr 8) and &hFF)
'' A row or column below 1 means "keep it", so this asks for the current one.
rc = pLocate( 0, 0, -1 )
print "  keep both="; (rc and &hFF); " "; ((rc shr 8) and &hFF)
rc = pLocate( -1, -1, -1 )
print "  negative too="; (rc and &hFF); " "; ((rc shr 8) and &hFF)

print "-- VIEW PRINT"
pGetView( @t, @b )
print "  initial top="; t; " bot="; b
rc = pViewEx( 3, 10, 0 )
print "  set 3..10 -> top="; (rc and &hFFFF); " bot="; ((rc shr 16) and &hFFFF)
pGetView( @t, @b )
print "  now top="; t; " bot="; b; " (0-based "; pTopRow( ); ".."; pBotRow( ); ")"

'' A negative argument QUERIES: neither row changes.
rc = pViewEx( -1, -1, 0 )
print "  query -> top="; (rc and &hFFFF); " bot="; ((rc shr 16) and &hFFFF)
pGetView( @t, @b )
print "  unchanged top="; t; " bot="; b

'' Out of range is rejected by ZEROING both rows, and the window is untouched.
rc = pViewEx( 10, 3, 0 )
print "  inverted -> "; rc
rc = pViewEx( 0, 30000, 0 )
print "  too tall -> "; rc
rc = pViewEx( -30000, -1, 0 )
print "  absurd -> "; rc
pGetView( @t, @b )
print "  still top="; t; " bot="; b

'' 0 means "the extreme": row 1 and the last row.
rc = pView( 0, 0 )
print "  full -> top="; (rc and &hFFFF); " bot>0="; iif( ((rc shr 16) and &hFFFF) > 0, 1, 0 )
pViewUpd( )
print "  update survived"

print "-- CLS"
pCls( 1 )
print "  mode 1 is a no-op"
pCls( 2 )
print "  mode 2 survived"
pCls( 0 )
print "  mode 0 survived"
pCls( cast( long, &hFFFF0000ul ) )
print "  DEFAULT_COLOR survived"

print "-- SCROLL"
pScroll( 0 )
pScroll( -5 )
print "  non-positive is a no-op"
pScroll( 1 )
pScroll( 30000 )
print "  positive survived"

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
print "-- the Windows raw entry points"
print "  attEx<=&hFFFF="; iif( pGetAttEx( 0 ) <= &hFFFF, 1, 0 )
pLocRaw( 0, 0, -1 )
pLocRawEx( 0, -1, -1, -1 )
print "  raw locate survived"
'' A zero-width or zero-height rectangle returns without touching anything.
pClearRaw( 0, 5, 5, 4, 5 )
pClearRaw( 0, 5, 5, 5, 4 )
print "  degenerate rects survived"
#endif

'' Leave the console as it was found, so a later test in the same run is not
'' looking at a three-row window.
pView( 0, 0 )
pColor( 7, 0, 0 )
print "done"
