[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CUByte**

# CUByte

Converts numeric or string expression to an unsigned byte (UByte)

## Syntax

```freebasic
Declare Function CUByte ( ByVal expression As datatype ) As UByte
Type typename
Declare Operator Cast ( ) As UByte
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CUByte` function rounds off the decimal part and returns a 8-bit [`UByte`](Ubyte) value. The function does not check for an overflow, and results are undefined for values which are less than `0` or larger than `255`.

 The name can be explained as 'Convert to Unsigned Byte'.

 If the argument is a string expression, it is converted to numeric by using [`ValUInt`](Valuint).

## Return Value

A [`UByte`](Ubyte) value.

## Remarks

### Usage

```freebasic
result = CUByte( numeric expression )

result = CUByte( string expression )

result = CUByte( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cubyte`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CByte`](Cbyte)
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
' Using the CUBYTE function to convert a numeric value

'Create an UNSIGNED BYTE variable

Dim numeric_value As UByte

'Convert a numeric value

numeric_value = CUByte(123.55)

'Print the result, should return 124

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
