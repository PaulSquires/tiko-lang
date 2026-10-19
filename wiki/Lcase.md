[Home](Home) › [String Functions](Category-String-Functions) › **LCase**

# LCase

Returns a lower-case copy of the string.

## Syntax

```freebasic
Declare Function LCase ( ByRef str As Const String, ByVal mode As Long = 0 ) As String
Declare Function LCase ( ByRef str As Const WString, ByVal mode As Long = 0 ) As WString
```

## Parameters

- `str`
- `mode`

## Description

Returns a copy of `str` with all of the letters converted to lower case.

 If `str` is empty, the null string (`"``"`) is returned.

## Return Value

Lowercase copy of `str`.

## Remarks

### Usage

`result = LCase[$]( str [ , mode ] )`

### Platform Differences

- The wide-character string version of `LCase` is not supported for DOS target.

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- QB does not support Unicode.

### See also

- [`UCase`](Ucase)

## Examples

`Print LCase("AbCdEfG")`  
 Output:

```freebasic
abcdefg
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
