[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **ThreadDetach**

# ThreadDetach

Releases a thread handle without waiting for the thread to finish

## Syntax

```freebasic
Declare Sub ThreadDetach ( ByVal id As Any Ptr )
```

## Parameters

- `id`

## Description

**ThreadDetach** releases resources associated with the thread handle returned by [`ThreadCreate`](Threadcreate) or [`ThreadCall`](Threadcall). The thread handle will be destroyed by **ThreadDetach** and cannot be used anymore.
 Unlike [`ThreadWait`](Threadwait), **ThreadDetach** does not wait for the thread to finish and thread execution continues independently. Any allocated resources will be freed once the thread exits.

 In order to avoid memory leaks, the safe way to end a thread is to always signal to it that it must end, and then call [`ThreadWait`](Threadwait) on that thread except if **ThreadDetach** has previously been called.

 **Note:** As **ThreadDetach** destroys the thread handle, [`ThreadWait`](Threadwait) can no longer check for the thread ending, and even the use of [`ThreadWait`](Threadwait) becomes unpredictable (may crash the program). The use between [`ThreadWait`](Threadwait) and **ThreadDetach** must be exclusive.
 But mutexes and conditional variables can also be used with detached threads.

## Remarks

### Usage

```freebasic
#include "fbthread.bi"

ThreadDetach( id )
```

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- **ThreadDetach** is not available with the DOS version of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.

### Differences from QB

- New to FreeBASIC

### See also

- [`ThreadWait`](Threadwait)
- [`ThreadCreate`](Threadcreate)

## Examples

```freebasic
#include "fbthread.bi"

Sub mythread( ByVal param As Any Ptr )

    Print "hi!"

End Sub

Dim As Any Ptr thread = ThreadCreate( @mythread )

ThreadDetach( thread )

'' or

ThreadDetach( ThreadCreate( @mythread ) )

Sleep
```

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
