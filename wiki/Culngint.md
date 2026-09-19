[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CULngInt**

# CULngInt

Converts numeric or string expression to 64-bit unsigned integer (ULongInt)

## Syntax

```freebasic
Declare Function CULngInt ( ByVal expression As datatype ) As ULongInt
Type typename
Declare Operator Cast ( ) As ULongInt
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CULngInt` function rounds off the decimal part and returns a 64-bit [`ULongInt`](Ulongint) value. The function does not check for an overflow, and results are undefined for values which are less than `0` or larger than `18` `446` `744` `073` `709` `551` `615`. Additionally, casts from floating-point expressions are currently not guaranteed to work for values higher than `2^63` (`9` `223` `372` `036` `854` `775` `808`).

 The name can be explained as 'Convert to Unsigned LoNG INTeger'.

 If the argument is a string expression, it is converted to numeric by using [`ValULng`](Valulng).

## Return Value

A [`ULongInt`](Ulongint) value.

## Remarks

### Usage

```freebasic
result = CULngInt( numeric expression )

result = CULngInt( string expression )

result = CULngInt( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Culngint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CByte`](Cbyte)
- [`CUByte`](Cubyte)
- [`CShort`](Cshort)
- [`CUShort`](Cushort)
- [`CInt`](Cint)
- [`CUInt`](Cuint)
- [`CLng`](Clng)
- [`CULng`](Culng)
- [`CLngInt`](Clngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CLNGINT function to convert a numeric value

'Create an UNSIGNED LONG INTEGER variable

Dim numeric_value As ULongInt

'Convert a numeric value

numeric_value = CULngInt(12345678.123)

'Print the result, should return 12345678

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
