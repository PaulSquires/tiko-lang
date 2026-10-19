[Home](Home) › [String Functions](Category-String-Functions) › **InStrRev**

# InStrRev

Returns the position of the last match, or 0 if there is none.

## Syntax

```freebasic
Declare Function InStrRev ( ByRef str As Const String, [ Any ] ByRef substring As Const String, ByVal start As Integer = -1 ) As Integer
Declare Function InStrRev ( ByRef str As Const WString, [ Any ] ByRef substring As Const WString, ByVal start As Integer = -1 ) As Integer
```

## Parameters

- `str`
- `substring`
- `start`
- `str`

## Description

Locates the position of the last occurrence of a substring or character within a string. If `start` parameter is not given or is less than zero, the search begins at the last character.

 Zero (0) is returned if:

If the `Any` keyword is specified, `InStrRev` returns the last occurrence of any character in `substring`.

## Return Value

The position of the last occurrence of `substring` in `str`.

## Remarks

### Usage

`last = InStrRev( str, [ Any ] substring [, start ] )`

### Platform Differences

- The wide-character string version of `InStrRev` is not supported for DOS target.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Instrrev`.

### Differences from QB

- New to FreeBASIC

### See also

- [`InStr`](Instr)
- [`Mid (Function)`](Mid-Function)

## Examples

```freebasic
' It will return 4

Print InStrRev("abcdefg", "de")

' It will return 0

Print InStrRev("abcdefg", "h")
```

```freebasic
Dim test As String

Dim idx As Integer

test = "abababab"

idx = InStrRev(test, "b")

Do While idx > 0 'if not found loop will be skipped

    Print """b"" at " & idx

    idx = InStrRev(Test, "b", idx - 1)

Loop
```

'A Unicode example:  
dim text as wstring\*20  
text = "Привет, мир!"  
print instrrev(text,"ет") ' displays 5

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
