[Home](Home) › [String Functions](Category-String-Functions) › **Chr**

# Chr

Returns a string of characters from one or more ASCII integer values

## Syntax

```freebasic
Declare Function Chr ( ByVal ch As Integer [, ... ] ) As String
```

## Parameters

- `ch`

## Description

`Chr` returns a string containing the character(s) represented by the [ASCII](Table-of-Ascii-Characters) values passed to it.

 When `Chr` is used with numerical constants or literals, the result is evaluated at compile-time, so it can be used in variable initializers.

 [`Asc`](Asc) performs the opposite function, returning the [ASCII](Table-of-Ascii-Characters) code of a character represented by a string.

## Return Value

Returns a string containing the character(s).

## Remarks

### Usage

`result = Chr[$]( ch0 [, ch1 ... chN ] )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- FreeBASIC accepts multiple integer values as arguments, QB accepted only one.
- FreeBASIC evaluates the CHR function at compile time when used with constants or literals.

### See also

- [ASCII Character Codes](Table-of-Ascii-Characters)
- [`WChr`](Wchr)
- [`Asc`](Asc)
- [`Str`](Str)
- [`Val`](Val)

## Examples

```freebasic
Print "the character represented by";

Print " the ASCII code of 97 is: "; Chr(97)

Print Chr(97, 98, 99) ' prints abc

' s initially has the value "abc"

Dim s As String = Chr(97, 98, 99)

Print s
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
