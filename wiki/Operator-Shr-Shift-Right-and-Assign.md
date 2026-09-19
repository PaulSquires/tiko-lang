[Home](Home) › [Operators](Category-Operators) › **Operator Shr= (Shift Right And Assign)**

# Operator Shr= (Shift Right And Assign)

Shifts right and assigns a value to a variable

## Syntax

```freebasic
Declare Operator Shr= ( ByRef lhs As Integer, ByRef rhs As Integer )
Declare Operator Shr= ( ByRef lhs As UInteger, ByRef rhs As UInteger )
Declare Operator Shr= ( ByRef lhs As LongInt, ByRef rhs As LongInt )
Declare Operator Shr= ( ByRef lhs As ULongInt, ByRef rhs As ULongInt )
```

## Parameters

- `lhs`
- `rhs`
- `lhs`

## Description

This operator shifts the bits in its left-hand side (`lhs`) parameter a number of times specified by its right-hand side (`rhs`) parameter, and assigns the result to `lhs`. It is functionally equivalent to:

`lhs = lhs Shr rhs`

This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Shr=>' can be also used.*

## Remarks

### Usage

`lhs shr= rhs`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Shr=`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator Shr (Shift Right)`](Operator-Shr-Shift-Right)
- [`Operator Shl= (Shift Left And Assign)`](Operator-Shl-Shift-Left-and-Assign)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim i As Integer

i = &b00011000   '' = 24

i Shr= 3         '' = i\2^3

'' Result: 11          3            3

Print Bin(i), i, 24\2^3

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
