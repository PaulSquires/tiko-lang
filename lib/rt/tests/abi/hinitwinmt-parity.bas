'' hinitwinmt-parity.bas -- the twelve MT locks of win32/hinit.o. These exist
'' ONLY in libfbmt.a; the single-threaded archive has no fb_Lock at all.
''
'' NEEDS-GEN-LLVM
'' NEEDS-MT
''
'' EACH PAIR IS EXERCISED, NOT JUST RESOLVED, and the exercise is the point.
'' A critical section that was never InitializeCriticalSection'd is not a
'' diagnosable error on Windows -- EnterCriticalSection on zeroed storage walks
'' a NULL LockSemaphore and the behaviour is undefined, which in practice means
'' it usually appears to WORK. So a test that only took each address would pass
'' against a runtime whose fb_hInit had forgotten the initialisation loop
'' entirely. Entering and leaving each of the six actually depends on it.
''
'' AND EACH IS ENTERED TWICE, NESTED. A Windows CRITICAL_SECTION is recursive by
'' definition, which is exactly why hinitwin.bas needs no attribute where the
'' POSIX half has to ask pthreads for PTHREAD_MUTEX_RECURSIVE explicitly. If a
'' future version of this member were "simplified" to a non-recursive primitive
'' -- a Semaphore, an SRWLOCK -- the second Enter would DEADLOCK rather than
'' return a wrong answer, and the test would hang rather than fail. A hang is an
'' unpleasant failure mode; it is still an unmissable one, and it is the only
'' shape this particular regression has.
''
'' THE SIX MUST BE SIX DISTINCT MUTEXES and this test does NOT prove that.
'' Proving it needs two threads: thread A holds the string lock while thread B
'' takes the math lock and completes. With one thread, a runtime that used ONE
'' critical section for all six would pass every line below, because a recursive
'' lock lets the same thread take it any number of times. That is a real gap in
'' this test and it is named here rather than left for a reader to discover --
'' what covers it instead is fbc's own suite under the gate, where the string
'' and graphics locks are held concurrently by different threads.

#ifdef __FB_WIN32__

extern "rtlib"
	declare sub fbLock alias "fb_Lock" ( )
	declare sub fbUnlock alias "fb_Unlock" ( )
	declare sub fbStrLock alias "fb_StrLock" ( )
	declare sub fbStrUnlock alias "fb_StrUnlock" ( )
	declare sub fbMtLock alias "fb_MtLock" ( )
	declare sub fbMtUnlock alias "fb_MtUnlock" ( )
	declare sub fbGfxLock alias "fb_GraphicsLock" ( )
	declare sub fbGfxUnlock alias "fb_GraphicsUnlock" ( )
	declare sub fbMathLock alias "fb_MathLock" ( )
	declare sub fbMathUnlock alias "fb_MathUnlock" ( )
	declare sub fbProfLock alias "fb_ProfileLock" ( )
	declare sub fbProfUnlock alias "fb_ProfileUnlock" ( )
end extern

print "-- resolution"
dim shared as any ptr a12( 0 to 11 )
a12( 0) = cast( any ptr, @fbLock )      : a12( 1) = cast( any ptr, @fbUnlock )
a12( 2) = cast( any ptr, @fbStrLock )   : a12( 3) = cast( any ptr, @fbStrUnlock )
a12( 4) = cast( any ptr, @fbMtLock )    : a12( 5) = cast( any ptr, @fbMtUnlock )
a12( 6) = cast( any ptr, @fbGfxLock )   : a12( 7) = cast( any ptr, @fbGfxUnlock )
a12( 8) = cast( any ptr, @fbMathLock )  : a12( 9) = cast( any ptr, @fbMathUnlock )
a12(10) = cast( any ptr, @fbProfLock )  : a12(11) = cast( any ptr, @fbProfUnlock )

dim as long n = 0, distinct = 1
for i as integer = 0 to 11
	if( a12(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( a12(i) = a12(j) ) then distinct = 0
	next
next
print "  count="; n; " distinct="; distinct

print "-- nested enter/leave, all six"

fbLock( )      : fbLock( )      : fbUnlock( )      : fbUnlock( )
print "  global   ok"
fbStrLock( )   : fbStrLock( )   : fbStrUnlock( )   : fbStrUnlock( )
print "  string   ok"
fbMtLock( )    : fbMtLock( )    : fbMtUnlock( )    : fbMtUnlock( )
print "  mtcore   ok"
fbGfxLock( )   : fbGfxLock( )   : fbGfxUnlock( )   : fbGfxUnlock( )
print "  graphics ok"
fbMathLock( )  : fbMathLock( )  : fbMathUnlock( )  : fbMathUnlock( )
print "  math     ok"
fbProfLock( )  : fbProfLock( )  : fbProfUnlock( )  : fbProfUnlock( )
print "  profile  ok"

'' UNBALANCED ON PURPOSE IS NOT TESTED. Leaving a critical section that was
'' never entered is undefined on Windows and both runtimes would be equally
'' undefined -- the outputs would agree and the agreement would mean nothing.

#else

print "-- resolution"
print "  the twelve MT locks are win32/hinit.o's; EMPTY-ON linux-x86_64"

#endif

print "done"
