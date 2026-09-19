[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CULng**

# CULng

Converts numeric or string expression to ULong

## Syntax

```freebasic
Declare Function CULng ( ByVal expression As datatype ) As ULong
Type typename
Declare Operator Cast ( ) As ULong
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CULng` function rounds off the decimal part and returns a 32 bit [`ULong`](Ulong) value. The function does not check for an overflow. The name can be explained as 'Convert to Unsigned LoNG'.

 If the argument is a string expression, it is converted to numeric by using [`ValUInt`](Valuint) or [`ValULng`](Valulng).

## Return Value

A [`ULong`](Ulong) value.

## Remarks

### Usage

```freebasic
result = CULng( numeric expression )

result = CULng( string expression )

result = CULng( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Culng`.

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
- [`CLngInt`](Clngint)
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CULNG function to convert a numeric value

'Create an UNSIGNED LONG variable

Dim numeric_value As ULong

'Convert a numeric value

numeric_value = CULng(300.23)

'Print the result = 300

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
