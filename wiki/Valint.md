[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **ValInt**

# ValInt

Converts a string to a 32bit integer

## Syntax

```freebasic
Declare Function ValInt ( ByRef strnum As Const String ) As Long
Declare Function ValInt ( ByRef strnum As Const WString ) As Long
```

## Parameters

- `strnum`

## Description

For example, `ValInt("10")` will return `10`, and `ValInt("10.60")` will return `10` as well. The function parses the string from the left, skipping any white space, and returns the longest number it can read, stopping at the first non-suitable character it finds. Any non-numeric characters, including decimal points and exponent specifiers, are considered non-suitable, for example, `ValInt("23.1E+6")` will just return `23`.

 `ValInt` can be used to convert integer numbers in [Binary](Bin) / [Octal](Oct) / [Hexadecimal](Hex) format, if they have the relevant identifier (`"&B"` / `"&O"` / `"&H"`) prefixed, for example: `ValInt("&HFF")` returns `255`.

 If you want to convert a number into string format, use the [`Str`](Str) function.

## Return Value

Returns a [`Long`](Long) value of the converted string

 If the first character of the string is invalid, `ValInt` will return `0`.

## Remarks

### Usage

`result = ValInt ( strnum )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Valint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CLng`](Clng)
- [`Val`](Val)
- [`ValUInt`](Valuint)
- [`ValLng`](Vallng)
- [`Str`](Str)
- [`Chr`](Chr)
- [`Asc`](Asc)

## Examples

```freebasic
Dim a As String, b As Long

a = "20xa211"

b = ValInt(a)

Print a, b
```

```freebasic
20xa211   20
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
