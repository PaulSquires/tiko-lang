[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **ThreadCall**

# ThreadCall

Starts a user-defined procedure with parameters in a separate execution thread Threadcall uses LibFFI internally: people who write programs using this functionality should be careful to follow LibFFI's license, which can be found at http://github.com/atgreen/libffi/blob/master/LICENSE.

## Syntax

```freebasic
Function ThreadCall subname([paramlist]) As Any Ptr
```

## Parameters

- `subname`
- `paramlist`

## Description

Like [`ThreadCreate`](Threadcreate), **Threadcall** creates a thread which runs at the same time as the code calling it. By placing "**Threadcall**" before almost any normal call to sub, the sub is called inside of a new thread and returns a pointer to that thread.

 Using **Threadcall** is simpler method of creating threads, and allows data to be passed to the thread without global variables or pointers which are not type safe. However, [`ThreadCreate`](Threadcreate) is more efficient and should be used for programs creating a large number of threads.

 While most subroutines are supported, the following types of subroutines may not be called:

When using **Threadcall**, parenthesis around the parameter list are required unless the subroutine has no parameters.

 **Warning:**

**-** Presently when **Threadcall** involves to pass parameters to the thread, there is no guarantee that the corresponding data are still maintained after the end of the **Threadcall** statement and this until the thread is launched.
 **-** That can cause bad behavior:

- see example below where the not displayed parameter `id` seems to be the consequence of a prematurely destroyed string argument (visible for a fbc version >= 1.00),
 - replace `id As String` with `id As Zstring` in the parameters declaration seems to workaround the problem when passing this parameter.

**-** Therefore it is more advisable for the moment to use [`ThreadCreate`](Threadcreate) (100% safe) instead.

## Return Value

**Threadcall** returns an `Any Ptr` handle to the thread created, or the null pointer (`0`) on failure.

## Remarks

### Usage

`threadid = ThreadCall subname([paramlist])`

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- **Threadcall** is not available with the DOS version / target of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.
  In Linux the threads are always started in the order they are created, this can't be assumed in Win32. It's an OS, not a FreeBASIC issue.  
  In Linux, the [`stdcall`](Stdcall) and [`pascal`](Pascal) calling conventions are not supported  
  In Windows, the [`pascal`](Pascal) calling convention is not supported.

### Differences from QB

- New to FreeBASIC

### See also

- [`ThreadCreate`](Threadcreate)
- [`ThreadWait`](Threadwait)
- [`MutexCreate`](Mutexcreate)
- [`MutexLock`](Mutexlock)
- [`MutexUnlock`](Mutexunlock)
- [`MutexDestroy`](Mutexdestroy)

## Examples

```freebasic
'' Threading using "ThreadCall"

Sub thread( id As String, tlock As Any Ptr, count As Integer )

    For i As Integer = 1 To count

        MutexLock tlock

        Print "thread " & id;

        Locate , 20

        Print i & "/" & count

        MutexUnlock tlock

    Next

End Sub

Dim tlock As Any Ptr = MutexCreate()

Dim a As Any Ptr = ThreadCall thread("A", tlock, 6)

Dim b As Any Ptr = ThreadCall thread("B", tlock, 4)

ThreadWait a

ThreadWait b

MutexDestroy tlock

Print "All done (and without Dim Shared!)"
```

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
