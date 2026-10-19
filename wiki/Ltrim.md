[Home](Home) › [String Functions](Category-String-Functions) › **LTrim**

# LTrim

Removes spaces, or the given characters, from the start.

## Syntax

```freebasic
Declare Function LTrim ( ByRef str As Const String, [ Any ] ByRef trimset As Const String = " " ) As String
Declare Function LTrim ( ByRef str As Const WString, [ Any ] ByRef trimset As Const WString = WStr(" ") ) As WString
```

## Parameters

- `str`
- `trimset`

## Description

This procedure trims surrounding characters from the left (beginning) of a source string:

All comparisons are case-sensitive.

## Return Value

Returns the trimmed string.

## Remarks

### Usage

`result = LTrim[$]( str [, [ Any ] trimset ] )`

### Platform Differences

- DOS version/target of FreeBASIC does not support the wide-character version of `LTrim`.

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- QB does not support specifying a `trimset` string or the `ANY` clause.

### See also

- [`RTrim`](Rtrim)
- [`Trim`](Trim)

## Examples

```freebasic
Dim s1 As String = "  101 Things to do."

Print "'" + LTrim(s1) + "'"

Print "'" + LTrim(s1, " 01") + "'"

Print "'" + LTrim(s1, Any " 01") + "'"

Dim s2 As String = "BaaBaaBAA Test Pattern"

Print "'" + LTrim(s2, "Baa") + "'"

Print "'" + LTrim(s2, Any "BaA") + "'"
```

 will produce the output:

```freebasic
'101 Things to do.'
'  101 Things to do.'
'Things to do.'
'BAA Test Pattern'
' Test Pattern'
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
