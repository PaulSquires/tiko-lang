[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CDbl**

# CDbl

Converts a number or string to a Double.

## Syntax

```freebasic
Declare Function CDbl ( ByVal expression As datatype ) As Double
Type typename
Declare Operator Cast ( ) As Double
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CDbl` function returns a 64-bit [`Double`](Double) value. The function does not check for an overflow, so be sure not to pass a value outside the representable range of the [`Double`](Double) data type. The name can be explained as 'Convert to DouBLe'.

 If the argument to `CDbl` is a string expression, it is first converted to numeric by using [`Val`](Val).

## Return Value

A [`Double`](Double) precision value.

## Remarks

### Usage

```freebasic
result = CDbl( numeric expression )

result = CDbl( string expression )

result = CDbl( user defined type )
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
- [`CSng`](Csng)

## Examples

```freebasic
' Using the CDBL function to convert a numeric value

'Create an DOUBLE variable

Dim numeric_value As Double

'Convert a numeric value

numeric_value = CDbl(-12345678.123)

'Print the result, should return -12345678.123

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
