'' conlineinp-parity.bas -- LOCATE's return value, POS, INPUT and the two console
'' LINE INPUTs. Five entry points across five fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE THREE READING ENTRY POINTS ARE TAKEN BY ADDRESS AND NEVER CALLED. Under
'' the differential harness stdin is not a terminal, and every one of
'' fb_ConsoleInput, fb_ConsoleLineInput and fb_ConsoleLineInputWstr ends in a
'' blocking read -- fb_ConReadLine on Windows edits a line against a console that
'' is not there. A test that blocks is a test that hangs the whole run, which
'' lprint-parity already did once.
''
'' WHAT IS DRIVEN IS fb_Locate AND fb_Pos, which only move and report the cursor,
'' plus every behavioural fact about the other three that can be established
'' WITHOUT reading: that they link, that they are distinct, and that
'' fb_ConsoleInput's redirected branch -- which does NOT block, because the
'' harness redirects stdin -- returns what fb_FileInput returns.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pLocate   alias "fb_Locate" _
		( byval r as long, byval c as long, byval cur as long, _
		  byval st as long, byval sp as long ) as long
	declare function pPos      alias "fb_Pos" ( byval dummy as long ) as long
	declare function pConInput alias "fb_ConsoleInput" _
		( byval t as any ptr, byval q as long, byval nl as long ) as long
end extern

extern "c"
	declare function pConLineIn alias "fb_ConsoleLineInput" _
		( byval t as any ptr, byval d as any ptr, byval dl as integer, _
		  byval fr as long, byval q as long, byval nl as long ) as long
	declare function pConLineInW alias "fb_ConsoleLineInputWstr" _
		( byval t as wstring ptr, byval d as wstring ptr, byval mc as integer, _
		  byval q as long, byval nl as long ) as long
end extern

dim shared as any ptr addrs( 0 to 4 )
addrs(0) = cast( any ptr, @pLocate )
addrs(1) = cast( any ptr, @pPos )
addrs(2) = cast( any ptr, @pConInput )
addrs(3) = cast( any ptr, @pConLineIn )
addrs(4) = cast( any ptr, @pConLineInW )

dim as long n = 0, distinct = 1
for i as integer = 0 to 4
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every entry point resolves"
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------------------ POS

'' POS IGNORES ITS ARGUMENT -- every value must give the same answer, and that
'' answer must be fb_GetX's.
print "-- POS ignores its argument"
dim as long p0 = pPos( 0 )
dim as long p1 = pPos( 1 )
dim as long p99 = pPos( 99 )
dim as long pneg = pPos( -5 )
print "  all four agree="; ( (p0 = p1) andalso (p1 = p99) andalso (p99 = pneg) )
print "  and it equals CSRLIN's column partner="; ( p0 = pos( 0 ) )

'' ------------------------------------------------------------------ LOCATE

'' THE RETURN IS THE OLD POSITION, PACKED. fbc packs the previous row and column
'' into one int, so the value is compared as a NUMBER -- and the important part
'' is that a REJECTED locate still returns a position rather than an error.
print "-- LOCATE returns the previous position"

'' Under redirection the console has no real geometry, so the absolute numbers
'' are whatever the runtime's defaults are -- but they must be the SAME
'' defaults, and the relationships below hold either way.
dim as long r1 = pLocate( 1, 1, -1, 0, 0 )
dim as long r2 = pLocate( 2, 3, -1, 0, 0 )
dim as long r3 = pLocate( 0, 0, -1, 0, 0 )
print "  after locate(1,1) -> "; r1
print "  after locate(2,3) -> "; r2
print "  after locate(0,0) -> "; r3
print "  err="; err

'' A REJECTED LOCATE STILL ANSWERS. Row 9999 is out of range on any console, and
'' the second fb_LocateEx call is what produces the return -- so the value must
'' be a position, not zero and not an error code.
dim as long before = pLocate( 0, 0, -1, 0, 0 )
dim as long bad_ = pLocate( 9999, 9999, -1, 0, 0 )
dim as long ebad = err
dim as long after_ = pLocate( 0, 0, -1, 0, 0 )
print "  a rejected locate returns a position="; ( bad_ = before )
print "  and did not move the cursor="; ( after_ = before )
print "  err from it="; ebad

'' start and stop ARE ACCEPTED AND IGNORED -- QBASIC's cursor-shape parameters,
'' which fbc does not implement. Passing anything must change nothing.
dim as long s0 = pLocate( 1, 1, -1, 0, 0 )
dim as long s1 = pLocate( 1, 1, -1, 7, 7 )
dim as long s2 = pLocate( 1, 1, -1, -1, -1 )
print "  start/stop ignored="; ( (s0 = s1) andalso (s1 = s2) )

'' cursor = 0 hides, 1 shows, -1 leaves alone. None of the three may change the
'' RETURNED position.
dim as long c0 = pLocate( 2, 2, 0, 0, 0 )
dim as long c1 = pLocate( 2, 2, 1, 0, 0 )
dim as long c2 = pLocate( 2, 2, -1, 0, 0 )
print "  cursor flag does not disturb the position="; ( (c0 = c1) andalso (c1 = c2) )

'' AND LOCATE AGREES WITH POS AND CSRLIN. Moving to a known column and reading it
'' back is the check that the packed return and the live cursor are the same
'' thing.
pLocate( 3, 5, -1, 0, 0 )
print "  after locate(3,5): pos="; pPos( 0 ); " csrlin="; csrlin

'' ------------------------------------------------------------ INPUT, redirected

'' THIS ONE CAN BE CALLED. The harness redirects stdin, so fb_ConsoleInput takes
'' its redirected branch -- it deletes the prompt and hands over to
'' fb_FileInput( 0 ), which does not block. What comes back is fb_FileInput's
'' return for the SCREEN handle.
print "-- fb_ConsoleInput, redirected"
dim as string prompt_ = "prompt"
print "  with a prompt   -> "; pConInput( @prompt_, -1, -1 )
print "  with no prompt  -> "; pConInput( 0, 0, 0 )
print "  err="; err

print "done"
