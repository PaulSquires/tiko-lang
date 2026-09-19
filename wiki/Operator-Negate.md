[Home](Home) › [Operators](Category-Operators) › **Operator - (Negate)**

# Operator - (Negate)

Changes the sign of a numeric expression

## Syntax

```freebasic
Declare Operator - ( ByRef rhs As Integer ) As Integer
Declare Operator - ( ByRef rhs As Single ) As Single
Declare Operator - ( ByRef rhs As Double ) As Double
```

## Parameters

- `rhs`

## Description

**`Operator -` (Negate)** is a unary operator that negates the value of its operand.

 The operand is not modified in any way.

 This operator can be overloaded for user-defined types.

## Return Value

Returns the negative of the expression.

## Remarks

### Usage

`result = - rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As LongInt

Print -5

n = 65432568459

n = - n

Print n

Sleep
```

 Output:

```freebasic
-5
-65432568459
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
