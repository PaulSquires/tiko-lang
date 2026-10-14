[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Local**

# Local

Error handling statement to set the current error handler

## Syntax

```freebasic
On Local Error Goto label
```

## Description

The `Local` clause in an [`On Error`](On-Error) construction allows to define an error handler in the same [`Sub`](Sub) or [`Function`](procedures-Function) the `On Local Error` is in.

 **Remark:** Presently, the `Local` clause (authorized only inside Sub/Function) is ignored by the compiler, and the error handler should be in the scope of the same procedure the On \[Local\] Error is in.

## Remarks

### Differences from QB

- The LOCAL clause comes from PDS 7.1. QB 4.5 does not allow local error handling.

### See also

- [`On Error`](On-Error)

## Examples

```freebasic
'' compile with -lang fblite or qb

#lang "fblite"

Declare Sub foo

foo

Print "ok"

Sleep

Sub foo

  Dim errno As Integer

  On Local Error Goto fail

  Open "xzxwz.zwz" For Input As #1

  On Local Error Goto 0

  Exit Sub

fail:                  ' here starts the error handler

  errno = Err

  Print "Error "; errno      ' just print the error number

  Sleep

End Sub
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
