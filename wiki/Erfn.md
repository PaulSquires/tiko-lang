[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Erfn**

# Erfn

Error reporting function

## Syntax

```freebasic
Declare Function Erfn ( ) As ZString Ptr
```

## Description

An error reporting function returning a pointer to the name of the function.

## Return Value

Returns a pointer to the string identifying the function where the error occurred.

 Returns NULL if the source is not compiled with the *[-exx](Compiler-Option-Exx)* compiler option.

## Remarks

### Usage

`result = Erfn ( )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Erfn`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Erl`](Erl)
- [`Ermn`](Ermn)
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
