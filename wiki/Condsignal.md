[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **CondSignal**

# CondSignal

Wakes one thread waiting on the condition; the signal is lost if none is waiting.

## Syntax

```freebasic
Declare Sub CondSignal ( ByVal handle As Any Ptr )
```

## Parameters

- `handle`

## Description

Once the conditional is created with [`CondCreate`](Condcreate) and the threads are started, one of more of them (including the implicit main thread executing main program) can be set to [`CondWait`](Condwait) for the conditional, they will be stopped until some other thread [`CondSignal`](Condsignal)s that the waiting thread can restart. [`CondBroadcast`](Condbroadcast) can be used to restart all threads waiting for the conditional. At the end of the program [`CondDestroy`](Conddestroy) must be used to avoid leaking resources in the OS.

 **Condsignal** restarts one thread waiting. It should be called after `mutex` is locked (using the same `mutex` as one used with [`CondWait`](Condwait)). If no threads are waiting on the conditional, nothing happens (the signal is lost forever); if several are waiting, only one is restarted. The caller must then unlock `mutex` in order for [`CondWait`](Condwait) subroutine to complete.

## Remarks

### Usage

`CondSignal ( handle )`

### Dialect Differences

- Threading is not allowed in *[-lang qb](Compiler-Option-Lang)*

### Platform Differences

- **Condsignal** is not available with the DOS version / target of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.
  In Linux the threads are always started in the order they are created, this can't be assumed in Win32. It's an OS, not a FreeBASIC issue.

### Differences from QB

- New to FreeBASIC

### See also

- [`CondCreate`](Condcreate)
- [`CondDestroy`](Conddestroy)
- [`CondBroadcast`](Condbroadcast)
- [`CondWait`](Condwait)
- [`ThreadCreate`](Threadcreate)

## Examples

See also [`CondCreate`](Condcreate) and [`CondWait`](Condwait) and [`CondBroadcast`](Condbroadcast)

```freebasic
' This very simple example code demonstrates the use of several condition variable routines.

' The main routine initializes a string and creates one thread.

' The main routine waits until receive the condition signal from the thread, then print the complemented string.

' The thread complements the string, then sends a condition signal.

'

'Principle of mutual exclusion + simple synchronization

'          Thread#A             XOR + ==>            Thread#B

'.....                                     .....

'MutexLock(mut)                            MutexLock(mut)

'  Do_something_with_exclusion               Do_something_with_exclusion

'  Thread_signal = true -------------------> While Thread_signal <> true

'  CondSignal(cond) -------------------------> CondWait(cond, mut)

'  Do_something_with_exclusion      .------> Wend

'MutexUnlock(mut) ------------------'        Thread_signal = false

'.....                                       Do_something_with_exclusion

'.....                                     MutexUnlock(mut)

'.....                                     .....

Dim Shared As Any Ptr mutex

Dim Shared As Any Ptr cond

Dim Shared As String txt

Dim As Any Ptr pt

Dim Shared As Integer ok = 0

Sub thread (ByVal p As Any Ptr)

    Print "thread is complementing the string"

    MutexLock(mutex)

    Sleep 400, 1

    txt &= " complemented by thread"

    ok = 1

    CondSignal(cond)

    MutexUnlock(mutex)

    Print "thread signals the processing completed"

End Sub

mutex = MutexCreate

cond = CondCreate

txt = "example of text"

Print "main() initializes a string = " & txt

Print "main creates one thread"

Print

pt = ThreadCreate(@thread)

MutexLock(mutex)

While ok <> 1

    CondWait(cond, mutex)

Wend

Print

Print "back in main(), the string = " & txt

ok = 0

MutexUnlock(mutex)

ThreadWait(pt)

MutexDestroy(mutex)

CondDestroy(cond)
```

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
