[Home](Home) › [Operators](Category-Operators) › **Operator + (Addition)**

# Operator + (Addition)

Sums two expressions

## Syntax

```freebasic
Declare Operator + ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator + ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
Declare Operator + ( ByRef lhs As Single, ByRef rhs As Single ) As Single
Declare Operator + ( ByRef lhs As Double, ByRef rhs As Double ) As Double
Declare Operator + ( ByRef lhs As T Pointer, ByRef rhs As Integer ) As T Pointer
Declare Operator + ( ByRef rhs As Integer, ByRef lhs As T Pointer ) As T Pointer
Declare Operator + ( ByRef lhs As T, ByRef rhs As Integer ) As T
Declare Operator + ( ByRef lhs As Integer, ByRef rhs As T ) As T
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

When the left and right-hand side expressions are numeric values, **`Operator +` (Add)** returns the sum of the two values.

 When the left and right-hand side expressions are string values, **`Operator +` (Add)** concatenates the two strings and returns the result.

 If an integral value `n` is added to a `T Pointer` type, the operator performs pointer arithmetic on the address, returning the memory position of a `T` value, `n` indices away (assuming `n` is within bounds of a contiguous array of `T` values). This behaves differently from numeric addition, because the [`Integer`](Integer) value is scaled by `SizeOf( T )`.

 Neither operand is modified in any way.

 This operator can be overloaded to accept user-defined types.

## Return Value

Returns the sum of two expressions.

## Remarks

### Usage

`result = lhs`+`rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator + (String Concatenation)](Operator-String-Concatenation)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Single

n = 4.75 + 5.25

Print n
```

 will produce the output:

```freebasic
10
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
