[Home](Home) › [Threading Support Functions](Category-Threading-Support-Functions) › **CondDestroy**

# CondDestroy

Destroys a multi-threading conditional variable when it is no more needed

## Syntax

```freebasic
Declare Sub CondDestroy ( ByVal handle As Any Ptr )
```

## Parameters

- `handle`

## Description

Once the conditional is [`CondCreate`](Condcreate)d and the threads are started, one of more of them (including the implicit main thread executing main program) can be set to [`CondWait`](Condwait) for the conditional, they will be stopped until some other thread [`CondSignal`](Condsignal)s that the waiting thread can restart. [`CondBroadcast`](Condbroadcast) can be used to restart all threads waiting for the conditional. At the end of the program [`CondDestroy`](Conddestroy) must be used to avoid leaking resources in the OS.

 **Conddestroy** destroys a condition variable, freeing the resources it might hold. No threads must be waiting on the condition variable on entrance to **Conddestroy**.

## Remarks

### Usage

`CondDestroy ( handle )`

### Platform Differences

- **Conddestroy** is not available with the DOS version / target of FreeBASIC, because multithreading is not supported by DOS kernel nor the used extender.

### Dialect Differences

- Threading is not allowed in *[-lang qb](Compiler-Option-Lang)*

### Differences from QB

- New to FreeBASIC

### See also

- [`CondCreate`](Condcreate)
- [`CondBroadcast`](Condbroadcast)
- [`CondSignal`](Condsignal)
- [`CondWait`](Condwait)
- [`ThreadCreate`](Threadcreate)

## Examples

See [`CondCreate`](Condcreate), [`CondWait`](Condwait), [`CondSignal`](Condsignal), and [`CondBroadcast`](Condbroadcast)

---

**Category:** [Threading Support Functions](Category-Threading-Support-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
