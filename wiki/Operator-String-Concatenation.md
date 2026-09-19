[Home](Home) › [Operators](Category-Operators) › **Operator + (String Concatenation)**

# Operator + (String Concatenation)

Concatenates two strings

## Syntax

```freebasic
Declare Operator + ( ByRef lhs As String, ByRef rhs As String ) As String
Declare Operator + ( ByRef lhs As ZString, ByRef rhs As ZString ) As ZString
Declare Operator + ( ByRef lhs As WString, ByRef rhs As WString ) As WString
```

## Parameters

- `lhs`
- `rhs`

## Description

This operator concatenates two strings. Unlike [Operator & (String Concatenation With Conversion)](Operator-String-Concatenation-with-Conversion) both expressions *must* be strings, and may not be converted (in fact, any attempt to concatenate a string with a non-string or two non-strings will result in a type mismatch error, with the exception of when operator overloading is used in a UDT).

## Remarks

### Usage

`result = lhs + rhs`

### Differences from QB

- None

### See also

- [Operator + (Add)](Operator-Addition)
- [Operator & (String Concatenation With Conversion)](Operator-String-Concatenation-with-Conversion)
- [`Str`](Str)

## Examples

```freebasic
Dim As String a = "Hello, ", b = "World!"

Dim As String c

c = a + b

Print c
```

 Output:

```freebasic
Hello, World!
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
