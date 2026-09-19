[Home](Home) › [Tutorials](Category-Tutorials) › **Mutual Exclusion**

# Mutual Exclusion

The built-in procedures that deal with mutexes for **Mutual Exclusion** (create, lock/unlock, and destroy the mutexes).

 **Preamble:**

 Mutual exclusion is the method of serializing access to shared resources. If programmer do not want a thread to be accessing a shared resource that is already in the process of being accessed by another thread, he can use a mutex.

 Logically a mutex is a lock with only one key:

**-** If a thread wishes to access a shared resource, the thread must first gain the lock.
 **-** Once it has the lock it may do what it wants with the shared resource without concerns of other threads accessing the shared resource because other threads will have to wait.
 **-** Once the thread finishes using the shared resource, it unlocks the mutex, which allows other threads to access the shared resource.

A mutex is a lock that guarantees three things:

**-** Atomicity - Locking a mutex is an atomic operation, meaning that the operating system (or threads library) assures you that if you locked a mutex, no other thread succeeded in locking this mutex at the same time.
 **-** Singularity - If a thread managed to lock a mutex, it is assured that no other thread will be able to lock the thread until the original thread releases the lock.
 **-** Non-Busy Wait - If a thread attempts to lock a thread that was locked by a second thread, the first thread will be suspended (and will not consume any CPU resources) until the lock is freed by the second thread. At this time, the first thread will wake up and continue execution, having the mutex locked by it.

This is a protocol that serializes access to a shared resource.  
 Note that such a protocol must be enforced for resource a mutex is protecting across all threads that may touch the resource being protected (including the implicit main thread).

 Mutex capability can be fully used even with a detached thread (only its handler is no longer accessible by its identifier).

Creating / Destructing a mutex

[`MutexCreate`](Mutexcreate) creates a mutex, returning a handle identifier which is to be referred to when destroying the mutex.  
 Mutexes created with [`MutexCreate`](Mutexcreate) should be destroyed when no longer needed or before the end of the program with [`MutexDestroy`](Mutexdestroy).

 *Create*

**-** Syntax:

`Declare Function MutexCreate ( ) As Any Ptr`

**-** Usage:

`mutexid = MutexCreate`

**-** Return value:

The `Any Ptr` handle `(mutexid)` to the mutex created, or the null pointer (`0`) on failure.

*Destroy*

**-** Syntax:

`Declare Sub MutexDestroy ( ByVal mutexid As Any Ptr )`

**-** Usage:

`MutexDestroy( mutexid )`

**-** Parameter:

`mutexid`

The `Any Ptr` handle of the mutex to be destroyed.

*Description*

The call to [`MutexCreate`](Mutexcreate) must be executed before creating any thread using it (and before its use in the thread that creates it).  
 The call to [`MutexDestroy`](Mutexdestroy) must be executed after any threads using the mutex are no longer in use (and after its last use in the thread that destroys it).

Locking / Unlocking a mutex

[`MutexLock`](Mutexlock)/[`MutexUnlock`](Mutexunlock) allow to lock/unlock a mutex by referring to its handle identifier get at its creation.

 *Lock*

**-** Syntax:

`Declare Sub MutexLock ( ByVal mutexid As Any Ptr )`

**-** Usage:

`MutexLock( mutexid )`

**-** Parameter:

`mutexid`

The `Any Ptr` handle of the mutex to be locked.

*Unlock*

**-** Syntax:

`Declare Sub MutexUnlock ( ByVal mutexid As Any Ptr )`

**-** Usage:

`MutexUnlock( mutexid )`

**-** Parameter:

`mutexid`

The `Any Ptr` handle of the mutex to be unlocked.

*Description*

The code between the lock and unlock calls to the mutex, is referred to as a critical section.  
 Minimizing time spent in the critical section allows for greater concurrency because it potentially reduces the amount of time other threads must wait to gain the lock.  
 Therefore, it is important for a thread programmer to minimize critical sections if possible.

Pseudo-code section

By applying all proper above rules:

```freebasic
'  Principle of mutual exclusion between 2 threads
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Thread                                         Other Thread
'      MUTEXLOCK(mutexID) <----------------.    .---> MUTEXLOCK(mutexID)
'      Do_something_with_exclusion    .--- | ---'     Do_something_with_exclusion
'      MUTEXUNLOCK(mutexID) ----------'    '--------- MUTEXUNLOCK(mutexID)

```

Example

The first example on the previous page ([`Threads`](Threads)) is modified so that each thread no longer displays a single character ("M" or "C") but now a sequence of three characters ("\[M\]" from the main thread, "(C)" for the child thread).  
 The tempo in each thread loop has been cut into three chunks to help interleave the display between threads.

- Using this example as is:

```freebasic
Declare Sub thread (ByVal userdata As Any Ptr)

Dim As Any Ptr threadID  '' declaration of an 'Any Ptr' thread-ID of the child thread

Print """[M]"": from 'Main' thread"

Print """(C)"": from 'Child' thread"

Print

threadID = ThreadCreate(@thread)  '' creation of the child thread from the main thread

For I As Integer = 1 To 10  '' 'For' loop of the main thread

    Print "[";

    Sleep 50, 1

    Print "M";

    Sleep 50, 1

    Print "]";

    Sleep 50, 1

Next I

ThreadWait(threadID)  '' waiting for the child thread termination

Print

Print "'Child' thread finished"

Sleep

Sub thread (ByVal userdata As Any Ptr)  '' sub executed by the child thread

    For I As Integer = 1 To 10          '' 'For' loop of the child thread

        Print "(";

        Sleep 50, 1

        Print "C";

        Sleep 50, 1

        Print ")";

        Sleep 250, 1

    Next I

End Sub
```

 Output example:

```freebasic
"[M]": from 'Main' thread
"(C)": from 'Child' thread

[(CM])[M][(MC])[M][(MC])[M][(MC])[M][M(]C)[M](C)(C)(C)(C)(C)
'Child' thread finished

```

The display highlights an interlace in the sequence (of three characters) outputted from each thread.  
 In each thread, the code section displaying the three-character sequence should not be interrupted by the display of the other thread.  
 These two sections of code must therefore be considered as critical sections to be protected by a block *\[Mutexlock ... Mutexunlock\]*.

- Using mutual exclusion with a mutex:

```freebasic
'  Principle of mutual exclusion

'      Main thread                      XOR            Child thread

'  .....                                           .....

'  MUTEXLOCK(mutID)                                MUTEXLOCK(mutID)

'      Do_something_with_exclusion                     Do_something_with_exclusion

'  MUTEXUNLOCK(mutID)                              MUTEXUNLOCK(mutID)

'  .....                                           .....

Declare Sub thread (ByVal userdata As Any Ptr)

Dim As Any Ptr threadID      '' declaration of an 'Any Ptr' thread-ID of the child thread

Dim Shared As Any Ptr mutID  '' declaration of a global 'Any Ptr' mutex-ID

    mutID = MutexCreate      '' creation of the mutex

Print """[M]"": from 'Main' thread"

Print """(C)"": from 'Child' thread"

Print

threadID = ThreadCreate(@thread)  '' creation of the child thread from the main thread

For I As Integer = 1 To 10  '' 'For' loop of the main thread

    MutexLock(mutID)        '' set mutex locked at the beginning of the exclusive section

    Print "[";

    Sleep 50, 1

    Print "M";

    Sleep 50, 1

    Print "]";

    MutexUnlock(mutID)      '' set mutex unlocked at the end of the exclusive section

    Sleep 50, 1

Next I

ThreadWait(threadID)  '' waiting for the child thread termination

Print

Print "'Child' thread finished"

MutexDestroy(mutID)  '' destruction of the mutex

Sleep

Sub thread (ByVal userdata As Any Ptr)  '' sub executed by the child thread

    For I As Integer = 1 To 10          '' 'For' loop of the child thread

        MutexLock(mutID)                '' set mutex locked at the beginning of the exclusive section

        Print "(";

        Sleep 50, 1

        Print "C";

        Sleep 50, 1

        Print ")";

        MutexUnlock(mutID)              '' set mutex unlocked at the end of the exclusive section

        Sleep 250, 1

    Next I

End Sub
```

 Output example:

```freebasic
"[M]": from 'Main' thread
"(C)": from 'Child' thread

[M](C)[M][M](C)[M][M](C)[M][M](C)[M][M](C)[M](C)(C)(C)(C)(C)
'Child' thread finished

```

So, display becomes coherent compared to each three-character sequence.

See also

- [`MutexCreate`](Mutexcreate), [`MutexDestroy`](Mutexdestroy)
- [`MutexLock`](Mutexlock), [`MutexUnlock`](Mutexunlock)
- [Multi-Threading Overview](Multi-Threading)
- [Threads](Threads)
- [Conditional Variables](Conditional-Variables)
- [Critical Sections](Critical-Sections)
- [Critical Sections FAQ](Critical-Sections-Faq)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
