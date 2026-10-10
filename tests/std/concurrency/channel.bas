'' tasks.Channel( of T ), its directional views and its iterator -- RFC-0002.
''
'' The standalone programs under docs/tests/concurrency cover the cases that
'' cannot live in a shared process: every operation that RAISES aborts, and
'' every compile-error case has to fail to compile. What is asserted HERE is
'' everything a running suite can observe -- the non-blocking and timed forms,
'' the close protocol, capacity and count, the directional views, and the
'' iterator that FOR EACH is sugar for.
''
'' NEEDS -mt, which unit-tests.mk already passes on every target but DOS.
''
'' NOT ASSERTED HERE, and each is deliberate:
''
''   - Send / TrySend / SendFor on a CLOSED channel, and Close on a nil or
''     already-closed channel. All four RAISE, which ends the process; they are
''     docs/tests/concurrency/channel_raise_*.bas.
''   - The unbuffered rendezvous under real contention, which is sched.bas's
''     subject rather than the channel's.

#import "std/tasks"
#include "fbcunit.bi"

#ifndef __FB_DOS__

#include once "fberror.bi"

#include once "fbpark.bi"

#include once "fbclaim.bi"

using tasks

using FB
'' A UDT payload, at FILE SCOPE. A generic instantiated on a type declared
'' INSIDE a procedure recurses until fbc gives up with "Recursion level too
'' deep": the type has to be visible where the instantiation is emitted.
type Payload
	as long   id
	as string name
end type

dim shared as Channel( of long ) g_pipe
dim shared as Channel( of long ) g_ack
dim shared as WaitGroup          g_wg

private sub producer( byval n as long )
	for i as long = 1 to n
		g_pipe.Send( i )
	next
	g_pipe.Close( )
	g_wg.Done( )
end sub

private sub consumer( byval expected as long )
	dim as long got = 0, sum = 0, v
	while( g_pipe.Receive( v ) )
		got += 1
		sum += v
	wend
	g_ack.Send( got )
	g_ack.Send( sum )
	g_wg.Done( )
end sub

private sub late_sender( byval ms as long )
	sleep ms, 1
	g_pipe.Send( 99 )
	g_wg.Done( )
end sub

private sub late_receiver( byval ms as long )
	sleep ms, 1
	dim as long v
	g_pipe.Receive( v )
	g_ack.Send( v )
	g_wg.Done( )
end sub

SUITE( fbc_tests.concurrency.chans )

	'' ------------------------------------------------------- shape and state

	'' A DEFAULT-CONSTRUCTED channel is NIL, and nil is not a error state: send
	'' and receive on it block forever, which is precisely what lets SELECT
	'' disable a case by nilling its channel.
	TEST( nil_channel_is_the_default )
		dim ch as Channel( of long )

		CU_ASSERT_TRUE( ch.IsNil( ) )
		CU_ASSERT_FALSE( ch.IsClosed( ) )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )
		CU_ASSERT_EQUAL( ch.Capacity( ), 0 )

		'' the NON-BLOCKING forms are the only ones that can be asked about a
		'' nil channel from a single thread, and they are never ready
		dim as long v = 7
		CU_ASSERT_FALSE( ch.TrySend( v ) )
		CU_ASSERT_FALSE( ch.TryReceive( v ) )
		CU_ASSERT_EQUAL( v, 7 )                  '' out is left ALONE

		'' the timed forms time out rather than succeeding or raising
		CU_ASSERT_FALSE( ch.SendFor( v, 20 ) )
		CU_ASSERT_FALSE( ch.ReceiveFor( v, 20 ) )

		'' assignment makes it a real channel, and it stops being nil
		ch = Channel( of long )( 2 )
		CU_ASSERT_FALSE( ch.IsNil( ) )
		CU_ASSERT_EQUAL( ch.Capacity( ), 2 )
	END_TEST

	TEST( capacity_and_count_track_the_buffer )
		dim ch as Channel( of long ) = Channel( of long )( 3 )

		CU_ASSERT_EQUAL( ch.Capacity( ), 3 )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )

		for i as long = 1 to 3
			CU_ASSERT_TRUE( ch.TrySend( i ) )
			CU_ASSERT_EQUAL( ch.Count( ), i )
		next

		'' full: TrySend must REFUSE rather than block or grow the buffer
		dim as long four = 4
		CU_ASSERT_FALSE( ch.TrySend( four ) )
		CU_ASSERT_EQUAL( ch.Count( ), 3 )
		CU_ASSERT_EQUAL( ch.Capacity( ), 3 )

		'' FIFO, and Count falls as it drains
		dim as long v
		for i as long = 1 to 3
			CU_ASSERT_TRUE( ch.TryReceive( v ) )
			CU_ASSERT_EQUAL( v, i )
			CU_ASSERT_EQUAL( ch.Count( ), 3 - i )
		next

		'' empty: TryReceive refuses and leaves the out parameter alone
		v = -1
		CU_ASSERT_FALSE( ch.TryReceive( v ) )
		CU_ASSERT_EQUAL( v, -1 )

		ch.Close( )
	END_TEST

	'' An UNBUFFERED channel has capacity zero and buffers nothing: TrySend
	'' fails with no receiver waiting, which is the rendezvous rule seen from
	'' one thread.
	TEST( unbuffered_has_no_buffer )
		dim ch as Channel( of long ) = Channel( of long )( 0 )

		CU_ASSERT_FALSE( ch.IsNil( ) )
		CU_ASSERT_EQUAL( ch.Capacity( ), 0 )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )

		dim as long v = 1
		CU_ASSERT_FALSE( ch.TrySend( v ) )
		CU_ASSERT_FALSE( ch.TryReceive( v ) )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )

		ch.Close( )
	END_TEST

	'' ------------------------------------------------------- the close protocol

	'' Close is a BROADCAST, not a destructor. Buffered values survive it and
	'' are handed out first; only then does Receive start reporting FALSE.
	TEST( close_drains_then_reports_false )
		dim ch as Channel( of long ) = Channel( of long )( 4 )

		for i as long = 1 to 3
			ch.TrySend( i )
		next
		CU_ASSERT_FALSE( ch.IsClosed( ) )

		ch.Close( )
		CU_ASSERT_TRUE( ch.IsClosed( ) )

		'' the buffer is still there, and still in order
		CU_ASSERT_EQUAL( ch.Count( ), 3 )
		dim as long v
		for i as long = 1 to 3
			CU_ASSERT_TRUE( ch.Receive( v ) )
			CU_ASSERT_EQUAL( v, i )
		next

		'' drained AND closed: FALSE, forever, without blocking
		v = -1
		CU_ASSERT_FALSE( ch.Receive( v ) )
		CU_ASSERT_FALSE( ch.Receive( v ) )
		CU_ASSERT_FALSE( ch.TryReceive( v ) )
		CU_ASSERT_FALSE( ch.ReceiveFor( v, 20 ) )
		CU_ASSERT_EQUAL( v, -1 )

		'' and IsClosed keeps saying so
		CU_ASSERT_TRUE( ch.IsClosed( ) )
		CU_ASSERT_FALSE( ch.IsNil( ) )
	END_TEST

	'' A closed EMPTY channel never blocks a receiver -- that is what makes
	'' close usable as a broadcast wake-up.
	TEST( closed_empty_never_blocks )
		dim ch as Channel( of long ) = Channel( of long )( 2 )
		ch.Close( )

		dim as double t0 = timer
		dim as long v
		for i as long = 1 to 50
			CU_ASSERT_FALSE( ch.Receive( v ) )
		next
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )
	END_TEST

	'' ------------------------------------------------------- the timed forms

	'' SendFor and ReceiveFor return FALSE ON TIMEOUT and TRUE on success, so
	'' the timeout is distinguishable from a closed channel only by IsClosed --
	'' which is why both are tested against a real deadline here.
	TEST( timed_forms_respect_the_deadline )
		dim ch as Channel( of long ) = Channel( of long )( 1 )

		'' succeeds immediately when there is room
		dim as long v = 5
		dim as double t0 = timer
		CU_ASSERT_TRUE( ch.SendFor( v, 5000 ) )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )

		'' now full: the second send must wait out its deadline and fail
		t0 = timer
		CU_ASSERT_FALSE( ch.SendFor( v, 150 ) )
		dim as double waited = ( timer - t0 ) * 1000
		CU_ASSERT_TRUE( waited >= 100 )
		CU_ASSERT_TRUE( waited < 5000 )

		'' receiving succeeds immediately while there is something there
		dim as long got = -1
		t0 = timer
		CU_ASSERT_TRUE( ch.ReceiveFor( got, 5000 ) )
		CU_ASSERT_EQUAL( got, 5 )
		CU_ASSERT_TRUE( ( timer - t0 ) * 1000 < 1000 )

		'' and now empty: it waits out the deadline
		t0 = timer
		CU_ASSERT_FALSE( ch.ReceiveFor( got, 150 ) )
		waited = ( timer - t0 ) * 1000
		CU_ASSERT_TRUE( waited >= 100 )
		CU_ASSERT_EQUAL( got, 5 )                '' unchanged on timeout

		'' a ZERO deadline is the non-blocking form spelled differently
		CU_ASSERT_FALSE( ch.ReceiveFor( got, 0 ) )
		CU_ASSERT_TRUE( ch.SendFor( v, 0 ) )
		CU_ASSERT_FALSE( ch.SendFor( v, 0 ) )

		ch.Close( )
	END_TEST

	'' The timed forms must also SUCCEED when the other side turns up inside
	'' the deadline -- a version that simply slept would pass every test above.
	TEST( timed_forms_wake_on_the_other_side )
		g_pipe = Channel( of long )( 0 )         '' unbuffered: a real rendezvous
		g_ack  = Channel( of long )( 4 )

		'' a receiver arrives after 100 ms; a 5 s send must catch it
		g_wg.Add( )
		spawn late_receiver( 100 )
		dim as long v = 42
		CU_ASSERT_TRUE( g_pipe.SendFor( v, 10000 ) )
		g_wg.Wait( )

		dim as long seen
		CU_ASSERT_TRUE( g_ack.ReceiveFor( seen, 5000 ) )
		CU_ASSERT_EQUAL( seen, 42 )

		'' and the other way round: a sender arrives after 100 ms
		g_wg.Add( )
		spawn late_sender( 100 )
		dim as long got = -1
		CU_ASSERT_TRUE( g_pipe.ReceiveFor( got, 10000 ) )
		CU_ASSERT_EQUAL( got, 99 )
		g_wg.Wait( )

		g_pipe.Close( )
		g_ack.Close( )
	END_TEST

	'' ------------------------------------------------------------ the iterator

	'' FOR EACH over a channel is sugar for this protocol, and it TERMINATES ON
	'' CLOSE -- which is why a range-for over a channel nobody closes hangs.
	TEST( iterator_protocol_ends_at_close )
		dim ch as Channel( of long ) = Channel( of long )( 8 )
		for i as long = 1 to 5
			ch.TrySend( i * 10 )
		next
		ch.Close( )

		dim it as ChannelIterator( of long ) = ch.GetIterator( )
		dim as long n = 0, sum = 0
		while( it.IsValid( ) )
			n += 1
			sum += it.Value( )
			it.MoveNext( )
		wend

		CU_ASSERT_EQUAL( n, 5 )
		CU_ASSERT_EQUAL( sum, 150 )

		'' exhausted stays exhausted
		it.MoveNext( )
		CU_ASSERT_FALSE( it.IsValid( ) )

		'' FOR EACH agrees with the hand-driven loop
		dim ch2 as Channel( of long ) = Channel( of long )( 8 )
		for i as long = 1 to 5
			ch2.TrySend( i * 10 )
		next
		ch2.Close( )

		dim as long m = 0, msum = 0
		for each x in ch2
			m += 1
			msum += x
		next
		CU_ASSERT_EQUAL( m, n )
		CU_ASSERT_EQUAL( msum, sum )

		'' a channel closed while EMPTY yields nothing at all, without hanging
		dim ch3 as Channel( of long ) = Channel( of long )( 2 )
		ch3.Close( )
		dim as long k = 0
		for each y in ch3
			k += 1
		next
		CU_ASSERT_EQUAL( k, 0 )
	END_TEST

	'' ------------------------------------------------- the directional views

	'' SendChan and RecvChan are VIEWS, not copies: they share the channel, and
	'' each exposes only the half its name allows. That the other half will not
	'' compile is docs/tests/concurrency/sync_err_*.bas; what is asserted here
	'' is that the half that does compile reaches the SAME channel.
	TEST( directional_views_share_the_channel )
		dim ch as Channel( of long ) = Channel( of long )( 4 )
		dim tx as SendChan( of long ) = ch
		dim rx as RecvChan( of long ) = ch

		'' the state questions agree across all three handles
		CU_ASSERT_FALSE( tx.IsNil( ) )
		CU_ASSERT_FALSE( rx.IsNil( ) )
		CU_ASSERT_FALSE( tx.IsClosed( ) )
		CU_ASSERT_FALSE( rx.IsClosed( ) )
		CU_ASSERT_EQUAL( tx.Capacity( ), 4 )

		'' what goes in one end comes out the other
		dim as long v = 11
		CU_ASSERT_TRUE( tx.TrySend( v ) )
		CU_ASSERT_EQUAL( ch.Count( ), 1 )
		CU_ASSERT_EQUAL( rx.Count( ), 1 )

		dim as long got = -1
		CU_ASSERT_TRUE( rx.TryReceive( got ) )
		CU_ASSERT_EQUAL( got, 11 )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )

		'' the timed forms are present on the half that owns them
		v = 12
		CU_ASSERT_TRUE( tx.SendFor( v, 1000 ) )
		CU_ASSERT_TRUE( rx.ReceiveFor( got, 1000 ) )
		CU_ASSERT_EQUAL( got, 12 )

		'' the receiving view iterates, and terminates on the sender's close
		CU_ASSERT_TRUE( tx.TrySend( 1 ) )
		CU_ASSERT_TRUE( tx.TrySend( 2 ) )
		tx.Close( )

		'' CLOSING THROUGH THE VIEW closes the channel, and every handle says so
		CU_ASSERT_TRUE( ch.IsClosed( ) )
		CU_ASSERT_TRUE( tx.IsClosed( ) )
		CU_ASSERT_TRUE( rx.IsClosed( ) )

		dim as long n = 0
		for each x in rx
			n += 1
		next
		CU_ASSERT_EQUAL( n, 2 )

		'' a nil channel viewed directionally is still nil
		dim nilch as Channel( of long )
		dim ntx as SendChan( of long ) = nilch
		dim nrx as RecvChan( of long ) = nilch
		CU_ASSERT_TRUE( ntx.IsNil( ) )
		CU_ASSERT_TRUE( nrx.IsNil( ) )
		CU_ASSERT_FALSE( ntx.TrySend( 1 ) )
		CU_ASSERT_FALSE( nrx.TryReceive( got ) )
	END_TEST

	'' ---------------------------------------------------------- end to end

	'' The whole protocol under real concurrency: a producer that closes when it
	'' is done and a consumer that loops until the close tells it to stop. This
	'' is the only test here that would notice a lost or duplicated value.
	TEST( producer_consumer_delivers_every_value_once )
		const N = 2000

		g_pipe = Channel( of long )( 16 )
		g_ack  = Channel( of long )( 4 )

		g_wg.Add( 2 )
		spawn producer( N )
		spawn consumer( N )
		g_wg.Wait( )

		dim as long count_, sum
		CU_ASSERT_TRUE( g_ack.ReceiveFor( count_, 10000 ) )
		CU_ASSERT_TRUE( g_ack.ReceiveFor( sum, 10000 ) )

		CU_ASSERT_EQUAL( count_, N )
		CU_ASSERT_EQUAL( sum, N * ( N + 1 ) \ 2 )

		'' and the channel ends closed and empty, not merely quiet
		CU_ASSERT_TRUE( g_pipe.IsClosed( ) )
		CU_ASSERT_EQUAL( g_pipe.Count( ), 0 )

		g_ack.Close( )
	END_TEST

	'' Channels carry UDTs, not only scalars, and the value that comes out must
	'' be the value that went in -- copied, not aliased.
	TEST( carries_udt_values_by_copy )
		dim ch as Channel( of Payload ) = Channel( of Payload )( 4 )

		dim as Payload p
		p.id = 1 : p.name = "first"
		CU_ASSERT_TRUE( ch.TrySend( p ) )

		'' mutating the source after the send must not change what is in flight
		p.id = 99 : p.name = "mutated"

		dim as Payload got
		CU_ASSERT_TRUE( ch.TryReceive( got ) )
		CU_ASSERT_EQUAL( got.id, 1 )
		CU_ASSERT_EQUAL( got.name, "first" )

		ch.Close( )
	END_TEST

END_SUITE

#endif
