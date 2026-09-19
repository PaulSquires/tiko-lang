[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CLngInt**

# CLngInt

Converts numeric or string expression to 64-bit integer (LongInt)

## Syntax

```freebasic
Declare Function CLngInt ( ByVal expression As datatype ) As LongInt
Type typename
Declare Operator Cast ( ) As LongInt
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CLngInt` function rounds off the decimal part and returns a 64-bit [`LongInt`](Longint) value. The function does not check for an overflow, and results are undefined for values which are less than `-9` `223` `372` `036` `854` `775` `808` or larger than `223` `372` `036` `854` `775` `807`.

 The name can be explained as 'Convert to LoNG INTeger'.

 If the argument is a string expression, it is converted to numeric by using [`ValLng`](Vallng).

## Return Value

A [`LongInt`](Longint) value.

## Remarks

### Usage

```freebasic
result = CLngInt( numeric expression )

result = CLngInt( string expression )

result = CLngInt( user defined type )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Clngint`.

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
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)

## Examples

```freebasic
' Using the CLNGINT function to convert a numeric value

'Create an LONG INTEGER variable

Dim numeric_value As LongInt

'Convert a numeric value

numeric_value = CLngInt(-12345678.123)

'Print the result, should return -12345678

Print numeric_value

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
