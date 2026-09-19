[Home](Home) › [Operators](Category-Operators) › **Operator * (Multiply)**

# Operator * (Multiply)

Multiplies two numeric expressions

## Syntax

```freebasic
Declare Operator * ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator * ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
Declare Operator * ( ByRef lhs As Single, ByRef rhs As Single ) As Single
Declare Operator * ( ByRef lhs As Double, ByRef rhs As Double ) As Double
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator *` (Multiply)** returns the product of two multiplicands.

 Neither operand is modified in any way.

 This operator can be overloaded to accept user-defined types.

## Return Value

Returns the product of two multiplicands.

## Remarks

### Usage

`result = lhs`\*`rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

n = 4 * 5

Print n

Sleep
```

 Output:

```freebasic
20
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
