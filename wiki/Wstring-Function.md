[Home](Home) › [String Functions](Category-String-Functions) › **Wstring (Function)**

# Wstring (Function)

Returns a wide string of n copies of one character.

## Syntax

```freebasic
Declare Function WString ( ByVal count As Integer, ByVal ch_code As Long ) As WString
Declare Function WString ( ByVal count As Integer, ByRef ch As Const WString ) As WString
```

## Parameters

- `count`
- `ch_code`
- `ch`

## Description

`WString` generates a temporary [`WString`](Wstring) filled with `count` copies of a Unicode character. This string can be printed or assigned to a previously [`Dim`](Dim)ed [`WString`](Wstring).

## Return Value

The created [`WString`](Wstring). An empty string will be returned if either `ch` is an empty string, or `count <= 0`.

## Remarks

### Usage

```freebasic
result = WString( count, ch_code )

or

result = WString( count, ch )
```

### Platform Differences

- Unicode strings are not supported in the DOS port of FreeBASIC.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Wstring`.

### Differences from QB

- QBasic does not support Unicode

### See also

- `String (data type)`
- [`WSpace`](Wspace)
- `WString (data type)`

## Examples

```freebasic
Print WString( 4, 934 )

Print WString( 5, WStr("Indeed") )

End 0
```

ΦΦΦΦ  
IIIII

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
