[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CInt**

# CInt

Converts a numeric or string expression to an Integer or an Integer<bits>

## Syntax

```freebasic
Declare Function CInt ( ByVal expression As datatype ) As Integer
Declare Function CInt<bits> ( ByVal expression As datatype ) As Integer<bits>
Type typename
Declare Operator Cast ( ) As Integer
Declare Operator Cast ( ) As Integer<bits>
End Type
```

## Parameters

- `bits`
- `expression`
- `datatype`
- `typename`

## Description

If `CInt` is passed a numeric `expression`, it rounds it using using the [round-to-even method](http://en.wikipedia.org/wiki/Rounding#Round-to-even_method) - i.e. it rounds to the closest integer value, choosing the closest even integer if the number is equidistant from two integers - and returns an [`Integer`](Integer), or if a `bits` value is supplied, an integer type of the given size.

 The function does not check for an overflow; for example, for a 32-bit [`Integer`](Integer) the results are undefined for values which are less than `-2` `147` `483` `648` or larger than `2` `147` `483` `647`.

 If the argument is a string expression, it is converted to numeric by using [`ValInt`](Valint) or [`ValLng`](Vallng), depending on the size of the result type.

 The name "CINT" is derived from 'Convert to INTeger'.

## Return Value

An [`Integer`](Integer) or `Integer<bits>` containing the converted value.

## Remarks

### Usage

```freebasic
result = CInt( expression )

result = CInt( string expression )

result = CInt( user defined type )
```

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, `CInt` will return a 16-bit integer, like in QB.

### Differences from QB

- The string argument was not allowed in QB
- The `<bits>` parameter was not allowed in QB

### See also

- [`Cast`](Cast)
- [`CByte`](Cbyte)
- [`CUByte`](Cubyte)
- [`CShort`](Cshort)
- [`CUShort`](Cushort)
- [`CUInt`](Cuint)
- [`CLng`](Clng)
- [`CULng`](Culng)
- [`CLngInt`](Clngint)
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)
- [`Integer`](Integer)

## Examples

```freebasic
' Using the CINT function to convert a numeric value

'Create an INTEGER variable

Dim numeric_value As Integer

'Convert a numeric value

numeric_value = CInt(300.5)

'Print the result, should return 300, because 300 is even

numeric_value = CInt(301.5)

'Print the result, should return 302, because 301 is odd

Print numeric_value
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
