[Home](Home) › [Operators](Category-Operators) › **Operator & (String Concatenation With Conversion)**

# Operator & (String Concatenation With Conversion)

Concatenates two strings, converting non-strings to strings as needed

## Syntax

```freebasic
Declare Operator & ( ByRef lhs As T, ByRef rhs As U ) As V
```

## Parameters

- `lhs`
- `T`
- `rhs`
- `U`
- `V`

## Description

This operator concatenates two expressions. If either of the expressions is not a string type, it is converted to [`String`](String) with [`Str`](Str).

 If either of the expressions is a [`WString`](Wstring), a [`WString`](Wstring) is returned, otherwise a [`String`](String) is returned.

 This operator can be overloaded to accept user-defined types.

 Note: This operator exists in C/C++ with a different meaning - there it performs a bitwise [And](Operator-and-Conjunction).

## Remarks

### Usage

`result = lhs & rhs`

### Differences from QB

- New to FreeBASIC

### See also

- [Operator + (String Concatenation)](Operator-String-Concatenation)
- [`Str`](Str)

## Examples

```freebasic
Dim As String A,C

Dim As Single B

A="The result is: "

B=124.3

C=A & B

Print C

Sleep
```

 Output:

```freebasic
The result is: 124.3
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
