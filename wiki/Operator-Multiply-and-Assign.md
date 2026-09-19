[Home](Home) › [Operators](Category-Operators) › **Operator *= (Multiply And Assign)**

# Operator *= (Multiply And Assign)

Multiplies and assigns a value to a variable

## Syntax

```freebasic
Declare Operator *= ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`

## Description

This operator multiplies and assigns a value to a variable. It is functionally equivalent to:

`lhs = lhs * rhs`

The right-hand side expression (`rhs`) will be converted to the left-hand side type (`T1`).

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol '\*=>' can be also used.*

## Remarks

### Usage

`lhs *= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator * (Multiply)`](Operator-Multiply)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

n = 6

n *= 2

Print n

Sleep
```

 Output:

```freebasic
12
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
