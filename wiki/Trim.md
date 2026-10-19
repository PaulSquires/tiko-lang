[Home](Home) › [String Functions](Category-String-Functions) › **Trim**

# Trim

Removes spaces, or the given characters, from both ends.

## Syntax

```freebasic
Declare Function Trim ( ByRef str As Const String, [ Any ] ByRef trimset As Const String = " " ) As String
Declare Function Trim ( ByRef str As Const WString, [ Any ] ByRef trimset As Const WString = WStr(" ") ) As WString
```

## Parameters

- `str`
- `trimset`

## Description

This procedure trims surrounding characters from the left (beginning) and right (end) of a source string:

All comparisons are case-sensitive.

## Return Value

Returns the trimmed string.

## Remarks

### Usage

`result = Trim[$]( str [, [ Any ] trimset ] )`

### Platform Differences

- DOS version/target of FreeBASIC does not support the wide-character version of `Trim`.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Trim`.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- New to FreeBASIC

### See also

- [LTrim](Ltrim)
- [RTrim](Rtrim)

## Examples

```freebasic
Dim s1 As String = " ... Stuck in the middle ... "

Print "'" + Trim(s1) + "'"

Print "'" + Trim(s1, Any " .") + "'"

Dim s2 As String = "BaaBaaaaB With You aaBBaaBaa"

Print "'" + Trim(s2, "Baa") + "'"

Print "'" + Trim(s2, Any "Ba") + "'"
```

 will produce the output:

```freebasic
'... Stuck in the middle ...'
'Stuck in the middle'
'aaB With You aaB'
' With You '
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
