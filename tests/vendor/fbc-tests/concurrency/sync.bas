'' FB.WaitGroup and FB.Context -- RFC-0005 section 5.
''
'' NEEDS -mt, which unit-tests.mk already passes on every target but DOS.
''
'' NOT ASSERTED HERE, and each is deliberate:
''
''   - Done( ) below zero, which RAISES and so ends the process:
''     docs/tests/concurrency/sync_raise_donebelowzero.bas.
''   - Copying a WaitGroup, and the directional-channel misuse cases, which are
''     COMPILE errors: docs/tests/concurrency/sync_err_*.bas.

#include "fbcunit.bi"

#ifndef __FB_DOS__

#include once "fb/sync.bi"
#include once "fb/select.bi"

using FB

dim shared as WaitGroup       g_wg
dim shared as WaitGroup       g_slow
dim shared as Channel( of long ) g_ack
dim shared as long            g_sum
dim shared as any ptr         g_lock

private sub adder( byval n as long )
	MutexLock( g_lock )
	g_sum += n
	MutexUnlock( g_lock )
	g_wg.Done( )
end sub

private sub sleeper( byval ms as long )
	sleep ms, 1
	g_slow.Done( )
end sub

'' Polls a context rather than selecting on it, which is the other of the two
'' ways cancellation is meant to be observed.
private sub poller( byval ctx as Context )
	do
		if( ctx.IsCancelled( ) ) then exit do
		sleep 5, 1
	loop
	g_ack.Send( 1 )
end sub

'' Blocks in SELECT on the context's Done( ) channel. A nil channel case is
'' included so that a select that fired the wrong case is distinguishable from
'' one that fired nothing.
private sub selector( byval ctx as Context )
	dim never as Channel( of long )          '' nil: permanently not ready
	dim as long v
	select channel
		case receive v from never     : g_ack.Send( 0 )
		case receive from ctx.Done( ) : g_ack.Send( 1 )
		case timeout 20000            : g_ack.Send( 2 )
	end select
end sub

SUITE( fbc_tests.concurrency.sync )

	'' ------------------------------------------------------------- WaitGroup

	'' Wait returns only after every counted goroutine has called Done, and
	'' everything each of them did BEFORE its Done is visible afterwards with no
	'' other synchronisation. A sum computed under a mutex is the cheapest thing
	'' that notices a Wait which returned early.
	TEST( waitgroup_counts_and_publishes )
		const N = 1000

		g_sum = 0
		g_lock = MutexCreate( )

		for i as long = 1 to N
			g_wg.Add( )
			spawn adder( i )
		next
		g_wg.Wait( )

		CU_ASSERT_EQUAL( g_sum, N * ( N + 1 ) \ 2 )
		CU_ASSERT_EQUAL( g_wg.Count( ), 0 )

		MutexDestroy( g_lock )
		g_lock = 0
	END_TEST

	'' Add takes a DELTA, so a fan-out can be counted in one call rather than
	'' one per goroutine -- and the counter must land back on zero either way.
	TEST( waitgroup_add_takes_a_delta )
		const N = 200

		g_sum = 0
		g_lock = MutexCreate( )

		g_wg.Add( N )
		CU_ASSERT_EQUAL( g_wg.Count( ), N )

		for i as long = 1 to N
			spawn adder( i )
		next
		g_wg.Wait( )

		CU_ASSERT_EQUAL( g_sum, N * ( N + 1 ) \ 2 )
		CU_ASSERT_EQUAL( g_wg.Count( ), 0 )

		MutexDestroy( g_lock )
		g_lock = 0
	END_TEST

	'' Wait on a ZERO counter must return at once. A version that waited for a
	'' Done that will never come would deadlock the whole suite here.
	TEST( waitgroup_zero_does_not_block )
		dim wg as WaitGroup

		CU_ASSERT_EQUAL( wg.Count( ), 0 )

		dim as double t0 = timer
		wg.Wait( )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		'' and again, repeatedly -- Wait is not one-shot
		for i as long = 1 to 20
			wg.Wait( )
		next
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )

		'' Add then Done then Wait, with no goroutine in sight
		wg.Add( 3 )
		CU_ASSERT_EQUAL( wg.Count( ), 3 )
		wg.Done( ) : wg.Done( ) : wg.Done( )
		CU_ASSERT_EQUAL( wg.Count( ), 0 )
		wg.Wait( )
	END_TEST

	'' WaitFor is Wait with a deadline: FALSE means it ran out, TRUE means the
	'' group finished. Both answers have to be produced against a real worker,
	'' or a version that always returned one of them would pass.
	TEST( waitgroup_waitfor_both_outcomes )
		g_slow.Add( )
		spawn sleeper( 600 )

		'' too short: it must give up and say so, without reaping the worker
		dim as double t0 = timer
		CU_ASSERT_FALSE( g_slow.WaitFor( 150 ) )
		dim as double waited = ( timer - t0 ) * 1000
		CU_ASSERT_TRUE( waited >= 100 )

		'' long enough: it must succeed
		CU_ASSERT_TRUE( g_slow.WaitFor( 20000 ) )
		CU_ASSERT_EQUAL( g_slow.Count( ), 0 )

		'' on a zero counter it succeeds immediately, whatever the deadline
		dim wg as WaitGroup
		t0 = timer
		CU_ASSERT_TRUE( wg.WaitFor( 20000 ) )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		'' A DEADLINE OF ZERO IS A POLL, not an infinite wait -- the same rule as
		'' Channel.SendFor( v, 0 ). The two spellings sit next to each other in
		'' ordinary code, and WaitFor( 0 ) used to mean "forever", which is a
		'' hang rather than an answer. Wait( ) is how forever is spelled.
		CU_ASSERT_EQUAL( wg.Count( ), 0 )
		t0 = timer
		CU_ASSERT_TRUE( wg.WaitFor( 0 ) )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		wg.Add( 1 )
		t0 = timer
		CU_ASSERT_FALSE( wg.WaitFor( 0 ) )       '' MUST return, not block
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		'' and a short non-zero deadline behaves the same way on a live counter
		CU_ASSERT_FALSE( wg.WaitFor( 50 ) )
		wg.Done( )
		CU_ASSERT_TRUE( wg.WaitFor( 0 ) )
		CU_ASSERT_TRUE( wg.WaitFor( 50 ) )

		'' Wait( ) still means forever, and on a zero counter still returns at
		'' once -- the two are no longer the same code path
		wg.Wait( )
		CU_ASSERT_EQUAL( wg.Count( ), 0 )
	END_TEST

	'' --------------------------------------------------------------- Context

	'' The BACKGROUND context is never cancelled and its Done( ) is a NIL
	'' channel -- permanently not ready, so a Done case on a context that can
	'' never be cancelled is a permanently disabled select case rather than one
	'' that fires immediately.
	TEST( background_context_is_inert )
		dim bg as Context

		CU_ASSERT_FALSE( bg.IsCancelled( ) )
		CU_ASSERT_EQUAL( bg.Err( ), "" )
		CU_ASSERT_TRUE( bg.Done( ).IsNil( ) )
		CU_ASSERT_FALSE( bg.Done( ).IsClosed( ) )
	END_TEST

	'' Cancel is IDEMPOTENT, unlike Channel.Close -- a deferred Cancel on a
	'' context that was already cancelled must not raise, or 'defer' would be
	'' unusable with it.
	TEST( context_cancel_is_idempotent )
		dim ctx as CancelContext = WithCancel( Context( ) )

		CU_ASSERT_FALSE( ctx.IsCancelled( ) )
		CU_ASSERT_EQUAL( ctx.Err( ), "" )

		ctx.Cancel( )
		CU_ASSERT_TRUE( ctx.IsCancelled( ) )
		CU_ASSERT_EQUAL( ctx.Err( ), "cancelled" )

		for i as long = 1 to 5
			ctx.Cancel( )
		next
		CU_ASSERT_TRUE( ctx.IsCancelled( ) )
		CU_ASSERT_EQUAL( ctx.Err( ), "cancelled" )
	END_TEST

	'' Cancellation runs DOWN the tree and never up.
	TEST( context_propagates_down_only )
		dim parent_ as CancelContext = WithCancel( Context( ) )
		dim child   as CancelContext = WithCancel( parent_ )
		dim grand   as CancelContext = WithCancel( child )

		parent_.Cancel( )
		CU_ASSERT_TRUE( child.IsCancelled( ) )
		CU_ASSERT_TRUE( grand.IsCancelled( ) )

		dim p2 as CancelContext = WithCancel( Context( ) )
		dim c2 as CancelContext = WithCancel( p2 )
		c2.Cancel( )
		CU_ASSERT_TRUE( c2.IsCancelled( ) )
		CU_ASSERT_FALSE( p2.IsCancelled( ) )

		'' a context derived from an ALREADY-cancelled parent is born cancelled,
		'' with its Done( ) already closed
		dim p3 as CancelContext = WithCancel( Context( ) )
		p3.Cancel( )
		dim c3 as CancelContext = WithCancel( p3 )
		CU_ASSERT_TRUE( c3.IsCancelled( ) )

		dim as boolean fired = FALSE
		select channel
			case receive from c3.Done( ) : fired = TRUE
			case else                    : fired = FALSE
		end select
		CU_ASSERT_TRUE( fired )
	END_TEST

	'' WithTimeout cancels itself when the deadline passes, and reports a
	'' DIFFERENT Err from an explicit Cancel -- the two are not interchangeable
	'' to a caller deciding whether to retry.
	TEST( context_timeout_fires_and_names_itself )
		dim ctx as CancelContext = WithTimeout( Context( ), 200 )

		CU_ASSERT_FALSE( ctx.IsCancelled( ) )

		dim as double t0 = timer
		do
			if( ctx.IsCancelled( ) ) then exit do
			sleep 5, 1
		loop until ( timer - t0 ) > 10

		CU_ASSERT_TRUE( ctx.IsCancelled( ) )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 >= 150 )
		CU_ASSERT_EQUAL( ctx.Err( ), "deadline exceeded" )

		'' its Done( ) is closed, so a select on it is ready without blocking
		dim as boolean fired = FALSE
		select channel
			case receive from ctx.Done( ) : fired = TRUE
			case else                     : fired = FALSE
		end select
		CU_ASSERT_TRUE( fired )
	END_TEST

	'' The two ways a goroutine is meant to observe cancellation: POLLING
	'' IsCancelled, and SELECTING on Done( ). Both must wake.
	TEST( context_cancellation_is_observed )
		'' polling
		g_ack = Channel( of long )( 4 )
		dim c1 as CancelContext = WithCancel( Context( ) )
		spawn poller( c1 )
		sleep 60, 1
		CU_ASSERT_FALSE( c1.IsCancelled( ) )
		c1.Cancel( )

		dim as long v = -1
		CU_ASSERT_TRUE( g_ack.ReceiveFor( v, 20000 ) )
		CU_ASSERT_EQUAL( v, 1 )

		'' selecting -- Done( ) is a channel precisely so that this composes
		g_ack = Channel( of long )( 4 )
		dim c2 as CancelContext = WithCancel( Context( ) )
		spawn selector( c2 )
		sleep 100, 1
		c2.Cancel( )

		v = -1
		CU_ASSERT_TRUE( g_ack.ReceiveFor( v, 20000 ) )
		CU_ASSERT_EQUAL( v, 1 )              '' the Done case, not the timeout

		g_ack.Close( )
	END_TEST

END_SUITE

#endif
