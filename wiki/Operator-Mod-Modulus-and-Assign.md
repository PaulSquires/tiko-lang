[Home](Home) › [Operators](Category-Operators) › **Operator Mod= (Modulus And Assign)**

# Operator Mod= (Modulus And Assign)

Divides a value and assigns the remainder to a variable

## Syntax

```freebasic
Declare Operator Mod= ( ByRef lhs As Integer, ByRef rhs As Integer )
```

## Parameters

- `lhs`
- `rhs`
- `lhs`

## Description

This operator divides two values of [`Integer`](Integer) type and assigns the remainder to its left-hand side (`lhs`) variable. It is functionally equivalent to:

`lhs = lhs Mod rhs`

This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Mod=>' can be also used.*

## Remarks

### Usage

`lhs Mod= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator Mod (Modulus)`](Operator-Mod-Modulus)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Integer

n = 11

n Mod= 3

'' The result is 2

Print n

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
