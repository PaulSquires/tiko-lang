# Concurrency

A program that does one thing at a time wastes the machine it runs on. Downloads wait on the
network, a scan waits on the disk, a calculation could use every core — and a window has to keep
answering the user while all of that happens. Doing several things at once is how a program stops
waiting on itself.

It is also the easiest way to write a program that is right on every run but one. Two threads that
change the same variable without coordinating lose updates; a thread that waits for a message
nobody sends waits forever; and none of it shows up until the timing is unlucky.

tiko gives you two levels. **OS threads**, with mutexes and condition variables, are the
foundation: explicit, flexible and easy to get wrong. **Goroutines and channels**, from the
`std/tasks` module, are built on top: you start work with `spawn`, and the pieces talk by sending
values rather than by sharing variables. This chapter covers both, then the tools for coordinating
them, and the shared state that remains your problem either way.

## The thread-safe runtime

Every program that runs more than one thread must be built with **`-mt`**, which links the
runtime that is safe to call from several threads at once. Put it in the program, where it cannot
be forgotten:

```tiko
#import "std/tasks"
#cmdline "-mt"
```

`#cmdline` comes after any `#import` lines: an `#import` must come before everything else in the
file (`TKO0362`). A program can ask how it was built: `__FB_MT__` is −1 under `-mt` and 0
without it.

````admonish danger title="Pitfall"
**A program built without `-mt` compiles and then misbehaves.** The `std/tasks` headers mean to
refuse a build without `-mt`, but they test `defined( __FB_MT__ )` — and `__FB_MT__` is always
defined; only its value changes. So nothing stops the build. The goroutine program in the next
section, built without `-mt`, printed its correct result and then, run three times, crashed once
with a segmentation fault and hung twice at exit. That is the worst kind of failure: the output
looks right.

Every listing in this chapter carries `#cmdline "-mt"`. Do the same in yours.
````

```admonish warning title="Status in this version"
**The headers' `-mt` check never fires**, for the reason above. Tracked as **T75**; until it is
fixed, `-mt` is yours to remember.
```

## OS threads

### Threads and a mutex

`threadcreate( @Proc, arg )` starts a new operating-system thread running `Proc( arg )`, where
`Proc` takes one `byval … as any ptr`. `threadwait( t )` waits for it to finish. A **mutex** makes
a section of code run in one thread at a time:

```tiko
{{#include ../examples/ch22/threads.tiko}}
```

```text
{{#include ../examples/ch22/threads.out}}
```

`c->total += 1` is three steps — read, add, write back. Two threads can read the same value, both
add one and both write, and one increment is lost. Inside `mutexlock` … `mutexunlock` only one
thread runs those steps at a time, so the total is exact. The same program with the two mutex lines
removed printed 149321, 188315 and 133439 on three runs: more than half the work lost, and a
different amount each time.

The argument is an `any ptr`, so everything a thread needs travels in one record whose address is
passed — here the counter and its lock together. A mutex is created with `mutexcreate( )` and
must be destroyed with `mutexdestroy( )` when no thread can use it any longer.

### Waiting for a condition

A **condition variable** lets a thread sleep until another thread tells it something has changed:

```tiko
{{#include ../examples/ch22/condvar.tiko}}
```

```text
{{#include ../examples/ch22/condvar.out}}
```

`condwait( cond, mutex )` releases the mutex while it sleeps and takes it back before it returns,
so the flag it is waiting on can be changed by the other thread in the meantime. Always test the
condition **in a loop**: a wake-up says only that something may have changed — the thread can be
woken with nothing to do, or after another thread has already consumed the change.

### threadcall

`threadcall Proc( args )` is meant to start a thread for an ordinary procedure, with ordinary
arguments. In this version it does not: it compiles with a warning,
`TKO0797: 'threadcall' is not supported: 'hello' will not run, and the thread handle is 0`, and
the procedure never runs. Use `threadcreate` with a record of arguments, or — better — `spawn`.

## Goroutines

### spawn

A **goroutine** is a procedure call that runs alongside the rest of the program. `spawn` starts
one:

```tiko
{{#include ../examples/ch22/spawnsum.tiko}}
```

```text
{{#include ../examples/ch22/spawnsum.out}}
```

`spawn Square( i, results )` returns at once; `Square` runs later, on one of the runtime's worker
threads. A goroutine has no return value, so `Square` sends its answer down a **channel**, and the
main program receives five answers. They may arrive in any order, which is why the program adds
them up rather than printing them.

A goroutine is a work item on a pool of threads, not a thread of its own. Starting one is a queue
push, so thousands are fine; the pool grows when goroutines block in system calls, up to 256
workers. And **nothing waits for a goroutine at program exit**: one still running when the
program ends is abandoned. A channel, as here, or the `WaitGroup` below is how you wait.

### Arguments are copied

The arguments to a spawned procedure are evaluated and **copied at the `spawn` statement**:

```tiko
{{#include ../examples/ch22/spawncopies.tiko}}
```

```text
{{#include ../examples/ch22/spawncopies.out}}
```

Each goroutine gets the `i` and the `label` that existed when it was spawned. Changing `label`
afterwards changes nothing they see, however late they run. The results arrive in whatever order
the goroutines finish, so the program sorts them before printing.

Copying is what makes this safe, and it rules out a `byref` parameter: the goroutine would hold a
reference into the spawning procedure's frame, which may be gone by the time it runs.

```tiko
{{#include ../examples/ch22/spawnbyref.tiko}}
```

```
spawnbyref.tiko(9,1): error TKO0812: 'spawn fill' cannot pass its byref parameter 'total'; a string or UDT parameter is byref unless it is written 'byval'
```

Note the second half of the message: a `ustring` or record parameter written without either keyword
is `byref`, so a procedure you mean to spawn writes `byval` on every parameter. When the goroutine
must change something of yours, pass a pointer and own that decision.

`spawn` takes a procedure declared at module level — a `sub`, or a `function` whose result is
discarded. A method, a lambda and a procedure pointer cannot be spawned.

```admonish warning title="Status in this version"
**Spawning a lambda reports the wrong problem.** `var greet = sub( ) … end sub` then
`spawn greet( )` is refused, as it should be, but with `TKO0743: 'greet' is not declared` rather
than a message saying that `spawn` needs a module-level procedure. Tracked as **T76**.
```

## Channels

A `Channel( of T )` is a typed queue between goroutines. It is created with a **capacity**:

```tiko
{{#include ../examples/ch22/channels.tiko}}
```

```text
{{#include ../examples/ch22/channels.out}}
```

| Operation | Does |
|---|---|
| `Send( v )` | waits until there is room, then queues `v` |
| `Receive( v )` | waits for a value; `false` once the channel is closed **and** empty |
| `TrySend( v )`, `TryReceive( v )` | never wait; `false` if they would have to |
| `SendFor( v, ms )`, `ReceiveFor( v, ms )` | wait at most `ms` milliseconds |
| `Close( )` | no more sends; queued values remain to be received |
| `for each v in ch` | receives until the channel is closed and drained |
| `Count( )`, `Capacity( )`, `IsClosed( )`, `IsNil( )` | snapshots, for reporting — not for deciding |

A capacity of **0** is a **rendezvous**: `Send` waits until a receiver takes the value, so a
send is also a meeting point. A capacity of N buffers N values, and `Send` waits only when the
buffer is full — which is what stops a fast producer from running ahead of a slow consumer
without limit.

`Receive` returning `false` at the end is not an error; it is how a consumer learns that the
producer has finished, and the `for each` form is built on it. `x` keeps its old value when that
happens. Sending to a closed channel, or closing one twice, is runtime error 1: it means two parts
of the program disagree about who produces.

A channel is a **handle**: copying it gives a second handle to the same queue, which is how one
channel is shared between goroutines. A channel declared without a capacity is **nil**, and every
send and receive on it waits forever — `IsNil( )` exists to check your own setup.

### Pipelines, and channels with one end

Channels chain goroutines into a **pipeline**, each stage reading from one channel and writing to
the next:

```tiko
{{#include ../examples/ch22/pipeline.tiko}}
```

```text
{{#include ../examples/ch22/pipeline.out}}
```

`Generate` closes `numbers` when it has sent everything; `Square` sees `Receive` return `false`,
closes `squares` in turn; and the main program's `for each` ends. The close flows down the
pipeline, and no stage needs to know how many values there are.

The parameter types say which end each stage holds. A `SendChan( of T )` can send and close; a
`RecvChan( of T )` can only receive. A `Channel` converts to either when it is passed. A receiver
that tries to close its input is refused, because closing is the producer's decision:

```tiko
{{#include ../examples/ch22/recvclose.tiko}}
```

```
recvclose.tiko(5,11): error TKO0739: 'recvchan' has no member named 'close'
```

The one-ended types state intent at the boundary where a reader looks for it. They are not a lock:
the code that created the `Channel` still holds both ends.

## Waiting on several channels: select channel

`select channel` waits until one of several channel operations can proceed, and runs that case.
It is part of the language, and its runtime support comes from one more header,
`#include once "fb/select.bi"`:

```tiko
{{#include ../examples/ch22/selecttimeout.tiko}}
```

```text
{{#include ../examples/ch22/selecttimeout.out}}
```

| Case | Fires when |
|---|---|
| `case receive v from ch` | a value can be received into `v` (declared beforehand) |
| `case receive from ch` | a value can be received; it is discarded |
| `case send v to ch` | `v` can be sent |
| `case timeout ms` | nothing else became ready within `ms` milliseconds |
| `case else` | nothing is ready right now — the `select` does not wait at all |

A `select` may have one `timeout` or one `else`, not both: `else` would fire first every time, and
the timeout could never be reached. When
several cases are ready at once, one is chosen in a varying order, so a channel that is always
ready cannot starve the others. A closed channel counts as ready to receive, and a nil channel
never does — assigning a nil channel to a variable is how a case is switched off.

```admonish warning title="Status in this version"
**A channel declared with `var` cannot be used in `select channel`.** With
`var answers = tasks.Channel( of int32 )( 1 )`, the `select` above is refused:
`TKO0809: cannot infer the type arguments of 'selectaddrecv'`. Declare a channel that a `select`
reads with `dim … as tasks.Channel( of T )`, as the listing does. Tracked as **T77**.

**A `select` with both `case timeout` and `case else` is accepted.** It should be refused; as it
is, `else` fires and the timeout is dead code. Tracked as **T79**; write one or the other.
```

## Coordinating goroutines

### WaitGroup

A `WaitGroup` counts goroutines in flight. `Add( )` raises the count, each goroutine calls
`Done( )` as it finishes, and `Wait( )` returns when the count reaches zero:

```tiko
{{#include ../examples/ch22/workerpool.tiko}}
```

```text
{{#include ../examples/ch22/workerpool.out}}
```

This is a **worker pool**: three workers share one `jobs` channel, so each job goes to whichever
worker is free. The main program does not know which worker finishes last, so a small goroutine,
`CloseWhenDone`, waits on the group and then closes `results` — and the main program's
`for each` ends exactly when the last result is in.

Two rules. **`Add` before `spawn`**, never inside the goroutine: otherwise `Wait` can run before
the goroutine has counted itself, and return early. And a `WaitGroup` cannot be copied — a copy
would be a second counter — so it is passed by pointer.

### Context and cancellation

A **context** asks goroutines to stop. `WithCancel` makes one that `Cancel( )` cancels;
`WithTimeout` makes one that cancels itself after a number of milliseconds:

```tiko
{{#include ../examples/ch22/cancel.tiko}}
```

```text
{{#include ../examples/ch22/cancel.out}}
```

`ctx.Done( )` is a channel that is **closed** when the context is cancelled — and a closed channel
is always ready to receive, so cancellation becomes one more case in a `select`. `Err( )` says why:
`"cancelled"` or `"deadline exceeded"`. Cancelling a context cancels every context derived from
it, and `Cancel` may be called any number of times.

**Cancellation is a request.** Nothing is ever stopped by force: a goroutine that never looks at
its context runs to the end, and one blocked in a system call cannot see the request until the call
returns. That is deliberate — stopping a thread from outside would skip its destructors and its
`defer`s, the cleanup the language promises.

## Shared state

Channels move values between goroutines; they do not protect anything the goroutines share. When
two threads or goroutines do touch the same variable, it needs a mutex — or, for a counter, an
**atomic** operation:

```tiko
{{#include ../examples/ch22/atomic.tiko}}
```

```text
{{#include ../examples/ch22/atomic.out}}
```

`fbatomic.bi` provides three operations on a 32-bit `long`: `FB.AtomicFetchAddLong` adds and
returns the old value in one indivisible step, `FB.AtomicCasLong` stores a value only if the
current one is what you expected, and `FB.AtomicLoadLong` reads with the ordering a counter
written by another thread needs. Each is a full barrier, and each is a call into the runtime.

Some state is not shared at all, and that can be a surprise too.

````admonish danger title="Pitfall"
**Some of the runtime's own state belongs to the thread, and a goroutine runs on whichever thread
is free.**

```tiko
{{#include ../examples/ch22/dirstate.tiko}}
```

```text
{{#include ../examples/ch22/dirstate.out}}
```

`dir( pattern )` starts a directory listing and `dir( )` continues it — **on the same thread**.
The goroutine's `dir( )` continues nothing, because the listing was started on the main thread,
and returns an empty string. The main thread's listing is untouched. The same holds for `err` and
the other runtime state that a statement leaves behind for the next one. Keep a sequence of calls
that depend on each other inside one goroutine.
````

```admonish warning title="Status in this version"
**On Linux, `dir( )` with a wildcard pattern finds nothing.** `dir( "part*.dat" )` returns an
empty string even when matching files exist; a name with no wildcard works. Tracked as **T78**;
the listing above is correct on Windows and blocked on Linux until it is fixed.
```

## Threads or goroutines?

- **Reach for goroutines and channels first.** They copy arguments, pass results back by value,
  and make the order of events visible in the code. Most concurrent programs — fan-out work,
  pipelines, timeouts — are shorter and easier to get right this way.
- **Use an OS thread for something that must own its thread**: a loop that blocks for a long time,
  code that keeps per-thread state, or anything that belongs to one thread for its whole life.
- **Never touch a window from a goroutine.** A window belongs to the thread that created it, and a
  goroutine runs on an arbitrary worker. Compute in the goroutine, send the result through a
  channel, and let the window's own thread take it with `TryReceive`, which never blocks the
  message loop.

## What it costs

- **`-mt` makes every runtime call that touches shared state take a lock**, so a single-threaded
  program built with it is somewhat slower. Use it where threads are.
- **A goroutine costs a queue push and a copy of its arguments**; a thread costs an operating-system
  thread. Thousands of goroutines are fine; millions are not.
- **Every channel operation copies the value**, and a buffered send copies twice. For a large
  record, send a pointer and decide who owns it.
- **A mutex costs little when nobody else holds it** and a great deal when everyone does. A lock
  around the inner loop of four threads, as in `threads.tiko`, makes them take turns.

## Summary

- Build every multi-threaded program with `-mt` — `#cmdline "-mt"` after the imports. Without it
  the program compiles and then crashes or hangs.
- `threadcreate`/`threadwait` start and join OS threads; `mutexlock`/`mutexunlock` make a section
  exclusive; `condwait` sleeps on a condition, always in a loop. `threadcall` does not run (`TKO0797`).
- `spawn Proc( args )` runs a module-level procedure as a goroutine; its arguments are copied at
  the spawn, and a `byref` parameter is refused (`TKO0812`). Nothing waits for goroutines at exit.
- `Channel( of T )( capacity )`: 0 is a rendezvous. `Receive` is `false` at the end of a closed
  stream; `for each` drains one. `SendChan`/`RecvChan` give one end each.
- `select channel` waits on several operations, with `timeout` or `else`
  (`#include once "fb/select.bi"`).
- `WaitGroup`: `Add` before `spawn`, `Done` in the goroutine, `Wait` to join. `Context`: cooperative
  cancellation through a `Done( )` channel, by hand or by deadline.
- Shared variables need a mutex or an atomic; per-thread runtime state such as `dir( )`'s listing
  does not follow a goroutine.

## Exercises

1. Sum the integers 1 to 1,000,000 in four goroutines, one quarter each, and combine the partial
   sums through a channel. {solution="ex22-01"}
2. Two producers send three numbers each into **one** channel. Use a `WaitGroup` and a closing
   goroutine so that the consumer's `for each` ends exactly when both have finished.
   {solution="ex22-02"}
3. Add a third stage to `pipeline.tiko` that keeps only the even squares.
4. Give `workerpool.tiko`'s workers a `Context`, and cancel it after the first five results.
   What must the workers do for the cancellation to take effect?
5. Remove the mutex calls from `threads.tiko` and run it several times. Then replace the
   increment with `FB.AtomicFetchAddLong`. What changes, and what does each version cost?
