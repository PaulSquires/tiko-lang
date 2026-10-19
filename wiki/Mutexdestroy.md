[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **MutexDestroy**

# MutexDestroy

Destroys a mutex once no thread is using it.

## Syntax

```freebasic
Declare Sub MutexDestroy ( ByVal id As Any Ptr )
```

## Parameters

- `id`

## Description

`Mutexdestroy` discards a mutex created by [`MutexCreate`](Mutexcreate). This call should be executed after any threads using the mutex are no longer in use.

 See [`MutexCreate`](Mutexcreate) for more general information on mutexes.

## Remarks

### Usage

`MutexDestroy( id )`

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- The DOS version of FreeBASIC does not allow for threads, as the OS does not support them.
  In Linux the threads are always started in the order they are created, this can't be assumed in Win32. It's an OS, not a FreeBASIC issue.

### Differences from QB

- New to FreeBASIC

### See also

- [`MutexCreate`](Mutexcreate)
- [`MutexLock`](Mutexlock)
- [`MutexUnlock`](Mutexunlock)
- [`ThreadCreate`](Threadcreate)
- [`ThreadWait`](Threadwait)

## Examples

See the examples in [`MutexCreate`](Mutexcreate) and also [`ThreadCreate`](Threadcreate).

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
