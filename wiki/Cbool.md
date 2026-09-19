[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CBool**

# CBool

Converts numeric or string expression to a boolean (Boolean)

## Syntax

```freebasic
Declare Function CBool ( ByVal expression As datatype ) As Boolean
Type typename
Declare Operator Cast ( ) As Boolean
End Type
```

## Parameters

- `expression`
- `datatype`
- `typename`

## Description

The `CBool` function converts a zero value to [`False`](False) and a non-zero value to [`True`](True).

 The name can be explained as 'Convert to Boolean'.

 If the argument is a string expression, it is converted to boolean using a case insensitive to the string "false" to return a [`False`](False) value or "true" to return a [`True`](True) value.

## Return Value

A [`Boolean`](Boolean) value.

## Remarks

### Usage

```freebasic
result = CBool( numeric expression )

result = CBool( string expression )

result = CBool( user defined type )
```

### Version

- Since fbc 1.04.0

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cbool`.

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
- [`CULngInt`](Culngint)
- [`CSng`](Csng)
- [`CDbl`](Cdbl)
- [`Str`](Str)

## Examples

```freebasic
' Using the CBOOL function to convert a numeric value

'Create an BOOLEAN variable

Dim b As Boolean

'Convert a numeric value

b = CBool(1)

'Print the result, should return True

Print b

Sleep
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
