'' fbatomic.bi -- atomic read-modify-write on a 32-bit counter
''
'' The smallest primitive set a reference count needs, implemented in
'' src/rtlib/atomic.c where the compiler builtins already live.  This is NOT
'' docs/concurrency/RFC-0002-atomics.md: that specifies FB.Atomic( of T ) with
'' the full C11 MemoryOrder vocabulary and needs changes to all four backends.
'' These three are a call into the runtime, cost a call each, and exist so that
'' fb/sharedptr.bi can be correct under -mt without waiting for that work.
''
'' Every operation is a full sequentially-consistent barrier.  A refcount needs
'' release on the decrement and acquire before the destructor runs; a full
'' barrier is stronger than both.
''
'' LONG, not INTEGER.  FreeBASIC's LONG is 32-bit on every target and matches
'' the C 'int' these are declared with.  INTEGER is 64-bit on win64 and 32-bit
'' on win32, so it would be right on one and silently wrong on the other.

#pragma once

namespace FB

'' EXTERN "C" is required: inside a namespace, ALIAS sets the base identifier
'' but FreeBASIC still applies namespace mangling on top of it.
'' FBCALL is __stdcall on 32-bit Windows and nothing everywhere else, so the
'' runtime exports _fb_Foo@N there and fb_Foo elsewhere.  An EXTERN "C" block
'' forces cdecl and fails to link on win32 ONLY -- and ALIAS does not rescue it,
'' because inside a NAMESPACE fbc mangles past the alias.  So match the
'' convention rather than fight it.
''
'' Copied from fbclaim.bi rather than re-derived: it was found by rebuilding the
'' win32 toolchain, not by any win64 test, because win64 has one calling
'' convention and cannot tell the two apart.
#ifdef __FB_WIN32__
	#ifdef __FB_64BIT__
		extern "C"
	#else
		extern "Windows"
	#endif
#else
	extern "C"
#endif

'' Adds v to *p and returns the value held BEFORE the add, which is what makes
'' "was I the last reference?" a single atomic step: pass -1 and test the
'' result against 1.
declare function AtomicFetchAddLong alias "fb_AtomicFetchAddLong" _
          ( byval p as long ptr, byval v as long ) as long

'' Stores 'desired' if *p equals 'expected'.  Returns the value held before, so
'' success is (result = expected).  Needed for increment-if-not-zero, which is
'' WeakPtr.Lock( ) and cannot be built from fetch-add.
declare function AtomicCasLong alias "fb_AtomicCasLong" _
          ( byval p as long ptr, byval expected as long, byval desired as long ) as long

'' An ordered read.  Exists for the barrier, not the atomicity -- an aligned
'' 32-bit load is already atomic; without this the compiler may cache or hoist
'' the read of a counter another thread is writing.
declare function AtomicLoadLong alias "fb_AtomicLoadLong" _
          ( byval p as long ptr ) as long

end extern

end namespace
