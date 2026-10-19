[Home](Home) › [String Functions](Category-String-Functions) › **Space**

# Space

Returns a string of n spaces.

## Syntax

```freebasic
Declare Function Space( ByVal count As Integer ) As String
```

## Parameters

- `count`

## Description

`Space` creates a string with the specified number of spaces.

## Return Value

The created string. An empty string will be returned if `count` <= 0.

## Remarks

### Usage

`result = Space[$]( count )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None

### See also

- [`WSpace`](Wspace)
- [`Spc`](Spc)
- [`String (Function)`](String-Function)

## Examples

```freebasic
Dim a As String

a = "x" + Space(3) + "x"

Print a ' prints: x   x
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
