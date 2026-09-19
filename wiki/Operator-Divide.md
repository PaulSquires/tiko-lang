[Home](Home) › [Operators](Category-Operators) › **Operator / (Divide)**

# Operator / (Divide)

Divides two numeric expressions

## Syntax

```freebasic
Declare Operator / ( ByRef lhs As Single, ByRef rhs As Single ) As Single
Declare Operator / ( ByRef lhs As Double, ByRef rhs As Double ) As Double
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator /` (Divide)** returns the quotient of a dividend and divisor.

 Neither operand is modified in any way. Unlike with integer division, float division by zero is safe to perform, the quotient will hold a special value representing infinity, converting it to a string returns something like "Inf" or "INF", exact text is platform specific.

 This operator can be overloaded to accept user-defined types.

## Return Value

Returns the quotient of a dividend and divisor.

## Remarks

### Usage

`result = lhs`/`rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator \\ (Integer Divide)](Operator-Integer-Divide)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

Print n / 5

n = 6 / 2.3

Print n

Sleep
```

 Output:

```freebasic
0
2.608695652173913
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
