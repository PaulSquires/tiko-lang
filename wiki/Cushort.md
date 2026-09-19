[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CUShort**

# CUShort

Converts numeric or string expression to an unsigned integer (UShort)

## Syntax

```freebasic
Declare Function CUShort ( ByVal expression As datatype ) As UShort
Type typename
Declare Operator Cast ( ) As UShort
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CUShort` function rounds off the decimal part and returns a 16-bit [`UShort`](Ushort) value. The function does not check for an overflow, and results are undefined for values which are less than `0` or larger than `65` `535`.

 The name can be explained as 'Convert to Unsigned Short'.

 If the argument is a string expression, it is converted to numeric by using [`ValUInt`](Valuint).

## Return Value

A [`UShort`](Ushort) value.

## Remarks

### Usage

```freebasic
result = CUShort( numeric expression )

result = CUShort( string expression )

result = CUShort( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cushort`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CByte`](Cbyte)
- [`CUByte`](Cubyte)
- [`CShort`](Cshort)
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
' Using the CUSHORT function to convert a numeric value

'Create an USHORT variable

Dim numeric_value As UShort

'Convert a numeric value

numeric_value = CUShort(36000.4)

'Print the result, should return 36000

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
