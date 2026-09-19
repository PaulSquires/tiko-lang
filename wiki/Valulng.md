[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **ValULng**

# ValULng

Converts a string to a unsigned 64bit integer

## Syntax

```freebasic
Declare Function ValULng ( ByRef strnum As Const String ) As ULongInt
Declare Function ValULng ( ByRef strnum As Const WString ) As ULongInt
```

## Parameters

- `strnum`

## Description

For example, `ValULng("10")` will return `10`, and `ValULng("10.60")` will return `10` as well. The function parses the string from the left, skipping any white space, and returns the longest number it can read, stopping at the first non-suitable character it finds. Any non-numeric characters, including decimal points and exponent specifiers, are considered non-suitable, for example, `ValULng("23.1E+6")` will just return `23`.

 `ValULng` can be used to convert integer numbers in [Binary](Bin) / [Octal](Oct) / [Hexadecimal](Hex) format, if they have the relevant identifier (`"&B"` / `"&O"` / `"&H"`) prefixed, for example: `ValULng("&HFF")` returns `255`.

 If you want to convert a number into string format, use the [`Str`](Str) function.

## Return Value

Returns a [`ULongInt`](Ulongint) of the converted string

 If the first character of the string is invalid, `ValULng` will return `0`.

## Remarks

### Usage

`result = ValULng ( strnum )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Valulng`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CULngInt`](Culngint)
- [`Val`](Val)
- [`ValUInt`](Valuint)
- [`ValLng`](Vallng)
- [`Str`](Str)
- [`Chr`](Chr)
- [`Asc`](Asc)

## Examples

```freebasic
Dim a As String, b As ULongInt

a = "20xa211"

b = ValULng(a)

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
