[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **Val**

# Val

Converts a string to a floating point number

## Syntax

```freebasic
Declare Function Val ( ByRef str As Const String ) As Double
Declare Function Val ( ByRef str As Const WString ) As Double
```

## Parameters

- `strnum`

## Description

`Val("10")` will return `10.0`, and `Val("10.10")` will return `10.1`. The function parses the string from the left, skipping any white space, and returns the longest number it can read, stopping at the first non-suitable character it finds. Scientific notation is recognized, with `"D"` or `"E"` used to specify the exponent.

 `Val` can be used to convert integer numbers in binary / octal / hexadecimal format, if they have the relevant identifier (`"&B"` / `"&O"` / `"&H"`) prefixed, for example: `Val("&HFF")` returns `255`.

 **Note**:
 If you want to get an integer value from a string, consider using [`ValInt`](Valint) or [`ValLng`](Vallng) instead. They are faster, since they don't use floating-point numbers, and only [`ValLng`](Vallng) provides full 64-bit precision for [`LongInt`](Longint) types.

 If you want to convert a number into string format, use the [`Str`](Str) function.

## Return Value

Returns a converted [`Double`](Double) precision number

 If the first character of the string is invalid, `Val` will return `0`.

## Remarks

### Usage

`result = Val( strnum )`

### Differences from QB

- None

### See also

- [`CDbl`](Cdbl)
- [`ValInt`](Valint)
- [`ValUInt`](Valuint)
- [`ValLng`](Vallng)
- [`ValULng`](Valulng)
- [`Str`](Str)
- [`Chr`](Chr)
- [`Asc`](Asc)

## Examples

```freebasic
Dim a As String, b As Double

a = "2.1E+30xa211"

b = Val(a)

Print a, b
```

```freebasic
2.1E+30xa211   2.1e+030
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
