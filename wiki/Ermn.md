[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Ermn**

# Ermn

Returns a pointer to the name of the source file where the last error happened.

## Syntax

```freebasic
Declare Function Ermn ( ) As ZString Ptr
```

## Description

An error reporting function returning a pointer to the name of the module.

## Return Value

Returns a pointer to the string identifying the module where the error occurred.

 The module name is recorded whether or not the source is compiled with the *[-exx](Compiler-Option-Exx)* compiler option. It is [`Erfn`](Erfn) that returns NULL without *-exx*.

## Remarks

### Usage

`result = Ermn ( )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Ermn`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Erfn`](Erfn)
- [`Erl`](Erl)
- [`On...Error`](On-Error)

## Examples

```freebasic
'' test.bas

'' compile with fbc -exx -lang fblite test.bas

#lang "fblite"

Sub Generate_Error

  On Error Goto Handler

  Error 1000

  Exit Sub

Handler:

  Print "Error Function: "; *Erfn()

  Print "Error Module  : "; *Ermn()

  Resume Next

End Sub

Generate_Error
```

 **Output:**

```freebasic
Error Function: GENERATE_ERROR
Error Module  : test.bas
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
