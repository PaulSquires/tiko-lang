[Home](Home) › [Operators](Category-Operators) › **Operator >= (Greater Than Or Equal)**

# Operator >= (Greater Than Or Equal)

Compares an expression greater than or equal to another expression

## Syntax

```freebasic
Declare Operator >= ( ByRef lhs As Byte, ByRef rhs As Byte ) As Integer
Declare Operator >= ( ByRef lhs As UByte, ByRef rhs As UByte ) As Integer
Declare Operator >= ( ByRef lhs As Short, ByRef rhs As Short ) As Integer
Declare Operator >= ( ByRef lhs As UShort, ByRef rhs As UShort ) As Integer
Declare Operator >= ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator >= ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As Integer
Declare Operator >= ( ByRef lhs As LongInt, ByRef rhs As LongInt ) As Integer
Declare Operator >= ( ByRef lhs As ULongInt, ByRef rhs As ULongInt ) As Integer
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

**`Operator >=` (Greater than or Equal)** is a binary operator that compares an expression greater than or equal to another expression and returns the result - a boolean value in the form of an [`Integer`](Integer): negative one (-1) for true and zero (0) for false. The arguments are not modified in any way.

 When this operator is applied to string type data, then a lexicographic/alphabetic order comparison is performed (ordered from the numeric ASCII values of the characters of the two strings).

 This operator can be overloaded to accept user-defined types as well.

## Return Value

Returns negative one (-1) if the left-hand side expression is greater than or equal to the right-hand side expression, or zero (0) if less than.

## Remarks

### Usage

`result = lhs >= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- none

### See also

- [`Operator <`](Operator-Less-Than) (Less than)

## Examples

[`Operator <`](Operator-Less-Than) (Less than) is complement to **`Operator >=` (Greater than or Equal)**, and is functionally identical when combined with [`Operator Not`](Operator-Not-Complement) (Bit-wise Complement).

```freebasic
If (420 >= 69) Then Print "(420 >= 69) is true."

   If Not (420 < 69) Then Print "not (420 < 69) is true."
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
