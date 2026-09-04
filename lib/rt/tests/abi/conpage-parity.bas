'' conpage-parity.bas -- console PAGES, WIDTH and the printer column. Five entry
'' points on Windows and four on POSIX, across four fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THIS RUNS REDIRECTED, which is the interesting case for all four. WIDTH must
'' report 0 rather than resizing something that is not a window; PageSet and
'' PageCopy must decide there is nothing to do rather than creating screen
'' buffers nobody will see; LPOS must answer for a printer that was never opened.
''
'' PAGES DO NOT EXIST ON POSIX AT ALL -- PageSet returns -1 and PageCopy raises
'' "illegal function call" -- so the two platforms print DIFFERENT numbers here,
'' and that is the contract rather than a divergence. Both runtimes are asked the
'' same question on the same platform, which is what the differential compares.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - WIDTH with no positive argument QUERIES and returns cols | (rows << 16);
''     with one it resizes and returns the size it was ASKED for
''   - a redirected console has no window, and WIDTH says 0 rather than a size
''   - PCOPY's two defaults are DIFFERENT: source is the ACTIVE page, destination
''     the VISIBLE one, which is what makes a bare PCOPY mean "show what I drew"
''   - PCOPY from a page to itself succeeds and does nothing
''   - LPOS of a printer index that was never opened is not a fault

extern "rtlib"
	declare function pLPos alias "fb_LPos" ( byval idx as long ) as long
end extern

extern "c"   '' NON-FBCALL: undecorated in fbc's archive.
	declare function pWidth    alias "fb_ConsoleWidth"    ( byval c as long, byval r as long ) as long
	declare function pPageSet  alias "fb_ConsolePageSet"  ( byval a as long, byval v as long ) as long
	declare function pPageCopy alias "fb_ConsolePageCopy" ( byval s as long, byval d as long ) as long
end extern

dim as long rc = any

print "-- WIDTH queries when nothing is asked for"
rc = pWidth( 0, 0 )
print "  query="; rc
print "  cols="; (rc and &hFFFF); " rows="; ((rc shr 16) and &hFFFF)
print "  negative also queries="; pWidth( -1, -1 )
print "  stable="; iif( pWidth( 0, 0 ) = rc, 1, 0 )

print "-- WIDTH with a size"
'' On a redirected console this must NOT resize anything; the return value is
'' still defined either way.
print "  80x25="; pWidth( 80, 25 )
print "  cols only="; pWidth( 80, 0 )
print "  rows only="; pWidth( 0, 25 )
print "  query after="; pWidth( 0, 0 )

'' THE PAGE STATE IS THE ONLY THING HERE THAT MOVES, so it is the only place a
'' stub returning 0 would be caught. PageSet returns the PREVIOUS pair packed
'' active | (visible << 8), so a set followed by a query has to report what was
'' set -- unless the buffer could not be created, which on a redirected console
'' is a real possibility and gives -1. Either answer is fine; the two runtimes
'' have to give the SAME one, and then the state has to follow.
print "-- pages"
dim as long p0 = pPageSet( -1, -1 )
print "  initial="; p0
dim as long p1 = pPageSet( 1, -1 )
print "  set active 1 -> previous="; p1
dim as long p2 = pPageSet( -1, -1 )
print "  query -> "; p2
print "  active became 1="; iif( (p1 = -1) orelse ((p2 and &hFF) = 1), 1, 0 )
print "  restore="; pPageSet( 0, 0 )
print "  settled="; pPageSet( -1, -1 )

print "  copy 0,0="; pPageCopy( 0, 0 )
print "  copy -1,-1="; pPageCopy( -1, -1 )
print "  copy 0,1="; pPageCopy( 0, 1 )
print "  copy 3,3="; pPageCopy( 3, 3 )

print "-- LPOS"
print "  0="; pLPos( 0 )
print "  1="; pLPos( 1 )
print "  7="; pLPos( 7 )

print "done"
