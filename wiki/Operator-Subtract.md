[Home](Home) › [Operators](Category-Operators) › **Operator - (Subtract)**

# Operator - (Subtract)

Subtracts two expressions

## Syntax

```freebasic
Declare Operator - ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator - ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
Declare Operator - ( ByRef lhs As Single, ByRef rhs As Single ) As Single
Declare Operator - ( ByRef lhs As Double, ByRef rhs As Double ) As Double
Declare Operator - ( ByRef lhs As T Pointer, ByRef rhs As T Pointer ) As Integer
Declare Operator - ( ByRef lhs As T Pointer, ByRef rhs As Integer ) As T Pointer
Declare Operator - ( ByRef lhs As T, ByRef rhs As T ) As Integer
Declare Operator - ( ByRef lhs As T, ByRef rhs As Integer ) As T
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

When the left and right-hand side expressions are numeric values, **`Operator -` (Subtract)** returns the subtraction of the two values.

 If the left and right-hand side expressions are both of the `T Pointer` type, for some type `T`, the operator performs pointer subtraction on the address, returning the result. This is different from numeric subtraction because the difference is divided by `SizeOf( T )`.

 If an integral value `n` is subtracted from a `T Pointer` type, the operator performs pointer arithmetic on the address, returning the memory position of a `T` value, `n` indices before (assuming `(-n)` is within bounds of a contiguous array of `T` values). This behaves differently from numeric subtraction, because the [`Integer`](Integer) value is scaled by `SizeOf( T )`.

 Neither operand is modified in any way.

 This operator can be overloaded to accept user-defined types.

## Return Value

Returns the subtraction of two expressions.

## Remarks

### Usage

`result = lhs`-`rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Single

n = 4 - 5

Print n
```

 will produce the output:

```freebasic
-1
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
