[Home](Home) › [Operators](Category-Operators) › **Operator ^ (Exponentiate)**

# Operator ^ (Exponentiate)

Raises a numeric expression to some power

## Syntax

```freebasic
Declare Operator ^ ( ByRef lhs As Double, ByRef rhs As Double ) As Double
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator ^` (Exponentiate)** returns the result of a base expression (`lhs`) raised to some exponent expression (`rhs`). `^` works with double float numbers only, operands of other types will be converted into double before performing the exponentiation. Exponent of a fractional value (`1/n`) is the same as taking `n`th root from the base, for example, `2 ^ (1/3)` is the cube root of 2.

 Neither of the operands are modified in any way.

 This operator can be overloaded for user-defined types.

 This operation is for [`Double`](Double) precision data types only (53 significant bits), and suffers from some inaccuracies in the least significant bits of the number, especially when converting from other data types (e.g. 64-bit data types). This inaccuracy is particularly noticeable when the result is expected to be an exact number, but then finding the result is out by a very small amount. For this reason, never assume that an exponentiation expression will be exactly equal to the value expected, but rather close within some small amount of error. Be wary of using rounding methods such as [`Int`](Int) and [`Fix`](Fix) on the result: if you expect the result to be an integer value, then there's a chance that it might be slightly lower, and will round down to a value that is one less than expected.

 This operator exists in C/C++ with a different meaning; in C/C++ it performs a Bitwise [`Xor`](Operator-Xor-Exclusive-Disjunction).

## Return Value

Returns the exponentiation of a base expression raised to some exponent.

## Remarks

### Usage

`result = lhs ^ rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim As Double n

Input "Please enter a positive number: ", n

Print

Print n;" squared is "; n ^ 2

Print "The fifth root of "; n;" is "; n ^ 0.2

Sleep
```

 Output:

```freebasic
Please enter a positive number: 3.4

 3.4 squared is 11.56
The fifth root of 3.4 is 1.27730844458754
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
