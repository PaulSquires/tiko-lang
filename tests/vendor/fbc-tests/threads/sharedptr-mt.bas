#include "fbcunit.bi"

'' FB.SharedPtr( of T ) under -mt: the ATOMIC side of the __FB_MT__ gate.
''
'' container-sharedptr.bas is a log-test and log-tests do not build with -mt, so
'' it exercises the plain-counter path only.  This file is a unit test, and the
'' unit-test makefile compiles everything with -mt, so here the counts go
'' through the rtlib atomics in fbatomic.bi.
''
'' What is actually being tested is that a refcount increment or decrement is
'' not a read-modify-write that another thread can interleave with.  With a
'' plain 'count += 1' these tests fail: the final live-object count comes out
'' non-zero (a lost decrement leaks) or the process double-frees (a lost
'' increment destroys an object somebody still holds).
''
'' Note that the guarantee under test covers the CONTROL BLOCK only.  Nothing
'' here mutates a shared Probe from two threads at once, because SharedPtr does
'' not make that safe -- that is the caller's lock to take, exactly as in C++.

#ifndef __FB_DOS__

#include once "fb/sharedptr.bi"
using FB

SUITE( fbc_tests.threads.sharedptr_mt )

	const NUM_THREADS = 8
	const NUM_ITERS   = 20000

	dim shared as long liveProbe

	type Probe
		as long v
		declare constructor( )
		declare destructor( )
	end type

	constructor Probe( )
		this.v = 0
		liveProbe += 1
	end constructor

	destructor Probe( )
		liveProbe -= 1
	end destructor

	'' The handle every thread copies from.  Read-only once the threads start.
	dim shared as SharedPtr( of Probe ) g_shared
	dim shared as WeakPtr( of Probe ) g_weak

	'' ------------------------------------------------ contended copy/destroy

	declare sub CopyHammer( byval arg as any ptr )

	TEST_GROUP( contended_copy )

		TEST( copy_and_destroy )
			dim as any ptr htb( 0 to NUM_THREADS-1 )

			liveProbe = 0
			g_shared = MakeShared( of Probe )( )
			g_shared->v = 5
			CU_ASSERT_EQUAL( liveProbe, 1 )
			CU_ASSERT_EQUAL( g_shared.UseCount( ), 1 )

			for i as integer = 0 to NUM_THREADS-1
				htb( i ) = threadcreate( @CopyHammer, 0 )
				if( htb( i ) = 0 ) then
					CU_FAIL_FATAL( "threadcreate failed: " & i )
					end
				end if
			next

			for i as integer = 0 to NUM_THREADS-1
				threadwait( htb( i ) )
			next

			'' Every copy made must have been released exactly once.  A lost
			'' increment would have destroyed the object early (liveProbe = 0
			'' and very likely a crash); a lost decrement leaves the count high.
			CU_ASSERT_EQUAL( g_shared.UseCount( ), 1 )
			CU_ASSERT_EQUAL( liveProbe, 1 )
			CU_ASSERT_EQUAL( g_shared->v, 5 )

			g_shared.Reset( )
			CU_ASSERT_EQUAL( liveProbe, 0 )
		END_TEST

	END_TEST_GROUP

	sub CopyHammer( byval arg as any ptr )
		for i as integer = 1 to NUM_ITERS
			dim as SharedPtr( of Probe ) local_ = g_shared
			'' touch it so the copy cannot be optimised away
			if( local_->v <> 5 ) then
				liveProbe = -999            '' poison; asserted in the caller
			end if
		next
	end sub

	'' ------------------------------------------------- contended weak Lock( )

	declare sub LockHammer( byval arg as any ptr )

	dim shared as long g_lockOk, g_lockNull

	TEST_GROUP( contended_lock )

		'' Lock( ) races the last Reset( ).  Each thread must get either a
		'' fully valid handle or a null one -- never a handle to a destroyed
		'' object.  That is the increment-if-not-zero, and it is the reason
		'' hRefIncIfLive needs compare-and-swap rather than a plain increment.
		TEST( lock_while_alive )
			dim as any ptr htb( 0 to NUM_THREADS-1 )

			liveProbe = 0
			g_lockOk = 0 : g_lockNull = 0

			g_shared = MakeShared( of Probe )( )
			g_shared->v = 7
			g_weak = g_shared
			CU_ASSERT_EQUAL( g_weak.Expired( ), FALSE )

			for i as integer = 0 to NUM_THREADS-1
				htb( i ) = threadcreate( @LockHammer, 0 )
			next

			for i as integer = 0 to NUM_THREADS-1
				threadwait( htb( i ) )
			next

			'' the object was alive throughout, so every Lock( ) succeeded
			CU_ASSERT_EQUAL( g_lockNull, 0 )
			CU_ASSERT_EQUAL( g_lockOk, NUM_THREADS * 100 )
			CU_ASSERT_EQUAL( g_shared.UseCount( ), 1 )
			CU_ASSERT_EQUAL( liveProbe, 1 )

			'' and after the last strong handle goes, every weak view agrees
			g_shared.Reset( )
			CU_ASSERT_EQUAL( liveProbe, 0 )
			CU_ASSERT_EQUAL( g_weak.Expired( ), TRUE )

			dim as SharedPtr( of Probe ) l = g_weak.Lock( )
			CU_ASSERT_EQUAL( l.IsNull( ), TRUE )

			g_weak.Reset( )
		END_TEST

	END_TEST_GROUP

	'' The tally itself is contended, so it goes through the same atomics the
	'' refcount does.  A plain '+= 1' here would lose counts and make the
	'' assertion flaky -- and a flaky test that fails once a month is worse
	'' than no test, because it trains you to re-run it.
	sub LockHammer( byval arg as any ptr )
		for i as integer = 1 to 100
			dim as SharedPtr( of Probe ) l = g_weak.Lock( )
			if( l.IsNull( ) ) then
				AtomicFetchAddLong( @g_lockNull, 1 )
			else
				AtomicFetchAddLong( @g_lockOk, 1 )
			end if
		next
	end sub

END_SUITE

#endif
