'' mutex.bas -- fb_Mutex*. Four entry points over one fbc member, split by
'' platform.
''
'' A SEMAPHORE, NOT A CRITICAL SECTION, ON WINDOWS -- and that is not an
'' oversight to tidy up. A CRITICAL_SECTION is RECURSIVE: the owning thread can
'' lock it again and does not block. A semaphore with a count of one is NOT, and
'' pthread's default mutex is not either, so the semaphore is what makes the two
'' platforms agree about what MUTEXLOCK twice on one thread does. Swapping it
'' for a critical section would make Windows deadlock-free where Linux
'' deadlocks, which is worse than either behaviour on its own.
''
'' It is also what win32/thread_cond.c's non-SignalObjectAndWait path relies on:
'' it unlocks the caller's mutex with ReleaseSemaphore.
''
'' EVERY ENTRY POINT TOLERATES NULL, because fb_MutexCreate can fail and fbc's
'' generated code does not check.

#include once "inc/thread.bi"
#include once "inc/sysbind.bi"

extern "rtlib"

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

function tkort_MutexCreate alias "fb_MutexCreate" ( ) as FBMUTEX ptr
	dim as FBMUTEX ptr m = malloc( sizeof( FBMUTEX ) )
	if( m = 0 ) then return 0
	m->id = w_CreateSemaphoreA( 0, 1, 1, 0 )
	return m
end function

sub tkort_MutexDestroy alias "fb_MutexDestroy" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	w_CloseHandle( m->id )
	free( m )
end sub

sub tkort_MutexLock alias "fb_MutexLock" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	w_WaitForSingleObject( m->id, INFINITE_ )
end sub

sub tkort_MutexUnlock alias "fb_MutexUnlock" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	w_ReleaseSemaphore( m->id, 1, 0 )
end sub

#else

function tkort_MutexCreate alias "fb_MutexCreate" ( ) as FBMUTEX ptr
	dim as FBMUTEX ptr m = malloc( sizeof( FBMUTEX ) )
	if( m = 0 ) then return 0
	u_pthread_mutex_init( @m->id(0), 0 )
	return m
end function

sub tkort_MutexDestroy alias "fb_MutexDestroy" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	u_pthread_mutex_destroy( @m->id(0) )
	free( m )
end sub

sub tkort_MutexLock alias "fb_MutexLock" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	u_pthread_mutex_lock( @m->id(0) )
end sub

sub tkort_MutexUnlock alias "fb_MutexUnlock" ( byval m as FBMUTEX ptr )
	if( m = 0 ) then exit sub
	u_pthread_mutex_unlock( @m->id(0) )
end sub

#endif

end extern
