[Home](Home) › [All Categories](Categories) › **Threading Support Functions**

# Threading Support Functions

<!-- finder:start -->

Grouped by task. [Running things at once](Functions-Concurrency) lists them beside the rest of the area.

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

## Also in this category

- [ThreadCall](Threadcall)
- [Threading Support Functions](Threading-Support-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
