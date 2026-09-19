[Home](Home) › [String Functions](Category-String-Functions) › **WSpace**

# WSpace

Creates a WString of a given length filled with spaces (" ")

## Syntax

```freebasic
Declare Function WSpace( ByVal count As Integer ) As WString
```

## Parameters

- `count`

## Description

`WSpace` creates a wstring (wide character string- Unicode) with the specified number of spaces.

## Return Value

The created [`WString`](Wstring). An empty string will be returned if `count <= 0`.

## Remarks

### Usage

`result = WSpace( count )`

### Platform Differences

- Unicode strings are not supported in the DOS port of FreeBASIC.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Wspace`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Space`](Space)
- [`WString`](Wstring)

## Examples

```freebasic
Dim a As WString * 10

a = "x" + WSpace(3) + "x"

Print a ' prints: x   x
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
