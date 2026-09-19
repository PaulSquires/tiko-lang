[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Resume Next**

# Resume Next

Error handling statement to resume execution after a jump to an error handler

## Syntax

```freebasic
Resume Next
```

## Description

`Resume Next` is used in the traditional QB error handling mechanism within an error handler (called by [`On Error`](On-Error)) to return execution to the line after the one that caused the error. Usually this is used to avoid executing the same line and causing the error again.

 `Resume Next` resets the [`Err`](Err) value to 0

## Remarks

### Dialect Differences

- RESUME NEXT is not supported in the *[-lang fb](Compiler-Option-Lang)* dialect. Statements can be used in its function form to return an error code

```freebasic
If Open( "text" For Input As #1 ) <> 0 Then

  Print "Unable to open file"

End If
```

### Differences from QB

- Must compile with *[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)* option

### See also

- [`Err`](Err)
- [`Resume`](Resume)
- [Error Handling](Error-Handling)

## Examples

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

Dim As Single i, j

On Error Goto ErrHandler

i = 0

j = 5

j = 1 / i ' this line causes a divide-by-zero error; execution jumps to ErrHandler label

Print "ending..."

End ' end the program so that execution does not fall through to the error handler again

ErrHandler:

Resume Next ' execution jumps to 'Print "ending..."' line, but j is now in an undefined state
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
