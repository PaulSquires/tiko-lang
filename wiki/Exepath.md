[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **ExePath**

# ExePath

Returns the path of the running program

## Syntax

```freebasic
Declare Function ExePath ( ) As String
```

## Description

Returns the path (the location) of the calling program. This is not necessarily the same as [`CurDir`](Curdir).

## Return Value

A [`String`](String) variable set to the path of the running program.

## Remarks

### Usage

`result = ExePath`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Exepath`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CurDir`](Curdir)

## Examples

```freebasic
Dim pathname As String = ExePath

Print "This program's initial directory is: " & pathname
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
