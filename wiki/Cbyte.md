[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CByte**

# CByte

Converts a number or string to a Byte, rounding to the nearest; no overflow check.

## Syntax

```freebasic
Declare Function CByte ( ByVal expression As datatype ) As Byte
Type typename
Declare Operator Cast ( ) As Byte
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CByte` function rounds off the decimal part and returns a 8-bit [`Byte`](Byte) value. The function does not check for an overflow, and results are undefined for values which are less than `-128` or larger than `127`.

 The name can be explained as 'Convert to Byte'.

 If the argument is a string expression, it is converted to numeric by using [`ValInt`](Valint).

## Return Value

A [`Byte`](Byte) value.

## Remarks

### Usage

```freebasic
result = CByte( numeric expression )

result = CByte( string expression )

result = CByte( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cbyte`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CUByte`](Cubyte)
- [`CShort`](Cshort)
- [`CUShort`](Cushort)
- [`CInt`](Cint)
- [`CUInt`](Cuint)
- [`CLng`](Clng)
- [`CULng`](Culng)
- [`CLngInt`](Clngint)
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CBYTE function to convert a numeric value

'Create an BYTE variable

Dim numeric_value As Byte

'Convert a numeric value

numeric_value = CByte(-66.30)

'Print the result, should return -66

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
