'' cond.bas -- condition variables. Five entry points over one fbc member, split
'' by platform, and the two platforms are not remotely the same amount of code.
''
'' POSIX HAS THE PRIMITIVE; WINDOWS DOES NOT, so the Windows side builds one from
'' a semaphore, an event and a waiter count -- the construction from Schmidt and
'' Pyarali that fbc uses. It picks between two implementations AT RUN TIME:
''
''   nt  SignalObjectAndWait is present and works. The unlock-and-wait is then
''       ATOMIC, which is what a condition variable actually requires.
''   9x  It is absent or broken. The mutex is released and the wait started as
''       two separate steps, which has a real race, and that is the price of
''       running at all on those systems.
''
'' The probe is deliberately odd: SignalObjectAndWait( NULL, NULL, 0, 0 ) returns
'' WAIT_FAILED on NT, ERROR_INVALID_FUNCTION on Windows 98, and cannot be called
'' at all on Windows 95. Only "present AND returns WAIT_FAILED" selects the nt
'' path. REPRODUCED RATHER THAN SIMPLIFIED: every machine this can run on today
'' takes the nt path, so deleting the 9x half would be untestable either way --
'' but it is the contract, and a runtime that quietly dropped a branch is not a
'' drop-in.
''
'' NOT CONDITION_VARIABLE/SleepConditionVariableSRW, for the same reason as
'' thread/park.bas: this runtime does not otherwise require a Vista-era API
'' surface.
''
'' fb_CondWait TAKES THE CALLER'S FBMUTEX, which on Windows is a SEMAPHORE -- see
'' thread/mutex.bas. That is why the 9x path can unlock it with ReleaseSemaphore
'' and why swapping the mutex for a critical section would break this file too.

#include once "inc/thread.bi"
#include once "inc/sysbind.bi"

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

const TKORT_COND_SIGNAL    = 0
const TKORT_COND_BROADCAST = 1

'' The union of the two implementations' state. Spelled as a flat record rather
'' than a union: the two arms are never both live, and FBCOND is entirely
'' private to this file -- nothing outside it knows the layout.
type FBCOND
	as long    waiters_count
	as ubyte   waiters_count_lock( 0 to TKORT_CRITSEC_SIZE - 1 )

	'' 9x: event(SIGNAL) is auto-reset, event(BROADCAST) is manual-reset, and
	'' they are adjacent because WaitForMultipleObjects takes an array.
	as any ptr event_( 0 to 1 )

	'' nt
	as any ptr sema
	as any ptr waiters_done
	as long    was_broadcast
end type

type SIGNALOBJECTANDWAIT as function stdcall _
	( byval a as any ptr, byval b as any ptr, byval ms as ulong, byval alertable as long ) as ulong

dim shared as SIGNALOBJECTANDWAIT tkort_pSignalObjectAndWait
dim shared as long tkort_condInited
dim shared as long tkort_condUseNT

'' The one-time probe. Guarded by the runtime's own MT lock, which lives in
'' fbc's hinit.o -- so two threads racing into fb_CondCreate cannot both probe.
private sub hCondInit( )
	dim as any ptr h = any

	TKORT_MTLOCK()

	if( tkort_condInited <> 0 ) then
		TKORT_MTUNLOCK()
		exit sub
	end if

	h = w_GetModuleHandleA( @"KERNEL32" )
	if( h <> 0 ) then
		tkort_pSignalObjectAndWait = cast( SIGNALOBJECTANDWAIT, _
			w_GetProcAddress( h, @"SignalObjectAndWait" ) )
	end if

	tkort_condUseNT = 0
	if( tkort_pSignalObjectAndWait <> 0 ) then
		if( tkort_pSignalObjectAndWait( 0, 0, 0, 0 ) = WAIT_FAILED_ ) then tkort_condUseNT = 1
	end if

	tkort_condInited = 1

	TKORT_MTUNLOCK()
end sub

extern "rtlib"

function tkort_CondCreate alias "fb_CondCreate" ( ) as FBCOND ptr
	dim as FBCOND ptr c = any

	hCondInit( )

	c = malloc( sizeof( FBCOND ) )
	if( c = 0 ) then return 0

	c->waiters_count = 0
	w_InitializeCriticalSection( @c->waiters_count_lock(0) )

	if( tkort_condUseNT <> 0 ) then
		c->was_broadcast = 0
		c->sema = w_CreateSemaphoreA( 0, 0, &h7FFFFFFF, 0 )
		c->waiters_done = w_CreateEventA( 0, 0, 0, 0 )
		c->event_(0) = 0
		c->event_(1) = 0
	else
		c->event_(TKORT_COND_SIGNAL)    = w_CreateEventA( 0, 0, 0, 0 )
		c->event_(TKORT_COND_BROADCAST) = w_CreateEventA( 0, 1, 0, 0 )
		c->sema = 0
		c->waiters_done = 0
	end if

	return c
end function

sub tkort_CondDestroy alias "fb_CondDestroy" ( byval c as FBCOND ptr )
	if( c = 0 ) then exit sub

	w_DeleteCriticalSection( @c->waiters_count_lock(0) )

	if( tkort_condUseNT <> 0 ) then
		w_CloseHandle( c->sema )
		w_CloseHandle( c->waiters_done )
	else
		w_CloseHandle( c->event_(TKORT_COND_SIGNAL) )
		w_CloseHandle( c->event_(TKORT_COND_BROADCAST) )
	end if

	free( c )
end sub

sub tkort_CondSignal alias "fb_CondSignal" ( byval c as FBCOND ptr )
	dim as long has_waiters = any

	if( c = 0 ) then exit sub

	w_EnterCriticalSection( @c->waiters_count_lock(0) )
	has_waiters = iif( c->waiters_count > 0, 1, 0 )
	w_LeaveCriticalSection( @c->waiters_count_lock(0) )

	if( has_waiters = 0 ) then exit sub

	if( tkort_condUseNT <> 0 ) then
		w_ReleaseSemaphore( c->sema, 1, 0 )
	else
		w_SetEvent( c->event_(TKORT_COND_SIGNAL) )
	end if
end sub

sub tkort_CondBroadcast alias "fb_CondBroadcast" ( byval c as FBCOND ptr )
	dim as long has_waiters = any

	if( c = 0 ) then exit sub

	if( tkort_condUseNT <> 0 ) then
		w_EnterCriticalSection( @c->waiters_count_lock(0) )

		if( c->waiters_count > 0 ) then
			c->was_broadcast = 1
			w_ReleaseSemaphore( c->sema, c->waiters_count, 0 )
			w_LeaveCriticalSection( @c->waiters_count_lock(0) )

			'' Waits for the LAST waiter to say it has left, so the semaphore
			'' count cannot leak into the next broadcast.
			w_WaitForSingleObject( c->waiters_done, INFINITE_ )
			c->was_broadcast = 0
		else
			w_LeaveCriticalSection( @c->waiters_count_lock(0) )
		end if
	else
		w_EnterCriticalSection( @c->waiters_count_lock(0) )
		has_waiters = iif( c->waiters_count > 0, 1, 0 )
		w_LeaveCriticalSection( @c->waiters_count_lock(0) )

		if( has_waiters <> 0 ) then w_SetEvent( c->event_(TKORT_COND_BROADCAST) )
	end if
end sub

sub tkort_CondWait alias "fb_CondWait" ( byval c as FBCOND ptr, byval m as FBMUTEX ptr )
	dim as long last_waiter = any
	dim as ulong result = any

	if( c = 0 ) then exit sub
	if( m = 0 ) then exit sub

	w_EnterCriticalSection( @c->waiters_count_lock(0) )
	c->waiters_count += 1
	w_LeaveCriticalSection( @c->waiters_count_lock(0) )

	if( tkort_condUseNT <> 0 ) then
		'' ATOMIC unlock-and-wait. This is the whole reason the nt path exists.
		tkort_pSignalObjectAndWait( m->id, c->sema, INFINITE_, 0 )

		w_EnterCriticalSection( @c->waiters_count_lock(0) )
		c->waiters_count -= 1
		last_waiter = iif( (c->was_broadcast <> 0) andalso (c->waiters_count = 0), 1, 0 )
		w_LeaveCriticalSection( @c->waiters_count_lock(0) )

		if( last_waiter <> 0 ) then
			tkort_pSignalObjectAndWait( c->waiters_done, m->id, INFINITE_, 0 )
		else
			w_WaitForSingleObject( m->id, INFINITE_ )
		end if
	else
		'' NOT ATOMIC WITH THE WAIT, and that is the 9x path's known defect.
		w_ReleaseSemaphore( m->id, 1, 0 )

		result = w_WaitForMultipleObjects( 2, @c->event_(0), 0, INFINITE_ )

		w_EnterCriticalSection( @c->waiters_count_lock(0) )
		c->waiters_count -= 1
		last_waiter = iif( (result = WAIT_OBJECT_0_ + TKORT_COND_BROADCAST) andalso _
		                   (c->waiters_count = 0), 1, 0 )
		w_LeaveCriticalSection( @c->waiters_count_lock(0) )

		'' The manual-reset broadcast event stays signalled until the last
		'' waiter clears it, which is how one SetEvent releases all of them.
		if( last_waiter <> 0 ) then w_ResetEvent( c->event_(TKORT_COND_BROADCAST) )

		w_WaitForSingleObject( m->id, INFINITE_ )
	end if
end sub

end extern

#else

'' ------------------------------------------------------------ POSIX backend
''
'' pthread has the primitive, so this is a wrapper and nothing more.

type FBCOND
	as ubyte id( 0 to TKORT_PTHREAD_COND_SIZE - 1 )
end type

extern "rtlib"

function tkort_CondCreate alias "fb_CondCreate" ( ) as FBCOND ptr
	dim as FBCOND ptr c = malloc( sizeof( FBCOND ) )
	if( c = 0 ) then return 0
	u_pthread_cond_init( @c->id(0), 0 )
	return c
end function

sub tkort_CondDestroy alias "fb_CondDestroy" ( byval c as FBCOND ptr )
	if( c = 0 ) then exit sub
	u_pthread_cond_destroy( @c->id(0) )
	free( c )
end sub

sub tkort_CondSignal alias "fb_CondSignal" ( byval c as FBCOND ptr )
	if( c = 0 ) then exit sub
	u_pthread_cond_signal( @c->id(0) )
end sub

sub tkort_CondBroadcast alias "fb_CondBroadcast" ( byval c as FBCOND ptr )
	if( c = 0 ) then exit sub
	u_pthread_cond_broadcast( @c->id(0) )
end sub

sub tkort_CondWait alias "fb_CondWait" ( byval c as FBCOND ptr, byval m as FBMUTEX ptr )
	if( c = 0 ) then exit sub
	if( m = 0 ) then exit sub
	u_pthread_cond_wait( @c->id(0), @m->id(0) )
end sub

end extern

#endif
