'' thread-parity.bas -- threads, mutexes, condition variables, park/unpark, TLS
'' and the thread-flag handoff. 26 entry points across eight fbc members.
''
'' NEEDS-GEN-LLVM
'' NEEDS-MT
''
'' EVERY RESULT HERE IS REDUCED TO SOMETHING DETERMINISTIC. Thread scheduling is
'' not reproducible, so nothing prints an ordering, a timing or a thread
'' identity. What is printed is the kind of fact a broken implementation gets
'' wrong and a working one always gets right: a total that must come out exact
'' under a mutex, a wakeup that must have happened, a permit that must have been
'' remembered, a pointer that must differ between threads.
''
'' THE MUTEX BLOCK IS THE ONE THAT WOULD CATCH A MISSING LOCK. N threads each
'' increment a shared counter M times without any atomic; the total is N*M if
'' and only if the mutex is real. A broken mutex loses increments, and it loses
'' a DIFFERENT number every run -- so this is one of the very few tests here
'' whose failure is not reproducible, which is exactly why it is written as an
'' exact equality rather than as a printed count.
''
'' THE PERMIT IS STICKY AND BINARY, and both halves are checked:
''   - Unpark BEFORE Park must not be lost, or every caller has a lost-wakeup
''     race. ParkTimed with a generous timeout returns TRUE immediately.
''   - TWO Unparks collapse to ONE permit, so the second ParkTimed times out.
''   - ParkTimed( 0 ) with no permit is a poll that returns FALSE at once.
''
'' TLS IS PER-THREAD OR IT IS NOTHING: the same key asked for from two threads
'' must give two different blocks, and asking twice on one thread must give the
'' same one.

#include once "crt/stdlib.bi"

extern "rtlib"
	declare function pThreadCreate alias "fb_ThreadCreate" ( byval p as any ptr, byval a as any ptr, byval s as integer ) as any ptr
	declare sub      pThreadWait   alias "fb_ThreadWait"   ( byval t as any ptr )
	declare sub      pThreadDetach alias "fb_ThreadDetach" ( byval t as any ptr )
	declare function pThreadSelf   alias "fb_ThreadSelf"   ( ) as any ptr

	declare function pMutexCreate  alias "fb_MutexCreate"  ( ) as any ptr
	declare sub      pMutexDestroy alias "fb_MutexDestroy" ( byval m as any ptr )
	declare sub      pMutexLock    alias "fb_MutexLock"    ( byval m as any ptr )
	declare sub      pMutexUnlock  alias "fb_MutexUnlock"  ( byval m as any ptr )

	declare function pCondCreate    alias "fb_CondCreate"    ( ) as any ptr
	declare sub      pCondDestroy   alias "fb_CondDestroy"   ( byval c as any ptr )
	declare sub      pCondSignal    alias "fb_CondSignal"    ( byval c as any ptr )
	declare sub      pCondBroadcast alias "fb_CondBroadcast" ( byval c as any ptr )
	declare sub      pCondWait      alias "fb_CondWait"      ( byval c as any ptr, byval m as any ptr )

	declare function pParkerCreate  alias "fb_ParkerCreate"  ( ) as any ptr
	declare sub      pParkerDestroy alias "fb_ParkerDestroy" ( byval p as any ptr )
	declare function pParkerSelf    alias "fb_ParkerSelf"    ( ) as any ptr
	declare sub      pPark          alias "fb_Park"          ( byval p as any ptr )
	declare function pParkTimed     alias "fb_ParkTimed"     ( byval p as any ptr, byval ms as ulong ) as long
	declare sub      pUnpark        alias "fb_Unpark"        ( byval p as any ptr )
	declare function pCpuCount      alias "fb_CpuCount"      ( ) as long

	declare function pTlsGetCtx  alias "fb_TlsGetCtx"  ( byval i as long, byval n as uinteger, byval d as any ptr ) as any ptr
	declare sub      pTlsDelCtx  alias "fb_TlsDelCtx"  ( byval i as long )
end extern

const NTHREADS = 4
const NBUMPS   = 20000
const TLSKEY_GFX = 4            '' a key nothing else in the runtime uses here

dim shared as any ptr gMutex, gCond, gParker
dim shared as longint gCounter
dim shared as long gReady, gDone
dim shared as any ptr gTlsSeen( 0 to NTHREADS - 1 )
dim shared as any ptr gSelfSeen( 0 to NTHREADS - 1 )
dim shared as long gSlot

'' N threads, no atomics, one mutex. The total is exact if and only if the mutex
'' is real.
sub bumper cdecl ( byval param as any ptr )
	for i as integer = 1 to NBUMPS
		pMutexLock( gMutex )
		gCounter += 1
		pMutexUnlock( gMutex )
	next
end sub

'' Each thread records the TLS block it was given and its own FBTHREAD, then
'' BLOCKS until the main thread releases it.
''
'' THE BLOCKING IS THE POINT. A first version let each thread record and exit,
'' and then checked the pointers were distinct -- and they were not, on EITHER
'' runtime: a TLS block freed when one thread exits is handed straight back by
'' malloc to the next, so the addresses collided legitimately and the check
'' compared nothing. Holding every thread alive until all four have recorded is
'' what makes "distinct" a real invariant instead of an allocator coincidence.
sub recorder cdecl ( byval param as any ptr )
	dim as integer slot = cast( integer, param )
	gTlsSeen(slot) = pTlsGetCtx( TLSKEY_GFX, 64, 0 )
	gSelfSeen(slot) = pThreadSelf( )

	pMutexLock( gMutex )
	while( gReady = 0 )
		pCondWait( gCond, gMutex )
	wend
	pMutexUnlock( gMutex )
end sub

'' Waits on the condition variable until the main thread sets gReady.
sub waiter cdecl ( byval param as any ptr )
	pMutexLock( gMutex )
	while( gReady = 0 )
		pCondWait( gCond, gMutex )
	wend
	gDone += 1
	pMutexUnlock( gMutex )
end sub

'' Unparks the main thread's parker once.
sub unparker cdecl ( byval param as any ptr )
	pUnpark( gParker )
end sub

dim as any ptr t( 0 to NTHREADS - 1 )
dim as integer i = any

print "-- CpuCount is plausible"
print "  >0="; iif( pCpuCount( ) > 0, 1, 0 ); " <1025="; iif( pCpuCount( ) < 1025, 1, 0 )

print "-- the main thread has an FBTHREAD"
dim as any ptr mainSelf = pThreadSelf( )
print "  self<>0="; iif( mainSelf <> 0, 1, 0 ); " stable="; iif( pThreadSelf( ) = mainSelf, 1, 0 )

print "-- TLS: same key twice on one thread is the same block"
dim as any ptr a1 = pTlsGetCtx( TLSKEY_GFX, 64, 0 )
dim as any ptr a2 = pTlsGetCtx( TLSKEY_GFX, 64, 0 )
print "  nonzero="; iif( a1 <> 0, 1, 0 ); " same="; iif( a1 = a2, 1, 0 )
print "  zeroed="; iif( a1 <> 0, iif( *cptr( longint ptr, a1 ) = 0, 1, 0 ), 0 )
pTlsDelCtx( TLSKEY_GFX )
dim as any ptr a3 = pTlsGetCtx( TLSKEY_GFX, 64, 0 )
print "  fresh after delete="; iif( a3 <> 0, 1, 0 )

print "-- the mutex actually excludes"
gMutex = pMutexCreate( )
gCounter = 0
print "  create<>0="; iif( gMutex <> 0, 1, 0 )
for i = 0 to NTHREADS - 1
	t(i) = pThreadCreate( cast( any ptr, @bumper ), 0, 0 )
next
dim as long created = 0
for i = 0 to NTHREADS - 1
	if( t(i) <> 0 ) then created += 1
next
print "  threads created="; created
for i = 0 to NTHREADS - 1
	pThreadWait( t(i) )
next
print "  total exact="; iif( gCounter = cast( longint, NTHREADS ) * NBUMPS, 1, 0 )

print "-- TLS is per thread, and so is FBTHREAD"
gCond = pCondCreate( )
gReady = 0
for i = 0 to NTHREADS - 1
	gTlsSeen(i) = 0 : gSelfSeen(i) = 0
	t(i) = pThreadCreate( cast( any ptr, @recorder ), cast( any ptr, cast( integer, i ) ), 0 )
next
'' Spin until every slot is filled, so all four threads are demonstrably ALIVE
'' at the same moment; only then release them.
dim as long filled = 0
while( filled < NTHREADS )
	filled = 0
	for i = 0 to NTHREADS - 1
		if( gTlsSeen(i) <> 0 ) then filled += 1
	next
wend
pMutexLock( gMutex )
gReady = 1
pMutexUnlock( gMutex )
pCondBroadcast( gCond )
for i = 0 to NTHREADS - 1
	pThreadWait( t(i) )
next
pCondDestroy( gCond )
dim as long allSet = 1, allDistinct = 1, noneIsMain = 1
for i = 0 to NTHREADS - 1
	if( gTlsSeen(i) = 0 ) then allSet = 0
	if( gSelfSeen(i) = 0 ) then allSet = 0
	if( gSelfSeen(i) = mainSelf ) then noneIsMain = 0
	if( gTlsSeen(i) = a3 ) then allDistinct = 0
	for j as integer = 0 to i - 1
		if( gTlsSeen(i) = gTlsSeen(j) ) then allDistinct = 0
		if( gSelfSeen(i) = gSelfSeen(j) ) then allDistinct = 0
	next
next
print "  all set="; allSet; " all distinct="; allDistinct; " none is main="; noneIsMain

print "-- condition variable: broadcast releases every waiter"
gCond = pCondCreate( )
gReady = 0 : gDone = 0
print "  create<>0="; iif( gCond <> 0, 1, 0 )
for i = 0 to NTHREADS - 1
	t(i) = pThreadCreate( cast( any ptr, @waiter ), 0, 0 )
next
'' The waiters re-check gReady under the mutex, so this cannot race: a waiter
'' that has not yet parked sees the flag already set and never waits at all.
pMutexLock( gMutex )
gReady = 1
pMutexUnlock( gMutex )
pCondBroadcast( gCond )
for i = 0 to NTHREADS - 1
	pThreadWait( t(i) )
next
print "  all released="; iif( gDone = NTHREADS, 1, 0 )
pCondDestroy( gCond )
pCondDestroy( 0 )
pCondSignal( 0 )
pCondBroadcast( 0 )
pCondWait( 0, 0 )
print "  NULL cond calls survived"

print "-- park: the permit is STICKY and BINARY"
gParker = pParkerCreate( )
print "  create<>0="; iif( gParker <> 0, 1, 0 )
print "  poll with no permit="; pParkTimed( gParker, 0 )
pUnpark( gParker )
print "  unpark then park="; pParkTimed( gParker, 5000 )
pUnpark( gParker )
pUnpark( gParker )
print "  two unparks, first park="; pParkTimed( gParker, 5000 )
print "  two unparks, second park="; pParkTimed( gParker, 50 )
pParkerDestroy( gParker )

print "-- park: another thread's unpark wakes a blocked park"
gParker = pParkerCreate( )
dim as any ptr u = pThreadCreate( cast( any ptr, @unparker ), 0, 0 )
pPark( gParker )                 '' returns only when the permit arrives
pThreadWait( u )
print "  woken= 1"
pParkerDestroy( gParker )
pParkerDestroy( 0 )
pPark( 0 )
print "  NULL parker calls survived="; pParkTimed( 0, 0 )

print "-- ParkerSelf is cached per thread"
dim as any ptr ps1 = pParkerSelf( )
print "  nonzero="; iif( ps1 <> 0, 1, 0 ); " same twice="; iif( pParkerSelf( ) = ps1, 1, 0 )

print "-- detach: the thread frees itself and Wait is a no-op"
dim as any ptr d = pThreadCreate( cast( any ptr, @bumper ), 0, 0 )
gCounter = 0
if( d <> 0 ) then
	pThreadDetach( d )
	'' Wait on a DETACHED thread must return at once rather than block, and
	'' must not touch the structure the thread may already have freed.
	pThreadWait( d )
end if
print "  detach survived= 1"
pThreadDetach( 0 )
pThreadWait( 0 )
print "  NULL thread calls survived"

pMutexDestroy( gMutex )
pMutexDestroy( 0 )
pMutexLock( 0 )
pMutexUnlock( 0 )
print "  NULL mutex calls survived"

print "done"
