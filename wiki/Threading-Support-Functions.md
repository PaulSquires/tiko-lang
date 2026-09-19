[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **Threading Support Functions**

# Threading Support Functions

Procedures for working with multithreaded applications.

Description

These procedures allow for multithreaded programming. Threads and conditional variables can be created and destroyed, and so-called *mutexes* can be obtained to protect thread-sensitive data.

**Threads**

Procedures that start and wait for threaded procedures.

**Mutexes**

Procedures that deal with mutexes.

**Conditional Varables**

Procedures that create and signal conditional variables.

***Threads***

**[ThreadCall](Threadcall)**

Starts a procedure with parameters in a separate thread of execution.

**[ThreadCreate](Threadcreate)**

Starts a procedure in a separate thread of execution.

**[ThreadWait](Threadwait)**

Waits for a thread to finish and releases the thread handle.

**[ThreadDetach](Threaddetach)**

Releases a thread handle without waiting for the thread to finish.

**[ThreadSelf](Threadself)**

Returns the thread handle of the current thread.

***Mutexes***

**[MutexCreate](Mutexcreate)**

Creates a mutex.

**[MutexLock](Mutexlock)**

Acquires a lock on a mutex.

**[MutexUnlock](Mutexunlock)**

Releases a lock on a mutex.

**[MutexDestroy](Mutexdestroy)**

Destroys a mutex that is no longer needed.

***Conditional Variables***

**[CondCreate](Condcreate)**

Creates a conditional variable.

**[CondWait](Condwait)**

Pauses execution of a threaded procedure.

**[CondSignal](Condsignal)**

Resumes execution of a threaded procedure waiting for a conditional.

**[CondBroadcast](Condbroadcast)**

Resumes all threaded procedures waiting for a conditional.

**[CondDestroy](Conddestroy)**

Destroys a conditional variable that is no longer needed.

Platform Differences

- These procedures are not supported in DOS.

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
