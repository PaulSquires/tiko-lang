[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CShort**

# CShort

Converts numeric or string expression to an integer (Short)

## Syntax

```freebasic
Declare Function CShort ( ByVal expression As datatype ) As Short
Type typename
Declare Operator Cast ( ) As Short
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CShort` function rounds off the decimal part and returns a 16-bit [`Short`](Short) value. The function does not check for an overflow, and results are undefined for values which are less than `-32` `768` or larger than `32` `767`.

 The name can be explained as 'Convert to Short'.

 If the argument is a string expression, it is converted to numeric by using [`ValInt`](Valint).

## Return Value

A [`Short`](Short) value.

## Remarks

### Usage

```freebasic
result = CShort( numeric expression )

result = CShort( string expression )

result = CShort( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cshort`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CByte`](Cbyte)
- [`CUByte`](Cubyte)
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
' Using the CSHORT function to convert a numeric value

'Create an SHORT variable

Dim numeric_value As Short

'Convert a numeric value

numeric_value = CShort(-4500.66)

'Print the result, should return -4501

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
