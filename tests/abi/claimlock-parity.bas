'' claimlock-parity.bas -- the process-wide claim lock. Two symbols, one fbc
'' member (chan_claim.o).
''
'' NEEDS-GEN-LLVM
''
'' BOTH ARE CALLED FOR REAL, which makes this the first genuinely exercised
'' batch since FORMAT$. A lock/unlock pair on a process-wide mutex is safe to
'' drive from a single-threaded harness: the section is uncontended, every call
'' returns, and nothing outside the process observes it.
''
'' WHAT THE CALLS ACTUALLY PROVE:
''
''   THE LAZY INITIALISATION RUNS EXACTLY ONCE AND SURVIVES REUSE. On Windows
''   the first fb_ClaimLock has to InitializeCriticalSection through a
''   three-state interlocked spin; every later one must skip it. A thousand
''   lock/unlock pairs below would deadlock, crash, or leak the section's debug
''   info if that state machine were wrong -- and the fact that the program
''   REACHES the final print is the assertion.
''
''   THE POSIX SIDE HAS NO INITIALISATION AT ALL, because
''   PTHREAD_MUTEX_INITIALIZER is all zero bytes and .bss provides it. The same
''   loop therefore tests something different on each platform: a state machine
''   on Windows, and on Linux that a zero-filled block really is a usable mutex.
''
''   IT IS NOT RECURSIVE AND IS NOT TESTED AS SUCH. A CRITICAL_SECTION is
''   re-entrant and a default pthread mutex is NOT, so locking twice from one
''   thread deadlocks on Linux and succeeds on Windows. That difference is real
''   and this file must not exercise it -- the lock's contract is that it is
''   held across a few instructions and never re-entered.
''
'' WHAT THIS DOES **NOT** COVER, which is most of what the lock exists for:
''
''   CONTENTION. Everything interesting about a mutex is what happens when two
''   threads want it, and this is one thread. The three-state spin's Sleep(0)
''   branch -- the one a second thread takes while the first is still inside
''   InitializeCriticalSection -- is never entered here.
''
''   THE LOCK ORDER. The rule is channel locks first, then this one, never the
''   reverse. Nothing here holds a channel lock, so the ordering is untested.
''
''   MUTUAL EXCLUSION ITSELF. That the lock actually excludes is assumed, not
''   shown.
''
''   Those need a threaded harness with two workers racing on one wait record.
''   fbc's own suite covers the SELECT path that uses this; this file covers
''   only that the entry points exist and behave sanely when driven serially.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare sub pClaimLock alias "fb_ClaimLock" ( )
	declare sub pClaimUnlock alias "fb_ClaimUnlock" ( )
end extern

print "-- resolution"
dim shared as any ptr a2( 0 to 1 )
a2(0) = cast( any ptr, @pClaimLock )
a2(1) = cast( any ptr, @pClaimUnlock )
print "  count="; iif( a2(0) <> 0, 1, 0 ) + iif( a2(1) <> 0, 1, 0 ); _
      " distinct="; iif( a2(0) <> a2(1), 1, 0 )

'' THE FIRST LOCK IS THE ONE THAT INITIALISES on Windows. Separated from the
'' loop below so that a failure there is distinguishable from a failure on
'' reuse.
print "-- first lock/unlock (the lazy init, on Windows)"
pClaimLock( )
pClaimUnlock( )
print "  survived"

'' REUSE. If the state machine published "ready" incorrectly, the second lock
'' either re-initialises (leaking, and on some runtimes asserting) or spins
'' forever. Reaching the print is the assertion -- see the file header.
print "-- 1000 further lock/unlock pairs"
for i as integer = 1 to 1000
	pClaimLock( )
	pClaimUnlock( )
next
print "  survived"

'' INTERLEAVED WITH OTHER WORK, so the lock is not the only thing touching the
'' allocator and the scheduler between acquisitions.
print "-- 200 pairs interleaved with allocation"
dim shared as string s
for i as integer = 1 to 200
	pClaimLock( )
	pClaimUnlock( )
	s = str( i ) + "x"
	pClaimLock( )
	pClaimUnlock( )
next
print "  survived, s={" & s & "}"

print "done"
