'' fb/sync.bi -- FB.WaitGroup and FB.Context
''
'' RFC-0005 (C:\dev\docs\goroutines\RFC-0005-sync.md).  The two small pieces
'' that make goroutines and channels usable: a way to wait for a fan-out, and a
'' way to ask it to stop.
''
''     dim wg as WaitGroup
''     for i as long = 1 to 8
''         wg.Add( )
''         spawn Worker( i, @wg )        '' Worker calls wg.Done( ) on the way out
''     next
''     wg.Wait( )
''
'' NOTHING IS EVER KILLED.  Cancellation is a request that a goroutine notices,
'' or does not.  TerminateThread skips destructors and DEFER blocks and leaks
'' every mutex the thread held; pthread_cancel leaks them too.  In a language
'' that now has DEFER and scope destructors, forced termination means the
'' cleanup the programmer wrote specifically to be unmissable is missed.
''
'' The cost is that a goroutine blocked in a syscall cannot be cancelled.  Every
'' blocking operation in this design takes a timeout so a cancellable goroutine
'' can be written to wake and check; one blocked in recv( ) on a socket is
'' cancelled by closing the socket, which is outside this design.

#pragma once

#if not defined( __FB_MT__ )
	#error "fb/sync.bi requires -mt (the multithreaded runtime)"
#endif

#include once "fb/channel.bi"
#include once "fb/scheduler.bi"

namespace FB

'' ------------------------------------------------------------- WaitGroup

'' One parked waiter.  Lives in the waiting thread's frame, like a channel's
'' wait record and for the same reason.
type WgWaiter
	as any ptr        parker
	as WgWaiter ptr   nextw
end type

type WaitGroup
private:
	as any ptr       lok
	'' NOT named 'count': a field and a member differing only in case are the
	'' same identifier in FreeBASIC, and 'Count( )' below would be a duplicate.
	as long          n
	as long          waiting
	as WgWaiter ptr  first

	'' NON-COPYABLE.  A copy would be a second counter, and one of the two
	'' would never reach zero.  Pass it BYREF, or by pointer into a goroutine.
	declare constructor( byref rhs as WaitGroup )
	declare operator let( byref rhs as WaitGroup )

public:
	declare constructor( )
	declare destructor( )

	declare sub      Add ( byval delta as long = 1 )
	declare sub      Done( )
	declare sub      Wait( )
	declare function WaitFor( byval ms as ulong ) as boolean
	declare function Count( ) as long

private:
	declare function hWait( byval forever as boolean, byval ms as ulong ) as boolean
end type

private constructor WaitGroup( )
	this.lok     = MutexCreate( )
	this.n   = 0
	this.waiting = 0
	this.first   = 0
end constructor

'' Does NOT wait.  A WaitGroup destroyed with a non-zero counter is a bug the
'' program has already committed, and blocking in a destructor for an unbounded
'' time -- in a language where destructors run on error paths -- is worse.
'' Destroying one with waiters still parked on it raises rather than leaving
'' them parked forever.
private destructor WaitGroup( )
	MutexLock( this.lok )
	dim as boolean hadwaiters = ( this.waiting > 0 )
	MutexUnlock( this.lok )

	if( hadwaiters ) then
		error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	MutexDestroy( this.lok )
	this.lok = 0
end destructor

'' Add BEFORE the spawn, always.  Adding from inside the goroutine races the
'' Wait, which is why 'Add while a Wait is in progress' raises.
private sub WaitGroup.Add( byval delta as long )
	MutexLock( this.lok )

	'' Reusing a WaitGroup for a second round is only safe once every waiter
	'' from the first has returned, and this is the rule that makes it
	'' checkable.
	if( this.n = 0 andalso this.waiting > 0 andalso delta > 0 ) then
		MutexUnlock( this.lok )
		error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
		exit sub
	end if

	this.n += delta

	if( this.n < 0 ) then
		this.n -= delta            '' leave it as it was
		MutexUnlock( this.lok )
		error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
		exit sub
	end if

	dim as WgWaiter ptr woken = 0
	if( this.n = 0 ) then
		woken = this.first
		this.first = 0
	end if

	MutexUnlock( this.lok )

	'' Unpark outside the lock: every woken thread would otherwise immediately
	'' block on the lock still being held.
	while( woken )
		dim as WgWaiter ptr nxt = woken->nextw
		Unpark( woken->parker )
		woken = nxt
	wend
end sub

private sub WaitGroup.Done( )
	this.Add( -1 )
end sub

private sub WaitGroup.Wait( )
	this.hWait( TRUE, 0 )
end sub

'' Returns FALSE only on timeout.
''
'' ms = 0 IS A POLL, NOT AN INFINITE WAIT -- the same rule as Channel.SendFor
'' and Channel.ReceiveFor, which pass the deadline straight to ParkTimed. The
'' two spellings sit next to each other in ordinary code, so having one of them
'' silently mean "forever" was a hang waiting to happen; Wait( ) is the way to
'' say forever. Ask for a poll and you get one.
private function WaitGroup.WaitFor( byval ms as ulong ) as boolean
	return this.hWait( FALSE, ms )
end function

'' The one implementation behind both. `forever` is a separate parameter rather
'' than an overloaded meaning of ms = 0, which is exactly the conflation that
'' made the old WaitFor( 0 ) hang.
private function WaitGroup.hWait( byval forever as boolean, byval ms as ulong ) as boolean
	MutexLock( this.lok )

	if( this.n = 0 ) then
		MutexUnlock( this.lok )
		return TRUE
	end if

	dim as WgWaiter w
	w.parker = ParkerSelf( )
	w.nextw  = this.first
	this.first = @w
	this.waiting += 1

	MutexUnlock( this.lok )

	if( forever ) then
		'' A loop on the predicate: a parker may return spuriously, and the
		'' permit is sticky so a wake that arrives first is not lost.
		do
			Park( w.parker )
			MutexLock( this.lok )
			dim as boolean done_ = ( this.n = 0 )
			MutexUnlock( this.lok )
			if( done_ ) then exit do
		loop
	else
		ParkTimed( w.parker, ms )
	end if

	MutexLock( this.lok )
	dim as boolean ok = ( this.n = 0 )
	this.waiting -= 1
	'' Unlink if still queued -- a timed-out waiter must leave nothing behind.
	if( this.first = @w ) then
		this.first = w.nextw
	else
		dim as WgWaiter ptr p = this.first
		while( p )
			if( p->nextw = @w ) then
				p->nextw = w.nextw
				exit while
			end if
			p = p->nextw
		wend
	end if
	MutexUnlock( this.lok )

	return ok
end function

private function WaitGroup.Count( ) as long
	MutexLock( this.lok )
	dim as long n = this.n
	MutexUnlock( this.lok )
	return n
end function

'' --------------------------------------------------------------- Context

const CTX_MAXCHILDREN = 64

type CtxState
	as any ptr             lok
	as long                refs
	as boolean             cancelled
	as boolean             deadline_
	as Channel( of boolean ) done_
	as CtxState ptr        parent
	as CtxState ptr        children( 0 to CTX_MAXCHILDREN-1 )
	as long                nchildren
	as any ptr             timerparker      '' WithTimeout only
end type

type Context
	as any ptr st

	declare constructor( )                             '' background
	declare constructor( byref rhs as Context )
	declare destructor( )
	declare operator let( byref rhs as Context )

	declare function IsCancelled( ) as boolean
	declare function Err( ) as string

	'' Returns a channel that is CLOSED when the context is cancelled.  That is
	'' the whole trick, and it is why Go models cancellation as a channel: a
	'' closed channel is permanently ready for receive, so a Done case in a
	'' SELECT fires immediately and forever after, and cancellation composes
	'' with every other channel operation for free.
	declare function Done( ) as Channel( of boolean )
end type

type CancelContext extends Context
	declare sub Cancel( )
end type

'' ---- internals

declare sub hCtxCancel( byval s as CtxState ptr, byval isdeadline as boolean )

private sub hCtxRelease( byval s as CtxState ptr )
	if( s = 0 ) then exit sub
	MutexLock( s->lok )
	s->refs -= 1
	dim as boolean dead = ( s->refs = 0 )
	MutexUnlock( s->lok )
	if( dead = FALSE ) then exit sub

	'' unhook from the parent so a long-lived parent does not accumulate dead
	'' children -- the 'defer ctx.Cancel( )' idiom depends on this
	dim as CtxState ptr p = s->parent
	if( p ) then
		MutexLock( p->lok )
		for i as long = 0 to p->nchildren-1
			if( p->children( i ) = s ) then
				p->children( i ) = p->children( p->nchildren-1 )
				p->nchildren -= 1
				exit for
			end if
		next
		MutexUnlock( p->lok )
		hCtxRelease( p )
	end if

	MutexDestroy( s->lok )
	delete s
end sub

'' Cancel is IDEMPOTENT, unlike Channel.Close.  A context is routinely cancelled
'' by both a timeout and an explicit Cancel, so "two parties" is the normal case
'' here rather than a bug.  This is the only place this design diverges from
'' RFC-0002 section 6, and it is deliberate.
private sub hCtxCancel( byval s as CtxState ptr, byval isdeadline as boolean )
	if( s = 0 ) then exit sub

	MutexLock( s->lok )
	if( s->cancelled ) then
		MutexUnlock( s->lok )
		exit sub
	end if
	s->cancelled = TRUE
	s->deadline_ = isdeadline

	dim as CtxState ptr kids( 0 to CTX_MAXCHILDREN-1 )
	dim as long nk = s->nchildren
	for i as long = 0 to nk-1
		kids( i ) = s->children( i )
		MutexLock( kids( i )->lok )
		kids( i )->refs += 1                '' keep alive across the unlock
		MutexUnlock( kids( i )->lok )
	next
	dim as any ptr tp = s->timerparker
	MutexUnlock( s->lok )

	'' Closing the Done channel is what every waiter is actually watching.
	if( s->done_.IsNil( ) = FALSE ) then
		if( s->done_.IsClosed( ) = FALSE ) then
			s->done_.Close( )
		end if
	end if

	'' wake the timeout goroutine, if any, so it does not outlive the context
	if( tp ) then Unpark( tp )

	'' Propagates DOWN and only down.  Cancelling a child never touches its
	'' parent.
	for i as long = 0 to nk-1
		hCtxCancel( kids( i ), isdeadline )
		hCtxRelease( kids( i ) )
	next
end sub

private function hCtxNew( byval parent as CtxState ptr ) as CtxState ptr
	dim as CtxState ptr s = new CtxState
	s->lok        = MutexCreate( )
	s->refs       = 1
	s->cancelled  = FALSE
	s->deadline_  = FALSE
	s->done_      = Channel( of boolean )( 1 )
	s->parent     = parent
	s->nchildren  = 0
	s->timerparker = 0

	if( parent ) then
		MutexLock( parent->lok )
		if( parent->nchildren >= CTX_MAXCHILDREN ) then
			MutexUnlock( parent->lok )
			MutexDestroy( s->lok )
			delete s
			error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
			return 0
		end if
		parent->children( parent->nchildren ) = s
		parent->nchildren += 1
		parent->refs += 1
		dim as boolean already = parent->cancelled
		MutexUnlock( parent->lok )

		'' A context derived from an already-cancelled parent starts cancelled.
		if( already ) then
			hCtxCancel( s, parent->deadline_ )
		end if
	end if

	return s
end function

'' ---- Context members

private constructor Context( )
	this.st = 0                        '' background: never cancelled
end constructor

private constructor Context( byref rhs as Context )
	this.st = rhs.st
	if( this.st ) then
		dim as CtxState ptr s = cptr( CtxState ptr, this.st )
		MutexLock( s->lok )
		s->refs += 1
		MutexUnlock( s->lok )
	end if
end constructor

private destructor Context( )
	hCtxRelease( cptr( CtxState ptr, this.st ) )
	this.st = 0
end destructor

private operator Context.let( byref rhs as Context )
	if( this.st = rhs.st ) then exit operator
	hCtxRelease( cptr( CtxState ptr, this.st ) )
	this.st = rhs.st
	if( this.st ) then
		dim as CtxState ptr s = cptr( CtxState ptr, this.st )
		MutexLock( s->lok )
		s->refs += 1
		MutexUnlock( s->lok )
	end if
end operator

private function Context.IsCancelled( ) as boolean
	if( this.st = 0 ) then return FALSE
	dim as CtxState ptr s = cptr( CtxState ptr, this.st )
	MutexLock( s->lok )
	dim as boolean c = s->cancelled
	MutexUnlock( s->lok )
	return c
end function

private function Context.Err( ) as string
	if( this.st = 0 ) then return ""
	dim as CtxState ptr s = cptr( CtxState ptr, this.st )
	MutexLock( s->lok )
	dim as boolean c = s->cancelled
	dim as boolean d = s->deadline_
	MutexUnlock( s->lok )
	if( c = FALSE ) then return ""
	if( d ) then return "deadline exceeded"
	return "cancelled"
end function

'' The background context has no Done channel, and returning a NIL channel is
'' exactly right: a nil channel is permanently not-ready, so a Done case on a
'' context that can never be cancelled is permanently disabled, which is what it
'' means (RFC-0002 section 7).
private function Context.Done( ) as Channel( of boolean )
	if( this.st = 0 ) then
		dim as Channel( of boolean ) nilch
		return nilch
	end if
	dim as CtxState ptr s = cptr( CtxState ptr, this.st )
	return s->done_
end function

private sub CancelContext.Cancel( )
	hCtxCancel( cptr( CtxState ptr, this.st ), FALSE )
end sub

'' ---- constructors

private function WithCancel( byref parent as Context ) as CancelContext
	dim as CancelContext c
	c.st = hCtxNew( cptr( CtxState ptr, parent.st ) )
	return c
end function

'' The timeout is a goroutine that parks with a deadline.  Cancelling early
'' unparks it, so it does not outlive the context.
''
'' It costs one pool worker for the duration, which is real: a program with many
'' long timeouts will grow the pool.  The alternative -- a timer wheel in the
'' runtime -- is a subsystem of its own and is not worth it for this.
type CtxTimerArg
	as CtxState ptr s
	as ulong        ms
end type

private sub hCtxTimerProc( byval p as any ptr )
	dim as CtxTimerArg ptr a = cptr( CtxTimerArg ptr, p )
	dim as CtxState ptr s = a->s
	dim as ulong ms = a->ms
	delete a

	dim as any ptr parker = ParkerSelf( )

	MutexLock( s->lok )
	s->timerparker = parker
	dim as boolean already = s->cancelled
	MutexUnlock( s->lok )

	if( already = FALSE ) then
		if( ParkTimed( parker, ms ) = 0 ) then
			hCtxCancel( s, TRUE )              '' the deadline expired
		end if
	end if

	MutexLock( s->lok )
	s->timerparker = 0
	MutexUnlock( s->lok )

	hCtxRelease( s )
end sub

private function WithTimeout( byref parent as Context, byval ms as ulong ) as CancelContext
	dim as CancelContext c
	dim as CtxState ptr s = hCtxNew( cptr( CtxState ptr, parent.st ) )
	c.st = s
	if( s = 0 ) then return c

	MutexLock( s->lok )
	s->refs += 1                       '' the timer holds a reference
	MutexUnlock( s->lok )

	dim as CtxTimerArg ptr a = new CtxTimerArg
	a->s  = s
	a->ms = ms
	Spawn( @hCtxTimerProc, a )

	return c
end function

end namespace
