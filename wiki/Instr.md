[Home](Home) › [String Functions](Category-String-Functions) › **InStr**

# InStr

Returns the position of the first match, or 0 if there is none.

## Syntax

```freebasic
Declare Function InStr ( ByRef str As Const String, [ Any ] ByRef substring As Const String ) As Integer
Declare Function InStr ( ByRef str As Const WString, [ Any ] ByRef substring As Const WString ) As Integer
Declare Function InStr ( ByVal start As Integer, ByRef str As Const String, [ Any ] ByRef substring As Const String ) As Integer
Declare Function InStr ( ByVal start As Integer, ByRef str As Const WString, [ Any ] ByRef substring As Const WString ) As Integer
```

## Parameters

- `str`
- `substring`
- `start`
- `str`

## Description

Locates the position of the first occurrence of a substring or character within a string. In the first form of `InStr` (without `start` parameter), the search begins at the first character.

 Zero (0) is returned if: either `substring` is not found, either `str` or `substring` are empty strings, or `start` < 1.

 If the `Any` keyword is specified, `InStr` returns the first occurrence of any character in `substring`.

## Return Value

The position of the first occurrence of `substring` in `str`.

## Remarks

### Usage

`first = InStr( [ start, ] str, [ Any ] substring )`

### Platform Differences

- The wide-character string version of `InStr` is not supported for DOS target.

### Differences from QB

- QB returns `start` if `search` is a zero length string.
- QB does not support Unicode.

### See also

- [`InStrRev`](Instrrev)
- [`Mid (Function)`](Mid-Function)

## Examples

```freebasic
' It will return 4

Print InStr("abcdefg", "de")

' It will return 0

Print InStr("abcdefg", "h")

' It will search for any of the characters "f", "b", "c", and return 2 as "b" is encountered first

Print InStr("abcdefg", Any "fbc")
```

```freebasic
Dim test As String

Dim idx As Integer

test = "abababab"

idx = InStr(test, "b")

Do While idx > 0 'if not found loop will be skipped

    Print """b"" at " & idx

    idx = InStr(idx + 1, Test, "b")

Loop
```

'A Unicode example:  
dim text as wstring\*20  
text = "Привет, мир!"  
print instr(text,"ет") ' displays 5

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
