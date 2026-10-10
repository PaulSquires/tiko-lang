'' fb/select.bi -- the runtime half of the SELECT statement
''
'' RFC-0004 (C:\dev\docs\goroutines\RFC-0004-select.md).  These types exist so
'' that the SELECT statement has something to lower to; they are not meant to be
'' written by hand, and the shape below is what parser-select.bas generates.
''
''     select channel
''         case receive v from ch1 : Handle1( v )
''         case send x to ch2      : Sent( )
''         case timeout 100        : Idle( )
''         case else               : Nothing( )
''     end select
''
'' THE SPLIT, and why it is where it is.  Deciding WHICH case can fire needs
'' only the channel's core state -- buffer count, capacity, waiter queues, the
'' closed flag -- and none of that mentions the element type.  MOVING the value
'' does mention it, and a string cannot be memmove'd.  So:
''
''   * SelectRun( ) is NON-GENERIC.  It locks every channel, polls in a
''     pseudo-random order, and either returns the index of a ready case or
''     parks.  It never touches a T.
''   * Committing a polled-ready case is GENERIC, one call per case, emitted by
''     the parser because only it knows the case's type.
''   * The BLOCKING path needs no commit at all: the counterparty is an ordinary
''     Send or Receive on that channel, so it already knows T and copies through
''     the record's slot exactly as it does for a plain blocked receiver.
''
'' THE ONE PLACE A LOCK CROSSES A CALL BOUNDARY.  SelectRun( ) returns with the
'' winning channel STILL LOCKED, and the generic commit unlocks it.  Releasing
'' first would let another thread take the item between the poll and the commit,
'' which is the whole point of polling under the lock.  The invariant is that
'' exactly one of SelectCommitRecv / SelectCommitSend / SelectAbandon runs after
'' any SelectRun that returns a case index.

#pragma once

#if not defined( __FB_MT__ )
	#error "fb/select.bi requires -mt (the multithreaded runtime)"
#endif

#include once "fb/channel.bi"

namespace FB

const SELECT_MAXCASES = 32

'' Outcomes of SelectRun( ) that are not a case index.
const SELECT_NONE    = -1
const SELECT_TIMEOUT = -2
const SELECT_ELSE    = -3

enum SelectKind
	SELKIND_RECV
	SELKIND_SEND
end enum

type SelectCase
	as ChanCore ptr        core
	as ChanWaiterCore ptr  rec
	as long                kind
	as boolean             enqueued
	as boolean             ownsslot
end type

type SelectCtx
	as SelectCase  cases( 0 to SELECT_MAXCASES-1 )
	as long        n
	as boolean     done          '' the per-select claim flag; see channel.bi
	as boolean     hastimeout
	as ulong       timeoutms
	as boolean     haselse
	as any ptr     parker
	as ulong       seed

	'' TRUE when SelectRun( ) returned a case from the POLL path, which leaves
	'' that channel LOCKED and owing a typed commit.  FALSE when it returned from
	'' the wake path, where the counterparty already moved the value and
	'' committing again would take a second item.  The generated code must test
	'' this; it is the difference between the two ways a case can fire.
	as boolean     polled

	declare constructor( )
	declare sub SetTimeout( byval ms as ulong )
	declare sub SetElse( )
	declare function PolledReady( ) as boolean
end type

private constructor SelectCtx( )
	this.n          = 0
	this.done       = FALSE
	this.hastimeout = FALSE
	this.timeoutms  = 0
	this.haselse    = FALSE
	this.polled     = FALSE
	this.parker     = ParkerSelf( )

	'' A per-thread xorshift, NOT FreeBASIC's RND.  RND is per-program state
	'' that a user program owns and observes, and perturbing it from inside a
	'' SELECT would make a program's random sequence depend on channel timing.
	'' The requirement here is only "not always the same order".
	this.seed = cast( ulong, cast( uinteger, ParkerSelf( ) ) ) or 1
end constructor

private sub SelectCtx.SetTimeout( byval ms as ulong )
	this.hastimeout = TRUE
	this.timeoutms  = ms
end sub

private sub SelectCtx.SetElse( )
	this.haselse = TRUE
end sub

private function SelectCtx.PolledReady( ) as boolean
	return this.polled
end function

'' --------------------------------------------------- registering the cases
''
'' Generic, because the record carries a typed slot.  The record is heap
'' allocated and released by SelectRelease* below; it cannot be a local of the
'' generated code, which has no name for its type.

function SelectAddRecv( of T ) _
	( _
		byref sc as SelectCtx, byval idx as long, _
		byref ch as Channel( of T ), byref out as T _
	) as boolean

	dim as ChanWaiter( of T ) ptr w = new ChanWaiter( of T )
	w->c.parker     = sc.parker
	w->c.claimed    = FALSE
	w->c.closedwake = FALSE
	w->c.prevw      = 0
	w->c.nextw      = 0
	w->c.seldone    = @sc.done
	w->c.caseidx    = idx
	w->slot         = @out

	sc.cases( idx ).rec      = @w->c
	sc.cases( idx ).kind     = SELKIND_RECV
	sc.cases( idx ).enqueued = FALSE
	sc.cases( idx ).ownsslot = FALSE

	'' A nil channel is permanently not-ready, which is how a case is
	'' disabled (RFC-0002 section 7).  It is registered with a NULL core and
	'' simply never polled or enqueued.
	if( ch.st = 0 ) then
		sc.cases( idx ).core = 0
	else
		sc.cases( idx ).core = @cptr( ChanState( of T ) ptr, ch.st )->core
	end if

	if( idx >= sc.n ) then sc.n = idx + 1
	return TRUE
end function

'' The value to send is copied HERE, once, before anything blocks -- RFC-0004
'' section 3 step 1.  The caller may modify its original freely afterwards.
function SelectAddSend( of T ) _
	( _
		byref sc as SelectCtx, byval idx as long, _
		byref ch as Channel( of T ), byref v as T _
	) as boolean

	dim as ChanWaiter( of T ) ptr w = new ChanWaiter( of T )
	dim as T ptr held = new T
	*held = v

	w->c.parker     = sc.parker
	w->c.claimed    = FALSE
	w->c.closedwake = FALSE
	w->c.prevw      = 0
	w->c.nextw      = 0
	w->c.seldone    = @sc.done
	w->c.caseidx    = idx
	w->slot         = held

	sc.cases( idx ).rec      = @w->c
	sc.cases( idx ).kind     = SELKIND_SEND
	sc.cases( idx ).enqueued = FALSE

	if( ch.st = 0 ) then
		sc.cases( idx ).core = 0
	else
		sc.cases( idx ).core = @cptr( ChanState( of T ) ptr, ch.st )->core
	end if

	if( idx >= sc.n ) then sc.n = idx + 1
	return TRUE
end function

'' 'case receive from ch' -- received and discarded.  The record owns the
'' storage, because the generated code cannot declare a variable of a type it
'' has no name for.
function SelectAddRecvDiscard( of T ) _
	( byref sc as SelectCtx, byval idx as long, byref ch as Channel( of T ) ) as boolean

	dim as T ptr sink = new T
	dim as boolean r = SelectAddRecv( sc, idx, ch, *sink )
	'' mark it so the release knows to free the sink as well
	sc.cases( idx ).ownsslot = TRUE
	return r
end function

'' ------------------------------------------------------------ the runner

private function hReady( byval c as ChanCore ptr, byval kind as long ) as boolean
	if( c = 0 ) then return FALSE            '' nil channel: never ready

	if( kind = SELKIND_RECV ) then
		'' an item, a waiting sender, or closed (which yields end-of-stream)
		if( c->num > 0 ) then return TRUE
		if( c->sfirst ) then return TRUE
		if( c->isclosed ) then return TRUE
		return FALSE
	else
		if( c->isclosed ) then return TRUE   '' will raise at commit
		if( c->rfirst ) then return TRUE
		if( c->num < c->cap ) then return TRUE
		return FALSE
	end if
end function

'' Lock every distinct participating channel, in ASCENDING ADDRESS ORDER.
''
'' That ordering rule is the entire deadlock-avoidance argument: two goroutines
'' running SELECT over the same two channels written in opposite order would
'' otherwise take the two locks in opposite orders and deadlock.  Duplicates are
'' locked once, because a mutex here is not recursive.
private sub hLockAll( byref sc as SelectCtx, order( ) as ChanCore ptr, byref cnt as long )
	cnt = 0
	for i as long = 0 to sc.n-1
		dim as ChanCore ptr c = sc.cases( i ).core
		if( c = 0 ) then continue for
		dim as boolean dup = FALSE
		for j as long = 0 to cnt-1
			if( order( j ) = c ) then dup = TRUE : exit for
		next
		if( dup ) then continue for
		'' insertion sort by address
		dim as long k = cnt
		while( k > 0 andalso cast( uinteger, order( k-1 ) ) > cast( uinteger, c ) )
			order( k ) = order( k-1 )
			k -= 1
		wend
		order( k ) = c
		cnt += 1
	next
	for i as long = 0 to cnt-1
		MutexLock( order( i )->lok )
	next
end sub

private sub hUnlockAllBut( order( ) as ChanCore ptr, byval cnt as long, byval keep as ChanCore ptr )
	for i as long = cnt-1 to 0 step -1
		if( order( i ) <> keep ) then
			MutexUnlock( order( i )->lok )
		end if
	next
end sub

'' Returns a case index (with THAT channel still locked, for the caller's typed
'' commit), or SELECT_ELSE, or SELECT_TIMEOUT.
private function SelectRun( byref sc as SelectCtx ) as long
	dim as ChanCore ptr order( 0 to SELECT_MAXCASES-1 )
	dim as long cnt = any

	do
		hLockAll( sc, order( ), cnt )

		'' Poll in a pseudo-randomly permuted order.  With a fixed order a case
		'' whose channel is always ready starves every case after it, and the
		'' failure only shows under load.
		'' The PRNG state must OUTLIVE the context.  Seeding per SelectCtx
		'' looked right and is useless: every context starts from the same
		'' value, so the first number is always the same and the permutation is
		'' a constant -- measured, case 0 fired 20000 times out of 20000.
		''
		'' A procedure-static is shared across threads, so incrementing it is a
		'' data race. That is deliberate and harmless: the only requirement is
		'' "not always the same order", and a torn update still produces a
		'' different order. It is NOT FreeBASIC's RND, which is program state a
		'' user owns and observes.
		static as ulong seedstate
		dim as long start = 0
		if( sc.n > 1 ) then
			if( seedstate = 0 ) then
				seedstate = cast( ulong, cast( uinteger, sc.parker ) ) or 1
			end if
			seedstate xor= seedstate shl 13
			seedstate xor= seedstate shr 17
			seedstate xor= seedstate shl 5
			start = seedstate mod cast( ulong, sc.n )
		end if

		for k as long = 0 to sc.n-1
			dim as long i = ( start + k ) mod sc.n
			if( hReady( sc.cases( i ).core, sc.cases( i ).kind ) ) then
				'' Claim the select itself, so a counterparty that is racing to
				'' wake us cannot also fire.
				ClaimLock( )
				dim as boolean won = ( sc.done = FALSE )
				if( won ) then sc.done = TRUE
				ClaimUnlock( )
				if( won = FALSE ) then
					'' somebody woke us first; fall through to the wake path
					exit for
				end if
				hUnlockAllBut( order( ), cnt, sc.cases( i ).core )
				sc.polled = TRUE
				return i
			end if
		next

		if( sc.haselse ) then
			hUnlockAllBut( order( ), cnt, 0 )
			return SELECT_ELSE
		end if

		'' Nothing ready: register on every channel and park.
		for i as long = 0 to sc.n-1
			dim as ChanCore ptr c = sc.cases( i ).core
			if( c = 0 ) then continue for
			if( sc.cases( i ).kind = SELKIND_RECV ) then
				ChanPushRecv( c, sc.cases( i ).rec )
			else
				ChanPushSend( c, sc.cases( i ).rec )
			end if
			sc.cases( i ).enqueued = TRUE
		next

		hUnlockAllBut( order( ), cnt, 0 )

		dim as boolean timedout = FALSE
		if( sc.hastimeout ) then
			timedout = ( ParkTimed( sc.parker, sc.timeoutms ) = 0 )
		else
			Park( sc.parker )
		end if

		'' Re-lock and take ourselves out of every queue we are still in.
		hLockAll( sc, order( ), cnt )
		dim as long fired = SELECT_NONE
		for i as long = 0 to sc.n-1
			dim as ChanCore ptr c = sc.cases( i ).core
			if( c = 0 ) then continue for
			if( sc.cases( i ).rec->claimed ) then
				fired = i
			elseif( sc.cases( i ).enqueued ) then
				ChanUnlink( c, sc.cases( i ).rec, sc.cases( i ).kind = SELKIND_SEND )
			end if
			sc.cases( i ).enqueued = FALSE
		next
		hUnlockAllBut( order( ), cnt, 0 )

		if( fired >= 0 ) then
			sc.polled = FALSE
			'' The counterparty has already moved the value through the
			'' record's slot, so there is nothing typed left to do.
			return fired
		end if

		if( timedout ) then
			return SELECT_TIMEOUT
		end if

		'' Spurious wake with nothing claimed and no deadline: go round again.
	loop
end function

'' ------------------------------------------------------- typed committing

'' Called only after SelectRun( ) returned this index from the POLL path, with
'' the channel still locked.  Unlocks it.
function SelectCommitRecv( of T ) _
	( byref sc as SelectCtx, byval idx as long, byref ch as Channel( of T ) ) as boolean

	dim as ChanWaiter( of T ) ptr w = cptr( ChanWaiter( of T ) ptr, sc.cases( idx ).rec )
	return ChanCommitRecvLocked( ch, w->slot )
end function

function SelectCommitSend( of T ) _
	( byref sc as SelectCtx, byval idx as long, byref ch as Channel( of T ) ) as boolean

	dim as ChanWaiter( of T ) ptr w = cptr( ChanWaiter( of T ) ptr, sc.cases( idx ).rec )
	return ChanCommitSendLocked( ch, w->slot )
end function

'' ---------------------------------------------------------------- release

'' The channel argument is not used; it is there so T can be INFERRED.  The
'' generated code has no name for the element type -- a generic instantiation
'' prints as a mangled internal name -- so an explicit 'SelectReleaseRecv( of
'' long )' is unwritable by the parser.
sub SelectReleaseRecv( of T )( byref sc as SelectCtx, byval idx as long, byref ch as Channel( of T ) )
	dim as ChanWaiter( of T ) ptr w = cptr( ChanWaiter( of T ) ptr, sc.cases( idx ).rec )
	'' hoisted: mixing a boolean and a pointer in ANDALSO is warning 38
	dim as boolean freeslot = ( sc.cases( idx ).ownsslot andalso ( w->slot <> 0 ) )
	if( freeslot ) then delete w->slot
	delete w
	sc.cases( idx ).rec = 0
end sub

sub SelectReleaseSend( of T )( byref sc as SelectCtx, byval idx as long, byref ch as Channel( of T ) )
	dim as ChanWaiter( of T ) ptr w = cptr( ChanWaiter( of T ) ptr, sc.cases( idx ).rec )
	if( w->slot ) then delete w->slot
	delete w
	sc.cases( idx ).rec = 0
end sub

end namespace
