[Home](Home) › [Operators](Category-Operators) › **Operator \ (Integer Divide)**

# Operator \ (Integer Divide)

Divides two Integer expressions

## Syntax

```freebasic
Declare Operator \ ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator \ ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator \` (Integer division)** divides two [`Integer`](Integer) expressions and returns the result. Float numeric values are converted to [`Integer`](Integer) by rounding up or down, and the fractional part of the resulting quotient is truncated.

 If the divisor (`rhs`) is zero (`0`), a division by zero error (crash) will be raised.

 Neither of the operands are modified in any way.

 This operator can be overloaded for user-defined types.

## Return Value

Returns the quotient of an [`Integer`](Integer) dividend and divisor.

## Remarks

### Usage

`result = lhs`\\`rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator / (Floating-Point Divide)](Operator-Divide)
- [Operator Mod (Modulus)](Operator-Mod-Modulus)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

Print n \ 5

n = 7 \ 2.6  '' => 7 \ 3  => 2.33333  => 2

Print n

n = 7 \ 2.4  '' => 7 \ 2 => 3.5 => 3

Print n

Sleep
```

 Output:

```freebasic
0
2
3
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
