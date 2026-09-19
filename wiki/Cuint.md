[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CUInt**

# CUInt

Converts numeric or string expression to a UInteger or UInteger<bits>

## Syntax

```freebasic
Declare Function CUInt ( ByVal expression As datatype ) As UInteger
Declare Function CUInt<bits> ( ByVal expression As datatype ) As UInteger<bits>
Type typename
Declare Operator Cast ( ) As UInteger
Declare Operator Cast ( ) As UInteger<bits>
End Type
```

## Parameters

- `bits`
- `expression`
- `datatype`
- `typename`

## Description

The `CUInt` function rounds off the decimal part and returns a [`UInteger`](Uinteger) value, or if a `bits` value is supplied, an unsigned integer type of the given size.

 The function does not check for an overflow; for example, for a 32-bit [`UInteger`](Uinteger) results are undefined for values which are less than `0` or larger than `4` `294` `967` `296`.

 The name can be explained as 'Convert to Unsigned INTeger'.

 If the argument is a string expression, it is converted to numeric by using [`ValUInt`](Valuint) or [`ValULng`](Valulng), depending on the size of the result type.

## Return Value

A [`UInteger`](Uinteger) or `UInteger<bits>` containing the converted value.

## Remarks

### Usage

```freebasic
result = CUInt( numeric expression )

result = CUInt( string expression )

result = CUInt( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cuint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CByte`](Cbyte)
- [`CUByte`](Cubyte)
- [`CShort`](Cshort)
- [`CUShort`](Cushort)
- [`CInt`](Cint)
- [`CLng`](Clng)
- [`CULng`](Culng)
- [`CLngInt`](Clngint)
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)
- [`UInteger`](Uinteger)

## Examples

```freebasic
' Using the CUINT function to convert a numeric value

'Create an UNSIGNED INTEGER variable

Dim numeric_value As UInteger

'Convert a numeric value

numeric_value = CUInt(300.23)

'Print the result = 300

Print numeric_value
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
