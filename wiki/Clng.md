[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CLng**

# CLng

Converts numeric or string expression to Long

## Syntax

```freebasic
Declare Function CLng ( ByVal expression As datatype ) As Long
Type typename
Declare Operator Cast ( ) As Long
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CLng` function rounds off the decimal part and returns a 32-bit [`Long`](Long) value. The function does not check for an overflow, and results are undefined for values which are less than `-2` `147` `483` `648` or larger than `2` `147` `483` `647`.

 The name can be explained as 'Convert to LoNG'.

 If the argument is a string expression, it is converted to numeric by using [`ValInt`](Valint).

## Return Value

A [`Long`](Long) value.

## Remarks

### Usage

```freebasic
result = CLng( numeric expression )

result = CLng( string expression )

result = CLng( user defined type )
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
- [`CULng`](Culng)
- [`CLngInt`](Clngint)
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CLNG function to convert a numeric value

'Create an LONG variable

Dim numeric_value As Long

'Convert a numeric value

numeric_value = CLng(-300.23)

'Print the result, should return -300

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
