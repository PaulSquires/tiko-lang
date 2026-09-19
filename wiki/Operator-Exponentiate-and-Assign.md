[Home](Home) › [Operators](Category-Operators) › **Operator ^= (Exponentiate And Assign)**

# Operator ^= (Exponentiate And Assign)

Exponentiates and assigns a value to a variable

## Syntax

```freebasic
Declare Operator ^= ( ByRef lhs As Double, ByRef rhs As Double )
```

## Parameters

- `lhs`
- `rhs`
- `lhs`

## Description

This operator exponentiates and assigns a value to a variable. It is functionally equivalent to:

`lhs = lhs ^ rhs`

This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 Note: This operator exists in C/C++ with a different meaning - there it performs a Bitwise [`Xor=`](Operator-Xor-Exclusive-Disjunction-and-Assign).
 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol '^=>' can be also used.*

## Remarks

### Usage

`lhs ^= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator ^ (Exponentiate)`](Operator-Exponentiate)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

n = 6

n ^= 2

Print n

Sleep
```

 Output:

```freebasic
36
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
