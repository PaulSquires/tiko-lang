[Home](Home) › [Tutorials](Category-Tutorials) › **Conditional Variables**

# Conditional Variables

The built-in procedures that create, wait-for/signal, and destroy **Conditional Variables**.

 **Preamble:**

 A condition variable is a mechanism that allows threads to wait (without wasting CPU cycles) for some even to occur.  
 Several threads may wait on a condition variable, until some other thread signals this condition variable (thus sending a notification).  
 At this time, one of the threads waiting on this condition variable wakes up, and can act on the event. It is possible to also wake up all threads waiting on this condition variable by using a broadcast method on this variable.

 A condition variable does not provide locking. Thus, a mutex must be used along with the condition variable, to provide the necessary locking when accessing this condition variable.

 Conditional variable capability (and also mutex capability) can be fully used even with a detached thread (only its handler is no longer accessible by its identifier).

Creating / Destructing a conditional variable

[`CondCreate`](Condcreate) creates a condition variable, returning a handle identifier which is to be referred to when destroying the condition variable.  
 Condition variables created with [`CondCreate`](Condcreate) should be destroyed when no longer needed or before the end of the program with [`CondDestroy`](Conddestroy) (to avoid leaking resources in the OS).

 *Create*

**-** Syntax:

`Declare Function CondCreate ( ) As Any Ptr`

**-** Usage:

`conditionalid = CondCreate`

**-** Return value:

The `Any Ptr` handle `(conditionalid)` to the conditional variable created, or the null pointer (`0`) on failure.

*Destroy*

**-** Syntax:

`Declare Sub CondDestroy ( ByVal conditionalid As Any Ptr )`

**-** Usage:

`CondDestroy ( conditionalid )`

**-** Parameter:

`conditionalid`

The `Any Ptr` handle of the conditional variable to be destroyed.

*Description*

[`CondDestroy`](Conddestroy) destroys a condition variable, freeing the resources it might hold.  
 No threads must be waiting on the condition variable on entrance to [`CondDestroy`](Conddestroy).

Waiting-for/Signaling a conditional variable

The condition variable mechanism allows threads to suspend execution and relinquish the processor until some condition is true.

 [`CondWait`](Condwait) stops execution of the current thread until some condition becomes true.  
 [`CondSignal`](Condsignal) allows to restart one thread waiting on the conditional, while [`CondBroadcast`](Condbroadcast) allows to restart all threads waiting on the conditional.

 *Wait-for*

**-** Syntax:

`Declare Sub CondWait ( ByVal conditionalid As Any Ptr, ByVal mutexid As Any Ptr )`

**-** Usage:

`CondWait ( conditionalid, mutexid )`

**-** Parameters:

`conditionalid`

The handle identifier of a conditional variable.

`mutexid`

The handle identifier of the mutex associated with this conditional variable, which must be locked when testing the condition and calling [`CondWait`](Condwait).

*Signal*

**-** Syntax:

`Declare Sub CondSignal ( ByVal conditionalid As Any Ptr )`

or

`Declare Sub CondBroadcast ( ByVal conditionalid As Any Ptr )`

**-** Usage:

`CondSignal ( conditionalid )`

or

`CondBroadcast ( conditionalid )`

**-** Parameter:

`conditionalid`

The `Any Ptr` handle of the conditional variable to be signaled.

*Description*

Once the conditional variable is created with [`CondCreate`](Condcreate) and the threads are started, one of more of them (including the implicit main thread executing main program) can be set in waiting for the conditional state by [`CondWait`](Condwait).  
 They will be stopped until another thread signals by [`CondSignal`](Condsignal) that one among the waiting threads can restart.  
 [`CondBroadcast`](Condbroadcast) can be used to restart all threads waiting for the conditional.

 A condition variable must always be associated with a mutex to avoid a race condition created by one thread preparing to wait and another thread which may signal the condition before the first thread actually waits on it resulting in a deadlock. The thread will be perpetually waiting for a signal that is never sent. Any mutex can be used, there is no explicit link between the mutex and the condition variable.

 When calling [`CondWait`](Condwait), mutex should already be locked (using the same mutex as one used with [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast)).  
 The detailed sequence is the following:

**-** An atomic unlock of the mutex is applied before entering in waiting on the conditional variable in order to release other eventual threads using this mutex (this is why [`CondWait`](Condwait) takes as arguments both the mutex and condition variable).
 **-** The thread execution is suspended and does not consume any CPU time until the condition variable is signaled.
 **-** When the condition variable becomes signaled, mutex is atomically re-locked.
 **-** The thread execution can resume after the [`CondWait`](Condwait) statement, but is suspended because of the locked mutex owned by the signal-caller.
 **-** So, the signal-caller is then responsible for unlocking mutex in order that the called-thread completes the [`CondWait`](Condwait) subroutine and that execution after the [`CondWait`](Condwait) call can then really resume.

[`CondSignal`](Condsignal) restarts one thread waiting. It should be called after mutex is locked (using the same mutex as one used with [`CondWait`](Condwait)):

**-** If no threads are waiting on the conditional, nothing happens (the signal is lost forever).
 **-** if several are waiting, only one is restarted:

**.** It might be that a condition variable that has several threads waiting on it is signaled many times, and yet one of the threads waiting on it never awakened.
 **.** This is because it is not known which of the waiting threads is awakened when the variable is signaled.
 **.** It might be that the awakened thread quickly comes back to waiting on the condition variables, and gets awakened again when the variable is signaled again, and so on (no wake-up priority based on history is assured).
 **.** It is up to the programmer to make sure this situation does not occur if it implies bad behavior.

When using [`CondBroadcast`](Condbroadcast), this does not mean all threads are running together:

**-** Each of them tries to lock the mutex again before returning from their wait function.
 **-** And thus they will start running one by one, each one locking the mutex, doing their work, and freeing the mutex before the next thread gets its chance to run.

**Note:**

**-** It is a good habit to use [`CondWait`](Condwait) in a protected way against eventual spurious wake-ups.
 **-** For that, [`CondWait`](Condwait) is put within a loop for checking that a Boolean predicate is indeed true (predicate set true by another thread just before executing [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast)) when the thread has finished waiting:

signal-caller:

**```freebasic
predicate = True

Condsignal(conditionalid)
```**

waiting-called:

**```freebasic
While predicate <> True

Condwait(conditionalid, mutexid)

Wend

predicate = False
```**

**-** The loop can terminate only when the predicate is true.
 **-** On the other hand, if the predicate is already true before the thread reaches the loop, [`CondWait`](Condwait) is downright skipped (allowing to take into account a case of [`CondSignal`](Condsignal) or [`CondBroadcast`](Condbroadcast) that would have been lost otherwise, because prematurely executed in a second thread before the first thread is really waiting for this).

**Pseudo-codes for detailed coding by applying all proper above rules:**

**-** Pseudo-code for the "waiting-for" critical sub-section (with the links to/from critical section items of other thread):

```freebasic
'  Principle of mutual exclusion + waiting-for, for a thread sub-section
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Thread                                         Other Thread
'      MUTEXLOCK(mutexID) <-------------------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      .......
'      While booleanT <> True <---------------------- from booleanT = True
'          ( atomic_mutex_unlock(mutexID) ) --------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )
'          CONDWAIT(conditionalID, mutexID) <-------- from CONDSIGNAL(conditionalID)
'          ( atomic_mutex_re-lock(mutexID) ) <------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      Wend
'      booleanT = False
'      .......
'      MUTEXUNLOCK(mutexID) ------------------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

**-** Pseudo-code for the "signaling" critical sub-section (with the links to/from the critical section items of other thread):

```freebasic
'  Principle of mutual exclusion + signaling, for a thread sub-section
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Thread                              Other Thread
'      MUTEXLOCK(mutexID) <--------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      .......
'      booleanOT = True -----------------> to While booleanOT <> True
'      CONDSIGNAL(conditionalID) --------> to CONDWAIT(conditionalID, mutexID)
'      .......
'      MUTEXUNLOCK(mutexID) -------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

**-** Pseudo-code for the "signaling, then waiting-for" critical section (with the links to/from the critical section items of other thread):

```freebasic
'  Principle (1) of mutual exclusion + mutual synchronization, for a thread section
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Thread                                        Other Thread
'      MUTEXLOCK(mutexID) <------------------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      Do_something_1_with_exclusion
'      booleanOT = True ---------------------------> to While booleanOT <> True
'      CONDSIGNAL(conditionalID) ------------------> to CONDWAIT(conditionalID, mutexID)
'      While booleanT <> True <--------------------- from booleanT = True
'          ( atomic_mutex_unlock(mutexID) ) -------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )
'          CONDWAIT(conditionalID, mutexID) <------- from CONDSIGNAL(conditionalID)
'          ( atomic_mutex_re-lock(mutexID) ) <------ from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      Wend
'      booleanT = False
'      Do_something_2_with_exclusion
'      MUTEXUNLOCK(mutexID) -----------------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

**-** Pseudo-code for the "waiting-for, then signaling" critical section (with the links to/from critical section items of other thread):

```freebasic
'  Principle (2) of mutual exclusion + mutual synchronization, for a thread section
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Thread                                         Other Thread
'      MUTEXLOCK(mutexID) <-------------------------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      Do_something_1_with_exclusion
'      While booleanT <> True <---------------------- from booleanT = True
'          ( atomic_mutex_unlock(mutexID) ) --------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )
'          CONDWAIT(conditionalID, mutexID) <-------- from CONDSIGNAL(conditionalID)
'          ( atomic_mutex_re-lock(mutexID) ) <------- from ( atomic_mutex_unlock(mutexID) ) or MUTEXUNLOCK(mutexID)
'      Wend
'      booleanT = False
'      Do_something_2_with_exclusion
'      booleanOT = True ----------------------------> to While booleanOT <> True
'      CONDSIGNAL(conditionalID) -------------------> to CONDWAIT(conditionalID, mutexID)
'      MUTEXUNLOCK(mutexID) ------------------------> to MUTEXLOCK(mutexID) or ( atomic_mutex_re-lock(mutexID) )

```

**-** Pseudo-code for the "signaling, then waiting-for" critical section of a main thread and for "waiting-for, then signaling" critical section of a child thread (with the links to/from critical section items of both threads):

```freebasic
'  Principle (example) of mutual exclusion + mutual synchronization sections, between 2 threads,
'  using the principle (1) for the main thread, and the principle (2) for the child thread
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Main Thread                                                                          Child Thread
'      MUTEXLOCK(mutexID) <-----------------------------.     .-------------.-------------> MUTEXLOCK(mutexID)
'      Do_something_1_with_exclusion                    |     |             |               Do_something_1_with_exclusion
'      boolC = True ----------------------------------- | --- | ----------- | ------------> While boolC <> True
'      CONDSIGNAL(conditionalID) ---------------------- | --- | ----------- | ---.    .-------- ( atomic_mutex_unlock(mutexID) )
'      While boolM <> True <--------------------------- | --- | ---------.  |    '--- | ------> CONDWAIT(conditionalID, mutexID)
'          ( atomic_mutex_unlock(mutexID) ) ------.     |     |          |  '-------- | ------> ( atomic_mutex_re-lock(mutexID) )
'          CONDWAIT(conditionalID, mutexID) <---- | --- | --- | ------.  |            |     Wend
'          ( atomic_mutex_re-lock(mutexID) ) <--- | ----'---- | ---.  |  |            |     boolC = False
'      Wend                                       |           |    |  |  |            |     Do_something_2_with_exclusion
'      boolM = False                              |           |    |  |  '----------- | --- boolM = True
'      Do_something_2_with_exclusion              |           |    |  '-------------- | --- CONDSIGNAL(conditionalID)
'      MUTEXUNLOCK(mutexID) ----------------------'-----------'    '------------------'---- MUTEXUNLOCK(mutexID)

```

Example

The second example on the previous page ([`Mutual Exclusion`](Mutual-Exclusion)) is modified by using a conditional variable to exhibit a synchronization example.  
 So, the two sections of code, previously protected by a mutual exclusion block `[Mutexlock ... Mutexunlock]`, are now synchronized in order that each thread displays one after the other its character sequence ("\[M\]" or "(C)").

 In this example, the two threads critical sections have their sub-sections in an reverse order:

**-** main thread critical section: at first signaling, then waiting for,
 **-** child thread critical section: at first waiting for, then signaling.

Therefore the main thread will always be the first to display its sequence:

```freebasic
'  Principle of mutual exclusion + mutual synchronization between 2 threads with loop
'  (connecting lines join the sender(s) and receiver(s) impacted by each action occurring during the sequence)
'
'          Main Thread                                                                  Child Thread
'  .....                                                                          .....
'  Loop                                                                           Loop
'      MUTEXLOCK(mutID) <-----------------------------.     .-------------.---------> MUTEXLOCK(mutID)
'      Do_something_with_exclusion              .---- | --- | ----------- | --------> While boolC <> True
'      boolC = True ----------------------------'     |     |             |     .-------- ( atomic_mutex_unlock(mutID) )
'      CONDSIGNAL(condID) --------------------------- | --- | ----------- | --- | ------> CONDWAIT(condID, mutID)
'      While boolM <> True <------------------------- | --- | ---------.  '---- | ------> ( atomic_mutex_re-lock(mutID) )
'          ( atomic_mutex_unlock(mutID) ) ------.     |     |          |        |     Wend
'          CONDWAIT(condID, mutID) <----------- | --- | --- | ------.  |        |     boolC = False
'          ( atomic_mutex_re-lock(mutID) ) <--- | ----'---- | ---.  |  |        |     Do_something_with_exclusion
'      Wend                                     |           |    |  |  '------- | --- boolM = True
'      boolM = False                            |           |    |  '---------- | --- CONDSIGNAL(condID)
'      MUTEXUNLOCK(mutID) ----------------------'-----------'    '--------------'---- MUTEXUNLOCK(mutID)
'  End Loop                                                                       End Loop
'  .....                                                                          .....

```

```freebasic
Declare Sub thread (ByVal userdata As Any Ptr)

Dim As Any Ptr threadID             '' declaration of an 'Any Ptr' thread-ID of the child thread

Dim Shared As Any Ptr mutID         '' declaration of a global 'Any Ptr' mutex-ID

    mutID = MutexCreate             '' creation of the mutex

Dim Shared As Boolean boolM, boolC  '' declaration of 2 global 'Boolean' boolM and boolC as predicates

Dim Shared As Any Ptr condID        '' declaration of a global 'Any Ptr' conditional-ID

    condID = CondCreate             '' creation of the conditional

Print """[M]"": from 'Main' thread"

Print """(C)"": from 'Child' thread"

Print

threadID = ThreadCreate(@thread)  '' creation of the child thread from the main thread

For I As Integer = 1 To 10       '' 'For' loop of the main thread

    MutexLock(mutID)             '' set mutex locked at the beginning of the exclusive section

    Print "[";

    Sleep 50, 1

    Print "M";

    Sleep 50, 1

    Print "]";

    boolC = True                 '' set to 'True' the predicate for the child thread

    CondSignal(condID)           '' signal to the child thread

    While boolM <> True          '' test predicate from the child thread

        CondWait(condID, mutID)  '' wait for signal from the child thread

    Wend

    boolM = False                '' reset the predicate from the child thread

    MutexUnlock(mutID)           '' set mutex unlocked at the end of the exclusive section

    Sleep 50, 1

Next I

ThreadWait(threadID)  '' waiting for the child thread termination

Print

Print "'Child' thread finished"

MutexDestroy(mutID)  '' destruction of the mutex

CondDestroy(condID)  '' destruction of the conditional

Sleep

Sub thread (ByVal userdata As Any Ptr)  '' sub executed by the child thread

    For I As Integer = 1 To 10          '' 'For' loop of the child thread

        MutexLock(mutID)                '' set mutex locked at the beginning of the exclusive section

        While boolC <> True             '' test predicate from the main thread

            CondWait(condID, mutID)     '' wait for signal from the main thread

        Wend

        boolC = False                   '' reset the predicate from the main thread

        Print "(";

        Sleep 50, 1

        Print "C";

        Sleep 50, 1

        Print ")";

        boolM = True                    '' set to 'True' the predicate for the main thread

        CondSignal(condID)              '' signal to the child thread

        MutexUnlock(mutID)              '' set mutex unlocked at the end of the exclusive section

        Sleep 250, 1

    Next I

End Sub
```

 Output:

```freebasic
"[M]": from 'Main' thread
"(C)": from 'Child' thread

[M](C)[M](C)[M](C)[M](C)[M](C)[M](C)[M](C)[M](C)[M](C)[M](C)
'Child' thread finished

```

See also

- [`CondCreate`](Condcreate), [`CondDestroy`](Conddestroy),
- [`CondWait`](Condwait), [`CondSignal`](Condsignal), [`CondBroadcast`](Condbroadcast)
- [Multi-Threading Overview](Multi-Threading)
- [Threads](Threads)
- [Mutual Exclusion](Mutual-Exclusion)
- [Critical Sections](Critical-Sections)
- [Critical Sections FAQ](Critical-Sections-Faq)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
