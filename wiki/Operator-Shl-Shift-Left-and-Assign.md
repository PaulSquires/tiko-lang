[Home](Home) › [Operators](Category-Operators) › **Operator Shl= (Shift Left And Assign)**

# Operator Shl= (Shift Left And Assign)

Shifts left and assigns a value to a variable

## Syntax

```freebasic
Declare Operator Shl= ( ByRef lhs As Integer, ByRef rhs As Integer )
Declare Operator Shl= ( ByRef lhs As UInteger, ByRef rhs As UInteger )
Declare Operator Shl= ( ByRef lhs As LongInt, ByRef rhs As LongInt )
Declare Operator Shl= ( ByRef lhs As ULongInt, ByRef rhs As ULongInt )
```

## Parameters

- `lhs`
- `rhs`
- `lhs`

## Description

This operator shifts the bits in its left-hand side (`lhs`) parameter a number of times specified by its right-hand side (`rhs`) parameter, and assigns the result to `lhs`. It is functionally equivalent to:

`lhs = lhs Shl rhs`

This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Shl=>' can be also used.*

## Remarks

### Usage

`lhs shl= rhs`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Shl=`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator Shl (Shift Left)`](Operator-Shl-Shift-Left)
- [`Operator Shr= (Shift Right And Assign)`](Operator-Shr-Shift-Right-and-Assign)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim i As Integer

i = &b00000011   '' = 3

i Shl= 3         '' = i*2^3

'' Result: 11000          24            24

Print Bin(i), i, 3*2^3

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
