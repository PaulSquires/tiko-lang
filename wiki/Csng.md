[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CSng**

# CSng

Converts a number or string to a Single.

## Syntax

```freebasic
Declare Function CSng ( ByVal expression As datatype ) As Single
Type typename
Declare Operator Cast ( ) As Single
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CSng` function returns a 32-bit [`Single`](Single) value. The function does not check for an overflow, so be sure not to pass a value outside the representable range of the [`Single`](Single) data type. The name can be explained as 'Convert to SiNGle'.

 If the argument to `CSng` is a string expression, it is first converted to numeric by using [`Val`](Val).

## Return Value

A [`Single`](Single) precision value.

## Remarks

### Usage

```freebasic
result = CSng( numeric expression )

result = CSng( string expression )

result = CSng( user defined type )
```

### Differences from QB

- The string argument was not allowed in QB

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
- [`CULngInt`](Culngint)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CSNG function to convert a numeric value

'Create an SINGLE variable

Dim numeric_value As Single

'Convert a numeric value

numeric_value = CSng(-12345.123)

'Print the result, should return -12345.123

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
