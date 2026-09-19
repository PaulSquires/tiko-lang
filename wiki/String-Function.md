[Home](Home) › [String Functions](Category-String-Functions) › **String (Function)**

# String (Function)

Creates and fills a string of a certain length with a certain character

## Syntax

```freebasic
Declare Function String ( ByVal count As Integer, ByVal ch_code As Long ) As String
Declare Function String ( ByVal count As Integer, ByRef ch As Const String ) As String
```

## Parameters

- `count`
- `ch_code`
- `ch`

## Description

The `String` function returns a string with a length of `count`, filled with a given `ch_code` or `ch`.

## Return Value

The created string. An empty string will be returned if either `ch` is an empty string, or `count` <= 0.

## Remarks

### Usage

`result = String[$]( count, ch_code )`*or*`result = String[$]( count, ch )`

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- None

### See also

- `String (data type)`
- [`Space`](Space)

## Examples

```freebasic
Print String( 4, 69 )         '' prints "EEEE"

Print String( 5, "Indeed" )   '' prints "IIIII"

End 0
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
