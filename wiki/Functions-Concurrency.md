[Home](Home) › [Function Finder](Function-Finder) › **Running things at once**

# Running things at once

The functions to start goroutines, pass values over channels, use threads and locks, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- **built-in**: nothing; it is always available.
- `std/tasks`: `#import "std/tasks"`, then `using tasks` to call it by its bare name.
- `fbthread.bi`: `#include "fbthread.bi"`.

Jump to: [Start a goroutine](#start-a-goroutine) · [Make a channel](#make-a-channel) · [Send and receive values](#send-and-receive-values) · [Close and drain a channel](#close-and-drain-a-channel) · [Hand out one end of a channel](#hand-out-one-end-of-a-channel) · [Wait for a group of goroutines](#wait-for-a-group-of-goroutines) · [Ask goroutines to stop](#ask-goroutines-to-stop) · [Check on the scheduler](#check-on-the-scheduler) · [Start and wait for threads](#start-and-wait-for-threads) · [Lock shared data with a mutex](#lock-shared-data-with-a-mutex) · [Wait for a signal with a condition variable](#wait-for-a-signal-with-a-condition-variable)

## Start a goroutine

| Function | What it does | From |
|---|---|---|
| [spawn](Modern-Chan-Spawn) | Runs a procedure alongside the program, copying its arguments at that moment. | `std/tasks` |

## Make a channel

| Function | What it does | From |
|---|---|---|
| [Channel](Modern-Chan-Channel-Channel) | Holds a typed queue between goroutines; copies share it, and a new one is nil. | `std/tasks` |
| [Channel.Capacity](Modern-Chan-Channel-Capacity) | Returns the buffer size the channel was made with; 0 means each value is handed over. | `std/tasks` |
| [Channel.IsNil](Modern-Chan-Channel-IsNil) | Returns true for a default-constructed channel, which blocks forever if used. | `std/tasks` |

## Send and receive values

| Function | What it does | From |
|---|---|---|
| [Channel.Send](Modern-Chan-Channel-Send) | Sends a value, waiting for room or a receiver; raises an error if the channel is closed. | `std/tasks` |
| [Channel.Receive](Modern-Chan-Channel-Receive) | Receives a value, waiting for one; returns false once closed and drained. | `std/tasks` |
| [Channel.TrySend](Modern-Chan-Channel-TrySend) | Sends a value only if it can go at once; returns false if it would have to wait. | `std/tasks` |
| [Channel.TryReceive](Modern-Chan-Channel-TryReceive) | Receives a value only if one is ready; returns false if empty or closed. | `std/tasks` |
| [Channel.SendFor](Modern-Chan-Channel-SendFor) | Sends a value, waiting at most ms milliseconds; returns false on a timeout. | `std/tasks` |
| [Channel.ReceiveFor](Modern-Chan-Channel-ReceiveFor) | Receives a value, waiting at most ms milliseconds; false on a timeout or end of stream. | `std/tasks` |

## Close and drain a channel

| Function | What it does | From |
|---|---|---|
| [Channel.Close](Modern-Chan-Channel-Close) | Marks that no more values will be sent; values already buffered are still delivered. | `std/tasks` |
| [Channel.IsClosed](Modern-Chan-Channel-IsClosed) | Returns true once the channel is closed, even while values are still buffered. | `std/tasks` |
| [Channel.Count](Modern-Chan-Channel-Count) | Returns how many values are buffered right now, as a snapshot. | `std/tasks` |
| [Channel.GetIterator](Modern-Chan-Channel-GetIterator) | Returns the iterator a for each loop uses to receive until the channel is drained. | `std/tasks` |
| [ChannelIterator](Modern-Chan-Channel-ChannelIterator) | Holds a for each loop's place while it receives from a channel. | `std/tasks` |

## Hand out one end of a channel

| Function | What it does | From |
|---|---|---|
| [SendChan](Modern-Chan-Channel-SendChan) | Holds a send-only view of a channel, for a procedure that only produces. | `std/tasks` |
| [RecvChan](Modern-Chan-Channel-RecvChan) | Holds a receive-only view of a channel, which cannot send to it or close it. | `std/tasks` |

## Wait for a group of goroutines

| Function | What it does | From |
|---|---|---|
| [WaitGroup.Add](Modern-Chan-Add) | Adds 1, or a given amount, to the work outstanding; call it before the spawn. | `std/tasks` |
| [WaitGroup.Done](Modern-Chan-Done) | Subtracts one from the work outstanding; raises an error if it would go below zero. | `std/tasks` |
| [WaitGroup.Wait](Modern-Chan-Wait) | Waits until the work outstanding reaches zero. | `std/tasks` |
| [WaitGroup.WaitFor](Modern-Chan-WaitFor) | Waits at most ms milliseconds for the work to reach zero; returns false on a timeout. | `std/tasks` |
| [WaitGroup.Count](Modern-Chan-Count) | Returns how much work is still outstanding, as a snapshot. | `std/tasks` |

## Ask goroutines to stop

| Function | What it does | From |
|---|---|---|
| [Context](Modern-Chan-Context) | Holds the background context, which is never cancelled and is the root of all others. | `std/tasks` |
| [WithCancel](Modern-Chan-WithCancel) | Returns a child context that you cancel yourself. | `std/tasks` |
| [WithTimeout](Modern-Chan-WithTimeout) | Returns a child context that cancels itself after the given milliseconds. | `std/tasks` |
| [CancelContext.Cancel](Modern-Chan-Cancel) | Cancels the context and every context made from it; a second call is harmless. | `std/tasks` |
| [Context.IsCancelled](Modern-Chan-IsCancelled) | Returns true once the context is cancelled or its deadline has passed. | `std/tasks` |
| [Context.Err](Modern-Chan-Err) | Returns why the context ended: "cancelled", "deadline exceeded", or "" while live. | `std/tasks` |

## Check on the scheduler

| Function | What it does | From |
|---|---|---|
| [GoroutineCount](Modern-Chan-GoroutineCount) | Returns how many goroutines exist right now, as a snapshot for diagnostics. | `std/tasks` |
| [WorkerCount](Modern-Chan-WorkerCount) | Returns how many OS threads the scheduler is running goroutines on. | `std/tasks` |

## Start and wait for threads

| Function | What it does | From |
|---|---|---|
| [ThreadCreate](Threadcreate) | Starts a procedure on a new thread, passing it one pointer; returns the thread handle. | built-in |
| [ThreadWait](Threadwait) | Waits for a thread to finish, then releases its handle. | built-in |
| [ThreadDetach](Threaddetach) | Releases a thread handle without waiting; the thread runs on to its end. | `fbthread.bi` |
| [ThreadSelf](Threadself) | Returns the handle of the thread that calls it. | `fbthread.bi` |

## Lock shared data with a mutex

| Function | What it does | From |
|---|---|---|
| [MutexCreate](Mutexcreate) | Creates a mutex and returns its handle, or 0 on failure. | built-in |
| [MutexLock](Mutexlock) | Locks a mutex, waiting while another thread holds it. | built-in |
| [MutexUnlock](Mutexunlock) | Unlocks a mutex so that a waiting thread can take it. | built-in |
| [MutexDestroy](Mutexdestroy) | Destroys a mutex once no thread is using it. | built-in |

## Wait for a signal with a condition variable

| Function | What it does | From |
|---|---|---|
| [CondCreate](Condcreate) | Creates a condition variable and returns its handle, or 0 on failure. | built-in |
| [CondWait](Condwait) | Unlocks the mutex and waits for a signal, then locks the mutex again. | built-in |
| [CondSignal](Condsignal) | Wakes one thread waiting on the condition; the signal is lost if none is waiting. | built-in |
| [CondBroadcast](Condbroadcast) | Wakes every thread waiting on the condition. | built-in |
| [CondDestroy](Conddestroy) | Destroys a condition variable once no thread is waiting on it. | built-in |

## See Also

- [Goroutines and channels guide](Category-Goroutines-and-Channels)
- [Goroutines tutorial](Modern-Goroutines-Tutorial)
- [Threading support functions](Category-Threading-Support-Functions)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
