[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **ThreadWait**

# ThreadWait

Waits for a thread to finish, then releases its handle.

## Syntax

```freebasic
Declare Sub ThreadWait ( ByVal id As Any Ptr )
```

## Parameters

- `id`

## Description

**ThreadWait** waits for a thread created by [`ThreadCreate`](Threadcreate) or [`ThreadCall`](Threadcall) to finish execution, and then releases the resources associated with the thread handle. **ThreadWait** does not return until the thread designated by `id` ends.
 During the wait, no CPU time is consumed by the caller.

 In order to release a thread handle without waiting for the thread to finish, use [`ThreadDetach`](Threaddetach).

 **ThreadWait** does not force the thread to end; if a thread requires a signal to force its end, a mechanism such as shared variables and mutexes must be used.

 In order to avoid memory leaks, the safe way to end a thread is to always signal to it that it must end, and then call **ThreadWait** on that thread except if [`ThreadDetach`](Threaddetach) has previously been called.

 The intrinsic macro [`__FB_MT__`](Fb-Mt) is only automatically set from the point of usage of **ThreadWait** onward.

## Remarks

### Usage

`ThreadWait( id )`

### Dialect Differences

- Threading is not allowed in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Platform Differences

- **ThreadWait** is not available with the DOS version of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.

### Differences from QB

- New to FreeBASIC

### See also

- [`ThreadCreate`](Threadcreate)
- [`ThreadDetach`](Threaddetach)

## Examples

See the [`ThreadCreate`](Threadcreate) examples.

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
