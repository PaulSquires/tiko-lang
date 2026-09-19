[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **MutexUnlock**

# MutexUnlock

Releases a mutex lock

## Syntax

```freebasic
Declare Sub MutexUnlock ( ByVal id As Any Ptr )
```

## Parameters

- `id`

## Description

`Mutexunlock` releases a mutex "handle" created by [`MutexCreate`](Mutexcreate), and locked with [`MutexLock`](Mutexlock). This allows other threads sharing the mutex to continue execution.

 See [`MutexCreate`](Mutexcreate) for more general information on mutexes.

## Remarks

### Usage

`MutexUnlock( id )`

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- The DOS version of FreeBASIC does not allow for threads, as the OS does not support them.
  In Linux the threads are always started in the order they are created, this can't be assumed in Win32. It's an OS, not a FreeBASIC issue.

### Differences from QB

- New to FreeBASIC

### See also

- [`MutexCreate`](Mutexcreate)
- [`MutexDestroy`](Mutexdestroy)
- [`MutexLock`](Mutexlock)
- [`ThreadCreate`](Threadcreate)
- [`ThreadWait`](Threadwait)

## Examples

See the examples in [`MutexCreate`](Mutexcreate) and also [`ThreadCreate`](Threadcreate).

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
