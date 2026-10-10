'' The goroutine scheduler and SELECT -- RFC-0003 and RFC-0004.
''
'' SPAWN and SELECT are statements the compiler lowers, so what is asserted
'' here is the RUNTIME surface behind them -- GoroutineCount, WorkerCount, and
'' the SelectCtx machinery a lowered SELECT drives -- plus the observable
'' behaviour of the statements themselves.
''
'' NEEDS -mt, which unit-tests.mk already passes on every target but DOS.
''
'' NOT ASSERTED HERE, and each is deliberate:
''
''   - Every SPAWN and SELECT COMPILE error: docs/tests/concurrency/spawn_err_*.bas
''     and select_err_*.bas.
''   - Scheduler shutdown at process exit, which by definition cannot be
''     observed from inside the process: docs/tests/concurrency/sched_exit_test.bas.

#import "std/tasks"
#include "fbcunit.bi"

#ifndef __FB_DOS__

#include once "fberror.bi"

#include once "fbpark.bi"

#include once "fbclaim.bi"

using tasks

using FB
dim shared as WaitGroup          g_wg
dim shared as Channel( of long ) g_out
dim shared as Channel( of long ) g_a
dim shared as Channel( of long ) g_b
dim shared as long               g_seen

private sub tally( byval n as long )
	g_out.Send( n )
	g_wg.Done( )
end sub

private sub nested( byval depth as long )
	if( depth > 0 ) then
		g_wg.Add( )
		spawn nested( depth - 1 )
	end if
	g_out.Send( depth )
	g_wg.Done( )
end sub

private sub feeder( byval which_ as long )
	sleep 80, 1
	if( which_ = 0 ) then g_a.Send( 10 ) else g_b.Send( 20 )
	g_wg.Done( )
end sub

SUITE( fbc_tests.concurrency.sched )

	'' -------------------------------------------------------- the worker pool

	'' WorkerCount is the size of the OS-thread pool the scheduler multiplexes
	'' goroutines onto. It is fixed for the process, so a caller can size a fan-
	'' out against it -- which is only sound if it never changes underfoot.
	TEST( workercount_is_positive_and_stable )
		dim as long w = WorkerCount( )

		CU_ASSERT_TRUE( w >= 1 )
		CU_ASSERT_TRUE( w < 4096 )              '' a sane upper bound

		for i as long = 1 to 20
			CU_ASSERT_EQUAL( WorkerCount( ), w )
		next

		'' spawning does not change the POOL -- that is the whole point of
		'' multiplexing rather than one thread per goroutine
		g_out = Channel( of long )( 256 )
		g_wg.Add( 64 )
		for i as long = 1 to 64
			spawn tally( i )
		next
		g_wg.Wait( )
		CU_ASSERT_EQUAL( WorkerCount( ), w )

		g_out.Close( )
	END_TEST

	'' GoroutineCount is a LIVE count, so it rises with outstanding work and
	'' comes back down. Asserted as a bound and a return-to-baseline rather than
	'' an exact reading, which would be a race with the scheduler.
	TEST( goroutinecount_rises_and_returns )
		dim as long base_ = GoroutineCount( )
		CU_ASSERT_TRUE( base_ >= 0 )

		'' hold 32 goroutines open on an unbuffered channel nobody reads yet
		g_out = Channel( of long )( 0 )
		g_wg.Add( 32 )
		for i as long = 1 to 32
			spawn tally( i )
		next

		'' they are all blocked in Send, so the count must have moved
		dim as double t0 = timer
		dim as boolean rose = FALSE
		do
			if( GoroutineCount( ) > base_ ) then rose = TRUE : exit do
			sleep 5, 1
		loop until ( timer - t0 ) > 10
		CU_ASSERT_TRUE( rose )

		'' drain them and the count must come back
		dim as long v, sum = 0
		for i as long = 1 to 32
			CU_ASSERT_TRUE( g_out.ReceiveFor( v, 20000 ) )
			sum += v
		next
		g_wg.Wait( )
		CU_ASSERT_EQUAL( sum, 32 * 33 \ 2 )

		t0 = timer
		do
			if( GoroutineCount( ) <= base_ ) then exit do
			sleep 5, 1
		loop until ( timer - t0 ) > 10
		CU_ASSERT_TRUE( GoroutineCount( ) <= base_ )

		g_out.Close( )
	END_TEST

	'' A goroutine may SPAWN, so the scheduler cannot assume work is only
	'' submitted from outside the pool. Blocking on the pool's own thread would
	'' deadlock this immediately.
	TEST( goroutines_may_spawn_goroutines )
		const DEPTH = 20

		g_out = Channel( of long )( 64 )
		g_wg.Add( )
		spawn nested( DEPTH )

		dim as long n = 0, v
		for i as long = 0 to DEPTH
			CU_ASSERT_TRUE( g_out.ReceiveFor( v, 20000 ) )
			n += 1
		next
		g_wg.Wait( )

		CU_ASSERT_EQUAL( n, DEPTH + 1 )
		g_out.Close( )
	END_TEST

	'' ----------------------------------------------------------------- SELECT

	'' CASE ELSE makes SELECT non-blocking: when nothing is ready it runs the
	'' else branch instead of waiting. This is the SetElse path in SelectCtx.
	TEST( select_else_never_blocks )
		dim ch as Channel( of long ) = Channel( of long )( 1 )
		dim as long v, fired = -1

		'' empty: the else branch
		dim as double t0 = timer
		select channel
			case receive v from ch : fired = 0
			case else              : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 1 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		'' ready: the receive branch, even though an else is present
		ch.TrySend( 7 )
		fired = -1
		select channel
			case receive v from ch : fired = 0
			case else              : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 0 )
		CU_ASSERT_EQUAL( v, 7 )

		'' a SEND case with an else, against a full channel
		ch.TrySend( 1 )
		fired = -1
		select channel
			case send 2 to ch : fired = 0
			case else         : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 1 )

		ch.Close( )
	END_TEST

	'' CASE TIMEOUT is the SetTimeout path: it fires only when nothing else has
	'' become ready inside the deadline, and it must NOT fire when something has.
	TEST( select_timeout_is_the_last_resort )
		dim ch as Channel( of long ) = Channel( of long )( 1 )
		dim as long v, fired = -1

		'' nothing ready: the timeout wins, and it really waits
		dim as double t0 = timer
		select channel
			case receive v from ch : fired = 0
			case timeout 200       : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 1 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 >= 150 )

		'' already ready: the receive wins immediately
		ch.TrySend( 5 )
		fired = -1
		t0 = timer
		select channel
			case receive v from ch : fired = 0
			case timeout 20000     : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 0 )
		CU_ASSERT_EQUAL( v, 5 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )

		ch.Close( )
	END_TEST

	'' A NIL channel case is permanently not ready, which is how a case is
	'' disabled at runtime -- and it must not make the whole SELECT block when
	'' another case can proceed.
	TEST( select_nil_case_is_disabled )
		dim never as Channel( of long )                        '' nil
		dim ready as Channel( of long ) = Channel( of long )( 1 )
		ready.TrySend( 3 )

		dim as long v, w, fired = -1
		select channel
			case receive v from never : fired = 0
			case receive w from ready : fired = 1
			case timeout 20000        : fired = 2
		end select

		CU_ASSERT_EQUAL( fired, 1 )
		CU_ASSERT_EQUAL( w, 3 )

		'' with only nil cases and an else, the else fires at once
		fired = -1
		dim as double t0 = timer
		select channel
			case receive v from never : fired = 0
			case else                 : fired = 1
		end select
		CU_ASSERT_EQUAL( fired, 1 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 500 )

		ready.Close( )
	END_TEST

	'' A BLOCKING select -- no else, no timeout that fires -- must park until a
	'' case becomes ready, and then take the one that did. This is the path the
	'' polled forms above never exercise.
	TEST( select_parks_until_a_case_is_ready )
		g_a = Channel( of long )( 1 )
		g_b = Channel( of long )( 1 )

		'' only the B feeder runs, so the B case must be the one that fires
		g_wg.Add( )
		spawn feeder( 1 )

		dim as long v, w, fired = -1
		select channel
			case receive v from g_a : fired = 0
			case receive w from g_b : fired = 1
			case timeout 20000      : fired = 2
		end select
		g_wg.Wait( )

		CU_ASSERT_EQUAL( fired, 1 )
		CU_ASSERT_EQUAL( w, 20 )

		'' and now the A side
		g_wg.Add( )
		spawn feeder( 0 )

		fired = -1
		select channel
			case receive v from g_a : fired = 0
			case receive w from g_b : fired = 1
			case timeout 20000      : fired = 2
		end select
		g_wg.Wait( )

		CU_ASSERT_EQUAL( fired, 0 )
		CU_ASSERT_EQUAL( v, 10 )

		g_a.Close( )
		g_b.Close( )
	END_TEST

	'' A closed channel is PERMANENTLY READY to receive, so a select over one
	'' must fire that case rather than time out -- which is what makes close
	'' usable as a broadcast in a select loop.
	TEST( select_sees_a_closed_channel_as_ready )
		dim ch as Channel( of long ) = Channel( of long )( 1 )
		ch.Close( )

		dim as long v, fired = -1
		dim as double t0 = timer
		select channel
			case receive v from ch : fired = 0
			case timeout 20000     : fired = 1
		end select

		CU_ASSERT_EQUAL( fired, 0 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )
	END_TEST

END_SUITE

#endif
