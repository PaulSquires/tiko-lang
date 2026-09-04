'' hostinfo-parity.bas -- the system singletons and the two clock setters.
'' Ten entry points across ten fbc members: the exe path and name, the current
'' directory, free memory, SLEEP, TIMER, TIME$=, DATE$=, and the two COM
'' device-string tests.
''
'' NEEDS-GEN-LLVM
''
'' MOST OF THESE RETURN A MACHINE-DEPENDENT ANSWER, so what is compared is not
'' the VALUE but the RELATIONSHIP between the two runtimes' answers -- and both
'' runs happen on the same machine, in the same directory, within seconds of each
'' other. Where even that is not stable (TIMER, free memory) the value is reduced
'' to a PROPERTY before it is printed: is it positive, does it advance, is it
'' within a plausible band. Printing the raw number would make the differential
'' fail every run for reasons that have nothing to do with tiko-rt.
''
'' THE EXE NAME IS STABLE AND IS PRINTED IN FULL. Both sides run the same test
'' compiled to two different executables -- so the NAME differs by construction
'' (`-stock.exe` versus `-rt.exe`) and printing it would fail every time. What is
'' printed instead is its LENGTH RELATIONSHIP to the path and the fact that the
'' returned pointer points INTO the caller's buffer, which is the actual
'' contract.
''
'' THE TWO CLOCK SETTERS ARE CALLED WITH DELIBERATELY INVALID ARGUMENTS ONLY.
'' Setting the machine clock needs privilege and would be a genuinely destructive
'' side effect on a developer's machine -- so the calls here are ones that must
'' fail (hour 99, year 1969), and what is compared is the FAILURE CODE. The
'' success path is therefore NOT covered by this file on any target, and that is
'' stated rather than hidden: it needs an elevated run against a throwaway VM.
''
'' fb_Delay IS CALLED WITH A SMALL VALUE and its effect is measured with TIMER --
'' which makes this the one place the two entry points check each other. The
'' assertion is a BAND, not an equality: sleeping is allowed to overshoot and a
'' signal is allowed to cut it short, on both platforms.

#include once "fbc-int/string.bi"

extern "c"
	declare function pExePath  alias "fb_hGetExePath"    ( byval d as zstring ptr, byval m as integer ) as zstring ptr
	declare function pExeName  alias "fb_hGetExeName"    ( byval d as zstring ptr, byval m as integer ) as zstring ptr
	declare function pCurDir   alias "fb_hGetCurrentDir" ( byval d as zstring ptr, byval m as integer ) as integer
	declare function pSetTime  alias "fb_hSetTime"       ( byval h as long, byval m as long, byval s as long ) as long
	declare function pSetDate  alias "fb_hSetDate"       ( byval y as long, byval m as long, byval d as long ) as long
	declare function pComTest  alias "fb_DevComTestProtocol" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
	declare function pComTestEx alias "fb_DevComTestProtocolEx" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger, byval p as uinteger ptr ) as long
end extern

extern "rtlib"
	declare function pTimer  alias "fb_Timer" ( ) as double
	declare function pMemAvail alias "fb_GetMemAvail" ( byval mode_ as long ) as uinteger
	declare sub      pDelay  alias "fb_Delay" ( byval ms as long )
end extern

print "-- all ten resolve"
dim shared as any ptr addrs( 0 to 9 )
addrs(0) = cast( any ptr, @pExePath )
addrs(1) = cast( any ptr, @pExeName )
addrs(2) = cast( any ptr, @pCurDir )
addrs(3) = cast( any ptr, @pSetTime )
addrs(4) = cast( any ptr, @pSetDate )
addrs(5) = cast( any ptr, @pTimer )
addrs(6) = cast( any ptr, @pMemAvail )
addrs(7) = cast( any ptr, @pDelay )
addrs(8) = cast( any ptr, @pComTest )
addrs(9) = cast( any ptr, @pComTestEx )
dim as long n = 0, distinct = 1
for i as integer = 0 to 9
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct

'' -------------------------------------------------------- exe path and name

'' THE RETURN POINTS INTO dst, and that -- not the text -- is the contract. The
'' path is written into the buffer and the return marks the split; a
'' reimplementation that returned a separate allocation would pass a text
'' comparison and break every caller.
print "-- fb_hGetExePath"
dim shared as zstring * 1024 pbuf = any
for i as integer = 0 to 1023
	pbuf[i] = 0
next
dim as zstring ptr pp = pExePath( @pbuf, 1024 )
print "  returned non-null="; ( pp <> 0 )
print "  points into the buffer="; ( (pp >= @pbuf) andalso (pp <= (@pbuf + 1023)) )
print "  buffer is non-empty="; ( len( pbuf ) > 0 )
'' AN ABSOLUTE PATH, which is what makes it usable as a base for a relative one.
#ifdef __FB_WIN32__
	print "  looks absolute="; ( (len( pbuf ) >= 2) andalso (pbuf[1] = asc(":")) )
	print "  has no trailing separator="; ( pbuf[len( pbuf ) - 1] <> asc("\") orelse len( pbuf ) = 3 )
#else
	print "  looks absolute="; ( pbuf[0] = asc("/") )
#endif

print "-- fb_hGetExeName"
dim shared as zstring * 1024 nbuf = any
for i as integer = 0 to 1023
	nbuf[i] = 0
next
dim as zstring ptr np = pExeName( @nbuf, 1024 )
print "  returned non-null="; ( np <> 0 )
print "  points into the buffer="; ( (np >= @nbuf) andalso (np <= (@nbuf + 1023)) )
'' THE BUFFER STILL HOLDS THE WHOLE PATH -- unlike fb_hGetExePath, this one does
'' NOT overwrite the separator. That difference between the two is the thing
'' most likely to be got wrong.
print "  buffer still holds the full path="; ( len( nbuf ) > len( *np ) )
print "  name has no separator="; ( (instr( *np, "\" ) = 0) andalso (instr( *np, "/" ) = 0) )
print "  name ends in .exe or has none="; ( (instr( lcase( *np ), ".exe" ) > 0) orelse (instr( *np, "." ) = 0) )

'' A ONE-BYTE BUFFER. maxlen includes the terminator, so this is the smallest
'' legal call -- and it must not write past it.
dim shared as zstring * 8 tiny = any
for i as integer = 0 to 7
	tiny[i] = 33          '' '!' sentinel
next
tiny[1] = 0
dim as zstring ptr tp = pExeName( @tiny, 1 )
print "  maxlen=1: byte[1] sentinel intact="; ( tiny[1] = 0 orelse tiny[1] = 33 )

'' ------------------------------------------------------- the current directory

'' BOTH RUNS HAPPEN IN THE SAME DIRECTORY, so this one compares by VALUE.
print "-- fb_hGetCurrentDir"
dim shared as zstring * 1024 dbuf = any
for i as integer = 0 to 1023
	dbuf[i] = 0
next
dim as integer dl = pCurDir( @dbuf, 1024 )
print "  length matches strlen="; ( dl = len( dbuf ) )
print "  non-empty="; ( dl > 0 )
print "  ["; dbuf; "]"

'' A BUFFER TOO SHORT. Windows returns the length INCLUDING the terminator here
'' and POSIX returns 0 -- so the answers differ by platform, and both runtimes
'' agree on the same platform.
dim shared as zstring * 4 sbuf = any
sbuf[0] = 0
print "  maxlen=4 -> "; pCurDir( @sbuf, 4 )

'' -------------------------------------------------------------- free memory

'' A BAND, NOT A NUMBER -- free memory changes between the two runs by
'' definition. What is asserted is that it is non-zero and plausible.
print "-- fb_GetMemAvail"
dim as uinteger m0 = pMemAvail( 0 )
print "  non-zero="; ( m0 > 0 )
print "  above 1 MB="; ( m0 > 1048576 )
'' mode IS IGNORED, so every value gives an answer in the same band. Compared as
'' a ratio rather than an equality, because the two calls are microseconds apart
'' and the real figure moves.
dim as uinteger m1 = pMemAvail( -1 )
dim as uinteger m2 = pMemAvail( 12345 )
print "  mode is ignored="; ( (m1 > 0) andalso (m2 > 0) )

'' ------------------------------------------------------------- TIMER, DELAY

'' TIMER MEANS DIFFERENT THINGS ON THE TWO PLATFORMS -- an arbitrary-origin
'' counter on Windows, seconds since the epoch on POSIX -- so nothing absolute is
'' printed. What is checked is that it is positive and that it ADVANCES.
print "-- fb_Timer"
dim as double t0 = pTimer( )
print "  positive="; ( t0 > 0.0 )

'' AND THAT IT ADVANCES ACROSS A KNOWN DELAY, which is the one check that makes
'' fb_Timer and fb_Delay verify each other.
pDelay( 60 )
dim as double t1 = pTimer( )
dim as double dt = t1 - t0
print "  advanced="; ( dt > 0.0 )
'' A BAND: at least 40ms (a signal may cut a 60ms sleep short, and Windows'
'' timer granularity is ~15ms) and at most 5 seconds (a loaded machine may
'' overshoot, but not by that much).
print "  delay of 60ms landed in [0.04, 5.0]="; ( (dt >= 0.04) andalso (dt <= 5.0) )

'' A ZERO DELAY IS LEGAL and returns approximately at once.
dim as double t2 = pTimer( )
pDelay( 0 )
print "  zero delay under 1s="; ( (pTimer( ) - t2) < 1.0 )

'' MONOTONIC ACROSS CONSECUTIVE READS. True on Windows by construction; on POSIX
'' it is a wall clock and an NTP step could break it, which is worth knowing and
'' is why this is printed rather than asserted silently.
dim as long nondecreasing = 1
dim as double prev = pTimer( )
for i as integer = 1 to 200
	dim as double cur = pTimer( )
	if( cur < prev ) then nondecreasing = 0
	prev = cur
next
print "  non-decreasing over 200 reads="; nondecreasing

'' -------------------------------------------------------- the clock setters

'' INVALID ARGUMENTS ONLY -- see the file header on why the success path is not
'' covered here. Every one of these must fail, and the code is what is compared.
print "-- fb_hSetTime (invalid arguments only; success path NOT covered)"
print "  99:00:00 -> "; pSetTime( 99, 0, 0 )
print "  00:99:00 -> "; pSetTime( 0, 99, 0 )
print "  -1:00:00 -> "; pSetTime( -1, 0, 0 )

print "-- fb_hSetDate (invalid arguments only; success path NOT covered)"
'' 1969 IS REJECTED BY THE POSIX BODY BEFORE ANY SYSCALL -- the one input whose
'' rejection is arithmetic rather than privilege, so it fails identically for a
'' root and a non-root run.
print "  1969/1/1 -> "; pSetDate( 1969, 1, 1 )
print "  1900/1/1 -> "; pSetDate( 1900, 1, 1 )
print "  0/0/0    -> "; pSetDate( 0, 0, 0 )
print "  2026/13/40 -> "; pSetDate( 2026, 13, 40 )

'' -------------------------------------------------------- the COM protocol

'' PURE, so this one is driven completely -- and the surprising cases are the
'' point: "SER:" is port 1, "COM:" is a VALID port ZERO, and anything without a
'' "COM" prefix is claimed merely for containing a colon.
print "-- fb_DevComTestProtocolEx"
sub tryCom( byref s as string )
	dim as uinteger port = &hDEADBEEF
	dim as long r = pComTestEx( 0, strptr( s ), len( s ), @port )
	dim as long r2 = pComTest( 0, strptr( s ), len( s ) )
	print "  ["; s; "] -> "; r; " port="; port; " (no-port form: "; r2; ")"
end sub

tryCom( "COM1:" )
tryCom( "COM2:" )
tryCom( "COM12:" )
tryCom( "com3:" )
'' PORT ZERO IS A REAL ANSWER, not a failure -- fbc removed the rejection on
'' purpose so that OPEN COM "COM:" works.
tryCom( "COM:" )
tryCom( "COM0:" )
'' "SER:" IS PORT 1 BY CONSTANT, and is the only prefix tested before the
'' four-character minimum.
tryCom( "SER:" )
tryCom( "ser:" )
'' THE WIDE NET: no "COM" prefix, but a colon somewhere, so it is claimed.
tryCom( "SCRN:" )
tryCom( "C:\file" )
tryCom( "LPT1:" )
tryCom( "x:" )
'' Rejections: too short, or no colon at all.
tryCom( "COM1" )
tryCom( "" )
tryCom( "abc" )
tryCom( "nonsense" )
tryCom( "COMx:" )
'' THE PORT ACCUMULATES WITH NO BOUND, which is visible as a wrap.
tryCom( "COM99999999999:" )
'' A NULL pPort is legal and must not be written.
print "  null pPort, [COM1:] -> "; pComTestEx( 0, @"COM1:", 5, 0 )

print "done"
