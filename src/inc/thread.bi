'' thread.bi -- the threading module's shared layouts, TLS keys and platform
'' primitive bindings.
''
'' ONE ARCHIVE'S SOURCE BUILDS BOTH libfb.a AND libfbmt.a, selected by
'' ENABLE_MT. The single-threaded build still DEFINES every entry point here --
'' fbc's does too -- because a program that never starts a thread still calls
'' fb_ThreadSelf and fb_TlsGetCtx, and because fb_ThreadCreate returning NULL is
'' a better answer than a link error.
''
'' What ENABLE_MT actually selects is whether TLS is REAL. Without it the
'' "thread-local" table is a plain array of pointers -- correct, because there is
'' only one thread -- and with it the entries are pthread keys or TlsAlloc slots.
'' That is exactly fbc's structure and it is why fb_TlsInit/fb_TlsExit exist only
'' in the MT archive.
''
'' EVERY SIZE HERE IS MEASURED, NOT ASSUMED, and each one is stated with what it
'' was measured against. A wrong size in this file is a heap corruption, not a
'' compile error, and it would show up as an unrelated test failing under -mt.

#pragma once

#include once "inc/descriptors.bi"

'' The TLS key enum from fb_thread.h, in order. The ORDER is the contract: the
'' index is what selects the slot, and err/getset.bas and io/printusg.bas
'' already hard-code 0 and 3 against it.
const FB_TLSKEY_ERROR    = 0
const FB_TLSKEY_DIR      = 1
const FB_TLSKEY_INPUT    = 2
const FB_TLSKEY_PRINTUSG = 3
const FB_TLSKEY_GFX      = 4
const FB_TLSKEY_FBTHREAD = 5
const FB_TLSKEY_PROFILE  = 6
const FB_TLSKEY_PARKER   = 7
const FB_TLSKEYS         = 8

'' FBTHREADFLAGS
const FBTHREAD_MAIN     = 1
const FBTHREAD_EXITED   = 2
const FBTHREAD_DETACHED = 4

type FB_TLS_DESTRUCTOR as sub cdecl ( byval tlsData as any ptr )

'' The block header that precedes every TLS context allocation. One function
'' pointer, so the DATA pointer handed to the caller is the header pointer plus
'' one pointer.
type FB_TLS_CTX_HEADER
	as FB_TLS_DESTRUCTOR dtor
end type

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

	'' CRITICAL_SECTION: DebugInfo ptr, LockCount, RecursionCount, OwningThread
	'' ptr, LockSemaphore ptr, SpinCount (ULONG_PTR). 40 bytes on x64 and 24 on
	'' x86. Held as raw storage: nothing here reads a field, only the address is
	'' ever passed on.
	#if defined( __FB_64BIT__ )
		const TKORT_CRITSEC_SIZE = 40
	#else
		const TKORT_CRITSEC_SIZE = 24
	#endif

	type FBMUTEX
		as any ptr id                  '' a Semaphore, not a CRITICAL_SECTION
	end type

	type FBTHREAD
		as any ptr id                  '' HANDLE
		as long    flags
	end type

	const INFINITE_       = &hFFFFFFFFul
	const WAIT_OBJECT_0_  = 0
	const WAIT_FAILED_    = &hFFFFFFFFul

	extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
		declare function w_CreateSemaphoreA stdcall alias "CreateSemaphoreA" _
			( byval sa as any ptr, byval initial as long, byval max_ as long, byval n as zstring ptr ) as any ptr
		declare function w_ReleaseSemaphore stdcall alias "ReleaseSemaphore" _
			( byval h as any ptr, byval count as long, byval prev as long ptr ) as long
		declare function w_CreateEventA stdcall alias "CreateEventA" _
			( byval sa as any ptr, byval manual as long, byval initial as long, byval n as zstring ptr ) as any ptr
		declare function w_SetEvent stdcall alias "SetEvent" ( byval h as any ptr ) as long
		declare function w_ResetEvent stdcall alias "ResetEvent" ( byval h as any ptr ) as long
		declare function w_CloseHandle stdcall alias "CloseHandle" ( byval h as any ptr ) as long
		declare function w_WaitForSingleObject stdcall alias "WaitForSingleObject" _
			( byval h as any ptr, byval ms as ulong ) as ulong
		declare function w_WaitForMultipleObjects stdcall alias "WaitForMultipleObjects" _
			( byval n as ulong, byval h as any ptr, byval all as long, byval ms as ulong ) as ulong
		declare sub w_InitializeCriticalSection stdcall alias "InitializeCriticalSection" ( byval cs as any ptr )
		declare sub w_DeleteCriticalSection stdcall alias "DeleteCriticalSection" ( byval cs as any ptr )
		declare sub w_EnterCriticalSection stdcall alias "EnterCriticalSection" ( byval cs as any ptr )
		declare sub w_LeaveCriticalSection stdcall alias "LeaveCriticalSection" ( byval cs as any ptr )
		declare function w_GetTickCount stdcall alias "GetTickCount" ( ) as ulong
		declare sub w_GetSystemInfo stdcall alias "GetSystemInfo" ( byval si as any ptr )
		declare function w_TlsAlloc stdcall alias "TlsAlloc" ( ) as ulong
		declare function w_TlsFree stdcall alias "TlsFree" ( byval k as ulong ) as long
		declare function w_TlsSetValue stdcall alias "TlsSetValue" ( byval k as ulong, byval v as any ptr ) as long
		declare function w_TlsGetValue stdcall alias "TlsGetValue" ( byval k as ulong ) as any ptr
		declare function w_GetModuleHandleA stdcall alias "GetModuleHandleA" ( byval n as zstring ptr ) as any ptr
		declare function w_GetProcAddress stdcall alias "GetProcAddress" ( byval h as any ptr, byval n as zstring ptr ) as any ptr
	end extern

#else

	'' MEASURED AGAINST glibc ON linux-x86_64, which is the only POSIX target
	'' in R3. These are the __SIZEOF_* macros glibc's own headers use:
	''
	''     pthread_mutex_t   40      pthread_cond_t     48
	''     pthread_condattr_t 4      pthread_key_t       4
	''     pthread_t          8      struct timespec    16
	''
	'' Held as raw byte storage rather than transcribed field by field: nothing
	'' here reads a member, and transcribing a union of anonymous internals
	'' would be a much larger surface to get wrong.
	const TKORT_PTHREAD_MUTEX_SIZE = 40
	const TKORT_PTHREAD_COND_SIZE  = 48
	const TKORT_CONDATTR_SIZE      = 4
	const TKORT_TIMESPEC_SIZE      = 16

	'' pthread_attr_t is 56 bytes on glibc x86-64, and PTHREAD_STACK_MIN is
	'' 16384 there. The minimum matters: pthread_attr_setstacksize REJECTS a
	'' smaller value outright, so a caller asking for 0 -- which is fbc's own
	'' THREADCREATE default -- would never get a thread.
	const TKORT_PTHREAD_ATTR_SIZE  = 56
	const TKORT_PTHREAD_STACK_MIN  = 16384

	type FBMUTEX
		as ubyte id( 0 to TKORT_PTHREAD_MUTEX_SIZE - 1 )
	end type

	type FBTHREAD
		as ulongint id                 '' pthread_t
		as long     flags
	end type

	type timespec_
		as longint tv_sec
		as longint tv_nsec
	end type

	const CLOCK_REALTIME_  = 0
	const CLOCK_MONOTONIC_ = 1
	const ETIMEDOUT_       = 110
	const SC_NPROCESSORS_ONLN_ = 84

	extern "c"   '' NON-FBCALL: libc and libpthread, not rtlib entry points.
		declare function u_pthread_mutex_init alias "pthread_mutex_init" ( byval m as any ptr, byval a as any ptr ) as long
		declare function u_pthread_mutex_destroy alias "pthread_mutex_destroy" ( byval m as any ptr ) as long
		declare function u_pthread_mutex_lock alias "pthread_mutex_lock" ( byval m as any ptr ) as long
		declare function u_pthread_mutex_unlock alias "pthread_mutex_unlock" ( byval m as any ptr ) as long
		declare function u_pthread_cond_init alias "pthread_cond_init" ( byval c as any ptr, byval a as any ptr ) as long
		declare function u_pthread_cond_destroy alias "pthread_cond_destroy" ( byval c as any ptr ) as long
		declare function u_pthread_cond_signal alias "pthread_cond_signal" ( byval c as any ptr ) as long
		declare function u_pthread_cond_broadcast alias "pthread_cond_broadcast" ( byval c as any ptr ) as long
		declare function u_pthread_cond_wait alias "pthread_cond_wait" ( byval c as any ptr, byval m as any ptr ) as long
		declare function u_pthread_cond_timedwait alias "pthread_cond_timedwait" _
			( byval c as any ptr, byval m as any ptr, byval ts as any ptr ) as long
		declare function u_pthread_condattr_init alias "pthread_condattr_init" ( byval a as any ptr ) as long
		declare function u_pthread_condattr_destroy alias "pthread_condattr_destroy" ( byval a as any ptr ) as long
		declare function u_pthread_condattr_setclock alias "pthread_condattr_setclock" ( byval a as any ptr, byval c as long ) as long
		declare function u_pthread_key_create alias "pthread_key_create" ( byval k as ulong ptr, byval d as any ptr ) as long
		declare function u_pthread_key_delete alias "pthread_key_delete" ( byval k as ulong ) as long
		declare function u_pthread_setspecific alias "pthread_setspecific" ( byval k as ulong, byval v as any ptr ) as long
		declare function u_pthread_getspecific alias "pthread_getspecific" ( byval k as ulong ) as any ptr
		declare function u_pthread_self alias "pthread_self" ( ) as ulongint
		declare function u_pthread_attr_init alias "pthread_attr_init" ( byval a as any ptr ) as long
		declare function u_pthread_attr_destroy alias "pthread_attr_destroy" ( byval a as any ptr ) as long
		declare function u_pthread_attr_setstacksize alias "pthread_attr_setstacksize" _
			( byval a as any ptr, byval n as uinteger ) as long
		declare function u_pthread_create alias "pthread_create" _
			( byval t as ulongint ptr, byval attr as any ptr, byval proc as any ptr, byval arg as any ptr ) as long
		declare function u_pthread_join alias "pthread_join" ( byval t as ulongint, byval ret as any ptr ptr ) as long
		declare function u_pthread_detach alias "pthread_detach" ( byval t as ulongint ) as long
		declare function u_clock_gettime alias "clock_gettime" ( byval clk as long, byval ts as any ptr ) as long
		declare function u_sysconf alias "sysconf" ( byval n as long ) as longint
	end extern

#endif

'' The per-thread FBTHREAD context. One pointer, and fb_AllocateMainFBThread
'' deliberately over-allocates it so the main thread's FBTHREAD lives in the
'' same block -- see thread/self.bas.
type FB_FBTHREADCTX
	as FBTHREAD ptr self_
end type

'' The per-thread cached parker.
type FB_PARKERCTX
	as any ptr parker
end type

extern "rtlib"
	declare function fb_TlsGetCtx alias "fb_TlsGetCtx" _
		( byval index_ as long, byval len_ as uinteger, byval dtor as FB_TLS_DESTRUCTOR ) as any ptr
	declare sub fb_TlsDelCtx alias "fb_TlsDelCtx" ( byval index_ as long )
	declare sub fb_TlsFreeCtxTb alias "fb_TlsFreeCtxTb" ( )

	declare function fb_MutexCreate alias "fb_MutexCreate" ( ) as FBMUTEX ptr
	declare sub fb_MutexDestroy alias "fb_MutexDestroy" ( byval m as FBMUTEX ptr )
	declare sub fb_MutexLock alias "fb_MutexLock" ( byval m as FBMUTEX ptr )
	declare sub fb_MutexUnlock alias "fb_MutexUnlock" ( byval m as FBMUTEX ptr )

	declare function fb_ParkerCreate alias "fb_ParkerCreate" ( ) as any ptr
	declare sub fb_ParkerDestroy alias "fb_ParkerDestroy" ( byval p as any ptr )
end extern

extern "c"   '' NON-FBCALL: internal, and declared plain in fb_private_thread.h.
	declare sub fb_AllocateMainFBThread alias "fb_AllocateMainFBThread" ( )
	declare function fb_AtomicSetThreadFlags alias "fb_AtomicSetThreadFlags" _
		( byval flags as long ptr, byval newFlag as long ) as long
	#ifdef ENABLE_MT
		'' Only in libfbmt.a -- there is no single-threaded definition anywhere,
		'' so referencing it from an ST build would not link.
		declare sub fb_CloseAtomicFBThreadFlagMutex alias "fb_CloseAtomicFBThreadFlagMutex" ( )
	#endif
end extern

'' The runtime's win32-only MT core lock, used for one-time initialisation that
'' must not race. It lives in fbc's win32/hinit.o -- which tiko-rt does not
'' implement -- and exists only in libfbmt.a, so the ST build must expand to
'' nothing rather than to a call.
#if defined( ENABLE_MT ) and (defined( __FB_WIN32__ ) or defined( __FB_WIN64__ ))
	extern "rtlib"
		declare sub fb_MtLock alias "fb_MtLock" ( )
		declare sub fb_MtUnlock alias "fb_MtUnlock" ( )
	end extern
	#define TKORT_MTLOCK()   fb_MtLock()
	#define TKORT_MTUNLOCK() fb_MtUnlock()
#else
	#define TKORT_MTLOCK()
	#define TKORT_MTUNLOCK()
#endif

'' FB_TLSGETCTX( FBTHREAD ) and FB_TLSGETCTX( PARKER ), spelled out. FreeBASIC's
'' macro token-pasting cannot build the three names the C macro does from one
'' argument, and two named macros are clearer than one clever one.
#define TKORT_TLSGET_FBTHREAD() _
	cptr( FB_FBTHREADCTX ptr, fb_TlsGetCtx( FB_TLSKEY_FBTHREAD, sizeof( FB_FBTHREADCTX ), 0 ) )
