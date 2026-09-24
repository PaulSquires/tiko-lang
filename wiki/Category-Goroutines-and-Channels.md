[Home](Home) › [All Categories](Categories) › **Goroutines and Channels**

# Goroutines and Channels

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

> 📘 **Also in this category:** [Goroutines Tutorial](Modern-Goroutines-Tutorial) ✨

```freebasic
#include once "fb/sync.bi"       ' pulls in channel.bi and scheduler.bi
#include once "fb/select.bi"
using FB

sub Produce( byval jobs as SendChan( of long ), byval n as long )
    for i as long = 1 to n
        jobs.Send( i * i )
    next
    jobs.Close( )
end sub

dim jobs as Channel( of long ) = Channel( of long )( 16 )

spawn Produce( jobs, 100 )

for each v in jobs               ' ends when the producer closes and drains
    print v
next
```

Requires -mt.  The headers refuse to compile without it rather than link a single-threaded runtime and misbehave.

## Why It Exists

FreeBASIC's concurrency surface is four opaque pointers.  ThreadCreate returns an ANY PTR; so do MutexCreate and CondCreate.  There is no way to return a value from a thread, no message passing, no timed wait anywhere, no semaphore, and no way to wake one specific waiter.  Every concurrent FreeBASIC program invents the same shared-global-plus-mutex protocol, per program, and nothing checks any of it.

```freebasic
' before
dim shared as long g_result
dim shared as boolean g_done
dim shared as any ptr g_mutex, g_cond
...20 more lines, three globals, one predicate loop...

' after
dim done as Channel( of long ) = Channel( of long )( 1 )
spawn Worker( done )
dim as long answer
done.Receive( answer )
```

The channel is typed, so a second worker returning a STRING is a second channel and not a second global.

## The Shape, In One Table

```freebasic
spawn Worker( a, b )       run Worker concurrently; a and b are COPIED here
Channel( of T )            typed queue: rendezvous or buffered, with close
select channel             wait on several channels at once
WaitGroup                  wait for a fan-out to finish
Context                    ask a goroutine to stop; composes with select
SendChan / RecvChan        one-way views, so a signature says which end

Header                     What it brings
fb/channel.bi              Channel, SendChan, RecvChan
fb/scheduler.bi            FB.Spawn, GoroutineCount, WorkerCount
fb/select.bi               the SELECT CHANNEL runtime (include to use it)
fb/sync.bi                 WaitGroup, Context; includes channel + scheduler
```

## What A Goroutine Is -- Read This Once

A goroutine is a work item on a thread pool.  It is NOT Go's goroutine, and the difference is not a matter of effort.

Go's goroutines are stackful coroutines multiplexed onto OS threads, starting at a 2 KB growable stack, and millions of them are routine.  That works because the Go runtime owns every blocking operation in the language.  FreeBASIC programs call Win32 and libc directly, so a fibre that called Sleep or ReadFile would freeze every other fibre sharing its carrier thread, with no diagnostic -- and FreeBASIC's per-thread state (err(), the TLS context table, window ownership, COM apartments) is keyed to the OS thread, not the fibre.

So:

\* Spawning is a queue push, not a thread creation.  Thousands of goroutines

```freebasic
are fine.  MILLIONS ARE NOT.
```

\* A goroutine blocked in a syscall holds an OS thread.  The pool grows when

```freebasic
that happens, capped at 256 workers.
```

\* A goroutine runs on an ARBITRARY worker.  Never touch an HWND, a GDI object

```freebasic
or a COM apartment belonging to another thread from one.  Post the result
back through a channel that the UI thread drains -- see BACKGROUND WORK IN A
DESKTOP APP below.
```

\* Nothing joins goroutines.  At program exit, work still running is ABANDONED,

```freebasic
silently.  Use a WaitGroup or a channel if it must finish.
```

## Spawn

```freebasic
spawn Worker( a, b )
```

Runs Worker( a, b ) concurrently.  The arguments are evaluated HERE and copied, which is the whole reason this is a statement rather than a library call:

```freebasic
for i as long = 1 to 10
    spawn Work( i )        ' each goroutine gets ITS OWN i
next
```

A closure-capturing design would share one i and most goroutines would see 11. FreeBASIC's capturing lambdas build their closure on the STACK, so handing one to another thread is a use-after-free that compiles cleanly.

'spawn' is a CONTEXTUAL keyword.  Existing code that uses it as a variable, a field, an array or a SUB name keeps working.  The one break: a paren-less call in statement position to a SUB named 'spawn' -- 'spawn x' -- now parses as spawning x.  'spawn( x )' still calls it.

What can be spawned:

```freebasic
sub                        yes
function                   yes -- THE RESULT IS DISCARDED, as in Go
overloaded proc            yes, resolved from the argument types
method, obj.Method( a )    NO -- diagnosed
proc inside a namespace    NO -- diagnosed
procedure pointer, lambda  NO -- diagnosed
```

A BYREF parameter is a compile error at a spawn site.  Copying defeats the BYREF; honouring it would hand the goroutine a reference into a frame that is about to die.  Pass a pointer if sharing is what you mean.

EVERY ARGUMENT MUST BE WRITTEN.  A default argument cannot be omitted at a spawn site: the argument count is taken from the target's parameter list, because the lexer looks ahead three tokens and the written arguments cannot be counted.

A goroutine returns nothing.  The channel is the return path.

FB.Spawn( @Worker, @ctx ) is the library form the statement lowers to.  It is public, and it puts the entire lifetime of ctx on you -- prefer the statement.

## Channel

```freebasic
dim ch as Channel( of long ) = Channel( of long )( 16 )   ' buffered
dim rv as Channel( of long ) = Channel( of long )( 0 )    ' rendezvous
dim nl as Channel( of long )                              ' NIL

Send( v )              blocks until there is room, or a receiver
Receive( out )         blocks until there is a value; FALSE at end of stream
TrySend / TryReceive   never block; FALSE if they would
SendFor / ReceiveFor   with a timeout in ms
Close( )               "no more values will be sent"
IsClosed, IsNil, Count, Capacity
for each v in ch       drains until closed and empty
```

CAPACITY 0 IS A RENDEZVOUS, not a zero-length buffer.  Send does not return until a receiver has taken the value: it is a handoff AND an ordering point.

CAPACITY N buffers N items; Send blocks only when full.  That backpressure is what keeps a fast producer from consuming all memory.  There is no unbounded capacity, because an unbounded channel turns a slow consumer into an out-of-memory kill far from the cause.

COPIES SHARE.  A Channel is a refcounted handle, so handing a copy to each of four workers gives four handles on ONE queue.  This is deliberately unlike FB.Array, whose copy is deep.  The destructor does NOT close.

WHAT EVERY OPERATION RETURNS

```freebasic
              Open,   Open, would   Closed,      Closed,   Nil
              ready   block         has items    empty     channel
Send          TRUE    blocks        raises       raises    blocks forever
Receive       TRUE    blocks        TRUE,drains  FALSE     blocks forever
TrySend       TRUE    FALSE         raises       raises    FALSE
TryReceive    TRUE    FALSE         TRUE         FALSE     FALSE
SendFor       TRUE    FALSE @ms     raises       raises    FALSE @ms
ReceiveFor    TRUE    FALSE @ms     TRUE         FALSE     FALSE @ms
Close         --      --            raises       raises    raises
```

"raises" is runtime error 1, illegal function call -- the same one Optional.Value( ) raises on an empty Optional.

Receive returning FALSE on a closed, drained channel is the TERMINATION SIGNAL, not a failure.  It is what makes the drain loop work:

```freebasic
while ch.Receive( v )
    Process( v )
wend            ' falls out when the producer closes and the buffer drains
```

'out' is NOT modified when Receive returns FALSE.

Send after close RAISES rather than returning FALSE, and so does closing twice. Each means two parties disagree about who owns the producer role -- a structural bug, not a runtime condition.

Closing does not discard buffered items, and it wakes every blocked waiter.

THE NIL CHANNEL.  A default-constructed Channel is nil, and Send and Receive on it block FOREVER.  That looks like a defect until you meet SELECT, where assigning a nil channel is how a case is disabled.  IsNil( ) exists so a program can assert its own initialisation, because "my program hangs" is the symptom of forgetting it.

T must be default-constructible, copy-constructible and destructible -- the same requirement FB.Array makes.  Every send copies, and a buffered send copies twice; there is no move constructor in the language.  For a large T, send a pointer.

## Select

```freebasic
select channel
    case receive job from jobs    : Process( job )
    case receive from ctx.Done( ) : exit do
    case send result to results   : sent += 1
    case timeout 500              : Heartbeat( )
    case else                     : DoOtherWork( )
end select
```

Waits on several channels at once and runs the case that becomes ready first. Include fb/select.bi to use it.

\* CASE ELSE makes the whole statement NON-BLOCKING: it fires the moment

```freebasic
nothing is ready.  This is Go's 'default'.
```

\* CASE TIMEOUT \<ms> fires if nothing becomes ready in time.  At most one, and

```freebasic
it cannot appear beside CASE ELSE -- ELSE would fire first, every time, so
the timeout could never be reached.  That combination is a compile error.
```

\* CASE RECEIVE v FROM ch needs v already declared.  CASE RECEIVE FROM ch

```freebasic
receives and discards, which is how a Done( ) channel is used.
```

\* The cases are polled in a PSEUDO-RANDOM order.  With a fixed order a channel

```freebasic
that is always ready starves every case after it, and the failure only shows
under load.
```

\* A NIL channel case is permanently not-ready.  That is how you disable a case

```freebasic
without rewriting the statement.
```

\* A CLOSED channel is ready for receive, and fires with the closed-channel

```freebasic
answer -- so a select case cannot by itself tell "received" from "closed".
Nil out the channel on close, or re-check inside the body.
```

\* Each channel expression is evaluated EXACTLY ONCE, even though the lowering

```freebasic
needs it three times.
```

\* 'exit do' or 'goto' out of a case body is fine; the wait records are still

```freebasic
released.
```

'channel' is contextual: SELECT CASE, including SELECT CASE on a variable named 'channel', is untouched.  Only the pair 'select channel' claims the statement.

## Waitgroup

```freebasic
dim wg as WaitGroup
for i as long = 1 to 8
    wg.Add( )
    spawn Worker( i, @wg )      ' Worker calls wg.Done( ) on the way out
next
wg.Wait( )

Add( delta = 1 )   Done( )   Wait( )   WaitFor( ms )   Count( )
```

ADD BEFORE THE SPAWN, always.  Adding from inside the goroutine races the Wait.

Everything every counted goroutine did before its Done is visible after Wait returns, with no other synchronization.

A WaitGroup is NON-COPYABLE -- a copy would be a second counter and one of them would never reach zero.  Pass it BYREF, or by pointer into a goroutine.

Done below zero raises, Add below zero raises, and Add from zero while a Wait is in progress raises.  The destructor does NOT wait; destroying one with waiters still parked on it raises rather than leaving them parked forever.

## Context

```freebasic
dim ctx as CancelContext = WithCancel( Context( ) )
defer ctx.Cancel( )                  ' releases the registration
spawn Worker( ctx )
...
ctx.Cancel( )                        ' ask it to stop

Context( )                    the background context; never cancelled
WithCancel( parent )          a cancellable child
WithTimeout( parent, ms )     cancels itself when the deadline passes
IsCancelled( )   Err( )   Done( )
CancelContext.Cancel( )
```

Done( ) returns a channel that is CLOSED on cancel.  That is the whole trick, and it is why cancellation is modelled as a channel: a closed channel is permanently ready, so cancellation composes with every other channel operation for free.

```freebasic
do
    select channel
        case receive job from jobs    : Process( job )
        case receive from ctx.Done( ) : exit do
    end select
loop
```

Cancel is IDEMPOTENT, unlike Channel.Close -- a context is routinely cancelled by both a timeout and an explicit Cancel, so "two parties" is normal here.

Cancellation propagates DOWN and only down.  Cancelling a parent cancels every context derived from it, transitively; cancelling a child never touches its parent.  A context derived from an already-cancelled parent starts cancelled.

Err( ) is "" , "cancelled" or "deadline exceeded".

NOTHING IS EVER KILLED.  A goroutine that never checks its context runs to completion and Cancel changes nothing observable in it.  TerminateThread skips destructors and DEFER blocks and leaks every mutex the thread held; in a language that has DEFER, forced termination means the cleanup written specifically to be unmissable is missed.  Cancellation is a REQUEST.  The name suggests otherwise, which is why this paragraph exists.

A goroutine blocked in a syscall cannot be cancelled.  That is the cost, and it is why every blocking operation here takes a timeout.

## Directional Channels

```freebasic
sub Produce( byval jobs as SendChan( of long ) )    ' cannot receive
sub Consume( byval jobs as RecvChan( of long ) )    ' cannot send or Close
```

RecvChan deliberately has no Close: closing is the producer's statement, and a consumer that closes its input is the most common channel bug there is.

Conversion is ONE WAY.  There is no cast back to Channel, because a directional handle is a narrowing and narrowing should not be reversible by accident.

These are ERGONOMICS, NOT SAFETY.  Nothing stops a caller keeping the full Channel and using both ends; what they make checkable is the intent at the boundary where it is written down.

## Background Work In A Desktop App

This is the case that matters most in a Win32 program, and it has a rule.

A goroutine runs on an arbitrary worker thread.  Window handles belong to the thread that created them, so a SetWindowText from a goroutine is a bug that appears to work for months.  Compute in the goroutine, hand the result back through a channel, and let the UI thread pick it up:

```freebasic
' UI thread
dim shared as Channel( of ScanResult ) g_results

sub ScanFolder( byval path as ustring, byval jobs as Channel( of ScanResult ) )
    for each entry in WalkDir( path )
        if entry.IsOk( ) then jobs.Send( ToResult( entry.Value( ) ) )
    next
    jobs.Close( )
end sub

g_results = Channel( of ScanResult )( 64 )
spawn ScanFolder( selectedPath, g_results )

' in WM_TIMER, or after a PostMessage wakeup:
dim r as ScanResult
while g_results.TryReceive( r )        ' TryReceive: never block the UI
    AddRowToListView( r )
wend
```

TryReceive rather than Receive is the whole point of that loop: the UI thread drains whatever has arrived and returns to its message pump immediately.  A Receive there would freeze the window -- the bug the goroutine was meant to fix.

## The Rules That Are Easy To Get Wrong

\* Requires -mt.  The headers say so rather than misbehaving. \* A goroutine still running at program exit is ABANDONED, silently. \* Send after close RAISES; Receive at end of stream returns FALSE.  They are

```freebasic
different on purpose.
```

\* A nil channel blocks forever.  IsNil( ) tells you. \* Count( ) is a snapshot and stale the instant it returns.  Metrics only,

```freebasic
never control flow.
```

\* Never touch a window, a GDI object or a COM apartment from a goroutine. \* wg.Add BEFORE the spawn, never inside the goroutine. \* Cancellation is advisory.  A goroutine that ignores its context blocks its

```freebasic
waiters forever.
```

\* A FreeBASIC runtime error inside a goroutine does not propagate.  The

```freebasic
worker's error state is reset between items so it cannot leak into the next
goroutine, but nobody observes it.  Send Result( of T, E ) instead.
```

\* There is NO data-race protection of any kind.  A channel will happily carry

```freebasic
a type holding a pointer into another goroutine's stack.  This design makes
concurrency ergonomic, not safe.
```

## What Is NOT Here

\* Cheap goroutines.  Thousands, not millions -- see WHAT A GOROUTINE IS. \* Send/Sync markers, or any data-race detection.  They need a type system

```freebasic
FreeBASIC does not have, and a marker the compiler cannot enforce is
documentation in a costume.
```

\* Forced cancellation.  Argued above. \* A value returned from a goroutine.  Go has none either; the channel is the

```freebasic
return path.
```

\* WithDeadline.  WithTimeout covers it without dragging fb/chrono.bi into

```freebasic
every program that wants cancellation.
```

\* sync.Once, RWMutex, a scoped lock guard.  Worth having, orthogonal to this,

```freebasic
and MutexCreate/MutexLock already exist.
```

\* Broadcast channels, priorities, peek.  A channel is a FIFO queue and each

```freebasic
item goes to exactly one receiver.
```

\* A deadlock detector.  Go can say "all goroutines are asleep" because it

```freebasic
knows about every block; this cannot see a goroutine blocked in ReadFile.
```

\* spawn inside a generic MEMBER body.  It does not compile, and neither does a

```freebasic
plain lambda there -- a pre-existing limitation of nested body replay in this
tree, not something spawn introduced.  A generic PROCEDURE is fine.
```

## Implementation

Both statements are desugared in tiko's parser (src/parser/spawn.bas, src/parser/selchan.bas) into ordinary statements that the rest of the compiler already lowers.  'spawn' builds the argument frame itself and hands a plain thunk straight to fb_Spawn, where fbc goes through a generic frame type and a virtual Invoke; the observable behaviour is the same -- the arguments are copied at the spawn, and the frame is destroyed and freed afterwards.  'select channel' becomes the calls into the generics of fb/select.bi that fbc builds for it.

The runtime side is tiko-rt's, written in FreeBASIC: the park/unpark layer (lib/rt/src/thread/park.bas), the scheduler (sched.bas) and the process-wide claim lock (claimlock.bas).  fbc has these in C because a process-wide singleton cannot be built from a HEADER -- a 'dim shared' in a .bi included by two modules gives two of them.  In a runtime module that reason does not apply.

Channel, select, WaitGroup, Context and the directional views are ordinary FreeBASIC in fb/*.bi -- fbc's headers, shipped unchanged in tiko's toolchain inc/ -- written on generics with no compiler privileges.

Full design, with every rejected alternative and the reasons: C:\\dev\\docs\\goroutines\\.

## Tests

tiko's own suite pins the lowering of 'spawn': tests/mir/spawn.test, and tests/mir/spawn-contextual.test for 'spawn' used as an ordinary variable.  For 'select channel', tests/driver/select-channel-link.test builds every case form and checks that it links, and tests/driver/select-channel-run.test builds a program that covers every case form, which build/goldenrun.sh runs beside fbc's build.  Neither is a test of the library itself.

The library is measured with fbc's own fbcunit suites, built by both compilers with -mt and the results compared: all three concurrency/ suites print what fbc's builds print (HANDOFF section 9f, 2026-09-21).

The programs in the [Goroutines Tutorial](Modern-Goroutines-Tutorial), built with 'tiko -mt' and run beside fbc's builds (measured 2026-09-24 at origin/master 50c71751, win64-msvc), show two more differences.  Spawning a procedure whose parameter is a SendChan or RecvChan, with a Channel argument, crashes -- an access violation, now and then a hang -- the example at the top of this page among them, part-way through its output.  And 'for each' over a Channel( of string ) yields empty strings.  The other programs, the ones that use 'select channel' among them, print what fbc's builds print.

Build a program that uses this module with a packaged toolchain -- no -i, no -p, because the headers and the runtime are in it:

```freebasic
toolchains\tiko-windows\tiko.exe -mt yourprogram.bas
toolchains/tiko-linux/bin/tiko   -mt yourprogram.bas
```

## Dialects

tiko implements -lang fb only -- '#lang "qb"' or '#lang "fblite"' is TKO0317 -- and there 'spawn' and 'select channel' are available, as DEFER is.  Neither word is reserved: 'spawn' and 'channel' remain usable as ordinary names.

## API reference

One page per entry, 11 in all:

[Add](Modern-Chan-Add) · [Cancel](Modern-Chan-Cancel) · [Channel](Modern-Chan-Channel-Channel) · [Channel.Capacity](Modern-Chan-Channel-Capacity) · [Channel.ChannelIterator](Modern-Chan-Channel-ChannelIterator) · [Channel.Close](Modern-Chan-Channel-Close) · [Channel.Count](Modern-Chan-Channel-Count) · [Channel.GetIterator](Modern-Chan-Channel-GetIterator) · [Channel.IsClosed](Modern-Chan-Channel-IsClosed) · [Channel.IsNil](Modern-Chan-Channel-IsNil) · [Channel.Receive](Modern-Chan-Channel-Receive) · [Channel.ReceiveFor](Modern-Chan-Channel-ReceiveFor) · [Channel.RecvChan](Modern-Chan-Channel-RecvChan) · [Channel.Send](Modern-Chan-Channel-Send) · [Channel.SendChan](Modern-Chan-Channel-SendChan) · [Channel.SendFor](Modern-Chan-Channel-SendFor) · [Channel.TryReceive](Modern-Chan-Channel-TryReceive) · [Channel.TrySend](Modern-Chan-Channel-TrySend) · [Context](Modern-Chan-Context) · [Count](Modern-Chan-Count) · [Done](Modern-Chan-Done) · [Err](Modern-Chan-Err) · [GoroutineCount](Modern-Chan-GoroutineCount) · [IsCancelled](Modern-Chan-IsCancelled) · [spawn](Modern-Chan-Spawn) · [Wait](Modern-Chan-Wait) · [WaitFor](Modern-Chan-WaitFor) · [WithCancel](Modern-Chan-WithCancel) · [WithTimeout](Modern-Chan-WithTimeout) · [WorkerCount](Modern-Chan-WorkerCount)

---

**Source:** `docs/goroutines/goroutines.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
