[Home](Home) › [String Functions](Category-String-Functions) › **RTrim**

# RTrim

Removes spaces, or the given characters, from the end.

## Syntax

```freebasic
Declare Function RTrim ( ByRef str As Const String, [ Any ] ByRef trimset As Const String = " " ) As String
Declare Function RTrim ( ByRef str As Const WString, [ Any ] ByRef trimset As Const WString = WStr(" ") ) As WString
```

## Parameters

- `str`
- `trimset`

## Description

This procedure trims surrounding characters from the right (end) of a source string:

All comparisons are case-sensitive.

## Return Value

Returns the trimmed string.

## Remarks

### Usage

`result = RTrim[$]( str [, [ Any ] trimset ] )`

### Platform Differences

- DOS version/target of FreeBASIC does not support the wide-character version of `RTrim`.

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- QB does not support specifying a `trimset` string or the `ANY` clause.

### See also

- [`LTrim`](Ltrim)
- [`Trim`](Trim)

## Examples

```freebasic
Dim s1 As String = "Article 101  "

Print "'" + RTrim(s1) + "'"

Print "'" + RTrim(s1, " 01") + "'"

Print "'" + RTrim(s1, Any " 10") + "'"

Dim s2 As String = "Test Pattern aaBBaaBaa"

Print "'" + RTrim(s2, "Baa") + "'"

Print "'" + RTrim(s2, Any "Ba") + "'"
```

 will produce the output:

```freebasic
'Article 101'
'Article 101  '
'Article'
'Test Pattern aaB'
'Test Pattern '
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
