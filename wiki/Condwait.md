[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **CondWait**

# CondWait

Unlocks the mutex and waits for a signal, then locks the mutex again.

## Syntax

```freebasic
Declare Sub CondWait ( ByVal handle As Any Ptr, ByVal mutex As Any Ptr )
```

## Parameters

- `handle`
- `mutex`

## Description

Function that stops the thread where it is called until some other thread [`CondSignal`](Condsignal)s or [`CondBroadcast`](Condbroadcast)s the handle.

 Once the conditional variable is created with [`CondCreate`](Condcreate) and the threads are started, one of more of them (including the implicit main thread executing main program) can be set to `CondWait` for the conditional; they will be stopped until some other thread [`CondSignal`](Condsignal)s that the waiting thread can restart. [`CondBroadcast`](Condbroadcast) can be used to restart all threads waiting for the conditional. At the end of the program [`CondDestroy`](Conddestroy) must be used to avoid leaking resources in the OS.

 When calling `CondWait`, `mutex` should already be locked (using the same `mutex` as one used with [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast)). An atomic unlock of the `mutex` and wait on the conditional variable will occur. The calling thread execution is suspended and does not consume any CPU time until the condition variable is signaled. When the condition variable becomes signaled, `mutex` will be locked again and then execution will return to the thread after the `CondWait` call, but with the mutex owned by the caller. The caller is then responsible for unlocking `mutex` in order to complete `CondWait` subroutine so that execution after the `CondWait` call can then resume.

 **Note:** It is a good habit to use `CondWait` in a protected way against eventual spurious wakeups.
 For that, `CondWait` is put within a loop for checking that a Boolean predicate is indeed true (predicate set true by another thread just before executing [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast)) when the thread has finished waiting:

signal-caller:

```freebasic
predicate = true

Condsignal(handle)
```

waiting-called:

```freebasic
While predicate <> true

Condwait(handle, mutex)

Wend

predicate = false
```

the loop can terminate only when the predicate is true.

On the other hand, if the predicate is already true before the thread reaches the loop, `CondWait` is downright skipped (allowing to take into account a case of [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast) that would have been lost otherwise, because prematurely executed in a second thread before the first thread is really waiting for this).  
 See example below for detailed coding.

## Remarks

### Usage

`CondWait ( handle, mutex )`

### Platform Differences

- **Condwait** is not available with the DOS version / target of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.
  In Linux the threads are always started in the order they are created, this can't be assumed in Win32. It's an OS, not a FreeBASIC issue.

### Dialect Differences

- Threading is not allowed in *[-lang qb](Compiler-Option-Lang)*

### Differences from QB

- New to FreeBASIC

### See also

- [`CondCreate`](Condcreate)
- [`CondDestroy`](Conddestroy)
- [`CondBroadcast`](Condbroadcast)
- [`CondSignal`](Condsignal)
- [`MutexCreate`](Mutexcreate)
- [`MutexLock`](Mutexlock)
- [`MutexUnlock`](Mutexunlock)
- [`ThreadCreate`](Threadcreate)

## Examples

See also [`CondCreate`](Condcreate) and [`CondSignal`](Condsignal)

```freebasic
' This simple example code demonstrates the use of several condition variable routines.

' The main routine creates three threads.

' Two of the threads update a "count" variable.

' The third thread waits until the count variable reaches a specified value.

#define numThread  3

#define countThreshold 6

Dim Shared As Integer count = 0

Dim Shared As Any Ptr countMutex

Dim Shared As Any Ptr countThresholdCV

Dim As Any Ptr threadID(0 To numThread-1)

Dim Shared As Integer ok = 0

Sub threadCount (ByVal p As Any Ptr)

    Print "Starting threadCount(): thread#" & p

    Do

        Print "threadCount(): thread#" & p & ", locking mutex"

        MutexLock(countMutex)

        count += 1

        ' Check the value of count and signal waiting thread when condition is reached.

        ' Note that this occurs while mutex is locked.

        If count >= countThreshold Then

            If count = countThreshold Then

                Print "threadCount(): thread#" & p & ", count = " & count & ", threshold reached, unlocking mutex"

                ok = 1

                CondSignal(countThresholdCV)

            Else

                Print "threadCount(): thread#" & p & ", count = " & count & ", threshold exceeded, unlocking mutex"

            End If

            MutexUnlock(countMutex)

            Exit Do

        End If

        Print "threadCount(): thread#" & p & ", count = " & count & ", unlocking mutex"

        MutexUnlock(countMutex)

        Sleep 100, 1

    Loop

End Sub

Sub threadWatch (ByVal p As Any Ptr)

    Print "Starting threadWatch(): thread#" & p & ", locking mutex, waiting for conditional"

    MutexLock(countMutex)

    ' Note that the Condwait routine will automatically and atomically unlock mutex while it waits.

    While ok = 0

        CondWait(countThresholdCV, countMutex)

    Wend

    Print "threadWatch(): thread#" & p & ", condition signal received"

    Print "threadWatch(): thread#" & p & ", count now = " & count & ", unlocking mutex"

    MutexUnlock(countMutex)

End Sub

' Create mutex and condition variable

countMutex = MutexCreate

countThresholdCV = CondCreate

' Create threads

threadID(0) = ThreadCreate(@threadWatch, Cast(Any Ptr, 1))

threadID(1) = ThreadCreate(@threadCount, Cast(Any Ptr, 2))

threadID(2) = ThreadCreate(@threadCount, Cast(Any Ptr, 3))

' Wait for all threads to complete

For I As Integer = 0 To numThread-1

    ThreadWait(threadID(I))

    Print "Main(): Waited on thread#" & I+1 & " Done"

Next I

MutexDestroy(countMutex)

CondDestroy(countThresholdCV)
```

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
