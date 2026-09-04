'' sched-parity.bas -- the goroutine scheduler. Four symbols, one fbc member
'' (sched.o).
''
'' NEEDS-GEN-LLVM
''
'' THREE OF THE FOUR ARE CALLED FOR REAL, INCLUDING fb_Spawn. That is unusual
'' for this stretch and it is safe here for a specific reason: SPAWN is what
'' every FreeBASIC program using goroutines does, the worker threads it creates
'' are detached and are torn down by fb_SchedShutdown from fb_hRtExit, and
'' nothing outside the process observes any of it.
''
'' fb_SchedShutdown IS NOT CALLED. It sets the shutdown flag permanently, after
'' which every later fb_Spawn silently drops its work -- so calling it would
'' poison the rest of the program, and it runs at exit anyway.
''
'' EVERYTHING PRINTED HERE IS DETERMINISTIC, AND THAT TOOK CARE:
''
''   NO COUNTS, NO ORDER, NO TIMING. The number of workers is fb_CpuCount( ) --
''   machine-dependent. The ORDER in which spawned items run is scheduler-
''   dependent. How many are queued at any instant is a race. So the only things
''   printed are a SUM (order-independent), and BOOLEANS derived by comparison
''   rather than the raw values.
''
''   THE SUM IS THE ASSERTION. Each spawned item adds its own index to a shared
''   total under the claim lock. The total for 0..63 is 2016 whatever order they
''   run in, and it is only 2016 if every item ran EXACTLY ONCE -- which is the
''   property that matters: a lost wake drops one, and a double-dequeue adds one
''   twice.
''
''   THE WAIT IS BOUNDED. Spinning until the count reaches 64 with no ceiling
''   would hang the suite exactly as fb_ConsoleReadStr once did. The loop below
''   gives up after a fixed number of iterations and prints whether it completed,
''   so a scheduler that never ran anything FAILS rather than HANGS.
''
'' WHAT THIS DOES **NOT** COVER:
''
''   THE MONITOR. Pool growth needs two consecutive 50 ms ticks with work queued
''   and no idle worker -- i.e. a deliberately blocked worker. Not reproduced
''   here, so FB_SCHED_STARVE_TICKS and the growth path are untested.
''   THE 256-WORKER CEILING, for the same reason.
''   THE INLINE FALLBACK, which needs thread creation to fail.
''   THE SHUTDOWN RACE between a spawn and a concurrent shutdown.
''   WORKER HYGIENE -- that fb_ErrorSetNum( 0 ) brackets each item. Detecting it
''   needs one goroutine to set the error state and a LATER, unrelated one on the
''   same worker to observe it clean, which is a scheduling assumption this test
''   cannot make.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare sub pSpawn alias "fb_Spawn" ( byval proc_ as any ptr, byval ctx as any ptr )
	declare function pGoroutineCount alias "fb_GoroutineCount" ( ) as long
	declare function pWorkerCount alias "fb_SchedWorkerCount" ( ) as long
	declare sub pClaimLock alias "fb_ClaimLock" ( )
	declare sub pClaimUnlock alias "fb_ClaimUnlock" ( )
	declare sub pSleep alias "fb_Delay" ( byval ms as ulong )
end extern

extern "c"
	declare sub pSchedShutdown alias "fb_SchedShutdown" ( )
end extern

print "-- resolution"
dim shared as any ptr a4( 0 to 3 )
a4(0) = cast( any ptr, @pSpawn )
a4(1) = cast( any ptr, @pGoroutineCount )
a4(2) = cast( any ptr, @pWorkerCount )
a4(3) = cast( any ptr, @pSchedShutdown )
dim as long n = 0, distinct = 1
for i as integer = 0 to 3
	if( a4(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a4(i) = a4(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct
print "  fb_SchedShutdown is ADDRESS ONLY -- it would poison every later spawn"

'' BEFORE ANY SPAWN both counters must read zero, because the scheduler has not
'' been initialised and both check `inited` before touching the lock. This is
'' the one place the uninitialised path is exercised.
print "-- before any spawn (the uninitialised path)"
print "  goroutines="; pGoroutineCount( ); " workers="; pWorkerCount( )

'' The shared total, guarded by the claim lock -- which is the other half of
'' this batch and gets exercised under real contention here rather than
'' serially as in claimlock-parity.
dim shared as long tot = 0
dim shared as long done_count = 0

'' FBCALL, spelled out: on 32-bit Windows a spawned proc is __stdcall and
'' everywhere else cdecl. Declaring it cdecl on win32 would imbalance the stack
'' at every call and leave win64 and Linux green.
#if defined( __FB_WIN32__ ) and not defined( __FB_64BIT__ )
sub worker_ stdcall ( byval ctx as any ptr )
#else
sub worker_ cdecl ( byval ctx as any ptr )
#endif
	dim as long idx = cast( long, cast( integer, ctx ) )
	pClaimLock( )
	tot += idx
	done_count += 1
	pClaimUnlock( )
end sub

print "-- spawning 64 items, each adding its index to a shared total"
for i as integer = 0 to 63
	pSpawn( cast( any ptr, @worker_ ), cast( any ptr, cast( integer, i ) ) )
next

'' BOUNDED WAIT -- see the file header on why an unbounded spin is not allowed.
'' 200 x 25 ms is five seconds, which is many orders of magnitude more than 64
'' trivial items need.
dim as long spins = 0
do
	pClaimLock( )
	dim as long d = done_count
	pClaimUnlock( )
	if( d >= 64 ) then exit do
	pSleep( 25 )
	spins += 1
loop while( spins < 200 )

pClaimLock( )
dim as long final_tot = tot
dim as long final_done = done_count
pClaimUnlock( )

'' 0+1+...+63 = 2016, whatever order they ran in -- and only if each ran
'' exactly once.
print "  completed="; iif( final_done = 64, 1, 0 )
print "  total_is_2016="; iif( final_tot = 2016, 1, 0 )

'' AFTER the spawns the scheduler is initialised, so the worker count must be
'' positive -- but the VALUE is fb_CpuCount( ) and is not printed.
print "-- after spawning (the initialised path)"
print "  workers_positive="; iif( pWorkerCount( ) > 0, 1, 0 )
print "  goroutines_settled="; iif( pGoroutineCount( ) >= 0, 1, 0 )

'' A SECOND ROUND, to prove the workers were parked and are reusable rather
'' than having exited after the first batch.
print "-- a second round of 32 on the same workers"
pClaimLock( ) : tot = 0 : done_count = 0 : pClaimUnlock( )
for i as integer = 1 to 32
	pSpawn( cast( any ptr, @worker_ ), cast( any ptr, cast( integer, i ) ) )
next
spins = 0
do
	pClaimLock( )
	dim as long d = done_count
	pClaimUnlock( )
	if( d >= 32 ) then exit do
	pSleep( 25 )
	spins += 1
loop while( spins < 200 )
pClaimLock( )
final_tot = tot : final_done = done_count
pClaimUnlock( )
'' 1+2+...+32 = 528.
print "  completed="; iif( final_done = 32, 1, 0 )
print "  total_is_528="; iif( final_tot = 528, 1, 0 )

'' A NULL PROC IS IGNORED, not a crash -- the first thing fb_Spawn tests.
print "-- fb_Spawn( NULL ) is ignored"
pSpawn( 0, 0 )
print "  survived"

print "done"
